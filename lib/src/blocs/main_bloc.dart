import 'dart:async';

import '../mixins/validators.dart';
import '../models/pack_model.dart';
import '../models/card_model.dart';
import '../models/user_model.dart';

import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

class MainState {
  int viewIndex;
  List<PackModel> packs;
  List<CardModel> deck;

  MainState(this.viewIndex, this.packs, this.deck);
}

class MainBloc extends Validators {

  final geo = Geoflutterfire();
  final firestore = Firestore.instance;

  final _navController = BehaviorSubject<int>();
  final _packsController = BehaviorSubject<List<PackModel>>();
  final _deckController = BehaviorSubject<List<CardModel>>();
  final _logsController = BehaviorSubject<List<Map<String, dynamic>>>();
  final _timeController = BehaviorSubject<DateTime>();
  final _geoController = BehaviorSubject<GeoFirePoint>();

  Stream<List<Map<String, dynamic>>> get logStream => _logsController.stream;
  Stream<DateTime> get timeStream => _timeController.stream;
  Stream<GeoFirePoint> get geoStream => _geoController.stream;

  Stream<int> get navStream => _navController.stream;
  Stream<List<PackModel>> get packStream => _packsController.stream;
  Stream<List<CardModel>> get deckStream => _deckController.stream;
  //not including logs/time/geo streams in the stateStream since they currently have no relevance on the front-end of the app
  //stateStream is listened to by the frontend for new data that requires re-rendering
  Stream<MainState> get stateStream => Observable.combineLatest3(navStream, packStream, deckStream, (n, p, d) => MainState(n, p, d));

  //current state - get latest emitted value from stream
  int get currentView => _navController.value;
  List<PackModel> get currentPacks => _packsController.value;
  List<CardModel> get currentDeck => _deckController.value;
  List<Map<String, dynamic>> get currentLogs => _logsController.value;
  DateTime get lastCheckTime => _timeController.value;
  GeoFirePoint get lastCheckPoint => _geoController.value;

  // TODO: for combineLatest to emit a first event, all derivative streams must emit an event first - so we need a good way to initialize all data streams with defaults
  //find a way to avoid this or better initiate these if necessary
  MainBloc() {
    _navController.sink.add(0);
    _packsController.sink.add([]);
    _deckController.sink.add([]);
    //log stream isn't included in the merged stream so it doesn't apply, but we have a separate bug where it also needs to be initialized to work properly
    _logsController.sink.add([]);
    _timeController.sink.add(DateTime.now());
    fetchFirestoreDoc();
  }

  Future<void> initBackgroundEvents() async {

    // Configure & start BackgroundFetch.
    BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: true,
        enableHeadless: false
    ), () async {
      // This is the fetch-event callback.
      print('[BackgroundFetch] Event received');
      //addPack(); //for now I'm commenting this out as pack adding logic will be done in the location callbacks below
      // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish();
    }).then((int status) {
      print('[BackgroundFetch] SUCCESS: $status');
    }).catchError((e) {
      print('[BackgroundFetch] ERROR: $e');
    });


    // BackgroundGeolocation event callbacks

    // Fired whenever a location is recorded
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print('[location] - $location');
      var geopoint = GeoFirePoint(location.coords.latitude, location.coords.longitude);
      _geoController.sink.add(geopoint);
      checkAddPack(geopoint);
    });

    // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      print('[motionchange] - $location');
      var geopoint = GeoFirePoint(location.coords.latitude, location.coords.longitude);
      _geoController.sink.add(geopoint);
      checkAddPack(geopoint);
    });

    // Fired whenever the state of location-services changes.  Always fired at boot
    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      print('[providerchange] - $event');
    });

    // Configure & start BackgroundGeolocation
    bg.BackgroundGeolocation.ready(bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 10.0,
        stopOnTerminate: false,
        startOnBoot: true,
        debug: true,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
        notificationChannelName: "Cardscape ChannelName",
        notificationTitle: "Cardscape",
        notificationText: "On the hunt for packs...",
        notificationColor: "blue",
        reset: true
    )).then((bg.State state) {
      if (!state.enabled) {
        bg.BackgroundGeolocation.start();
      }
    });
  }

  fetchFirestoreDoc() async {
    var doc = await firestore.collection('users').document('0').get();

    var user = UserModel.fromUserDocument(doc.data);

    _packsController.sink.add(currentPacks..addAll(user.packThumbs));
    _deckController.sink.add(currentDeck..addAll(user.cardThumbs));
    _logsController.sink.add(currentLogs..addAll(user.logs));
  }

  // called by main_screen navigation bar
  Function(int) get changeView => _navController.sink.add;

  Future<GeoFirePoint> getLocation() async {
    var location = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return location != null ? geo.point(latitude: location.latitude, longitude: location.longitude) : null;
  }

  //checks location & and last check time and adds a new pack if the criteria fits, with some degree of randomness
  checkAddPack(GeoFirePoint geopoint) async {
      if (geopoint != null) {
        var now = DateTime.now();
        var nextCheckTime = lastCheckTime.add(new Duration(minutes: 15));

        print('[LastCheckTime] $lastCheckTime, [NextCheckTime] $nextCheckTime, [Now] $now');

        if (now.isAfter(nextCheckTime)) {
          _timeController.sink.add(nextCheckTime);
          addPackFrom(geopoint, 15.0);
        }
      }
  }

  addPackFrom(GeoFirePoint geopoint, double radius) async {
    //if you've reached this point, geopoint should not be null
    var packsRef = firestore.collection('packs');
    var radius = 50.0;

    var stream = geo.collection(collectionRef: packsRef).within(geopoint, radius, 'point');

    stream.listen((List<DocumentSnapshot> resultList) {
      if (resultList.length > 0) {
        print('[AddPackFrom] Found nearby pack, adding');
        var doc = resultList[0];
        var pack = PackModel.fromPackDocument(doc.data);
        _packsController.sink.add(currentPacks..add(pack));
        log('Added new pack ${pack.title}', geopoint);
      }
      else {
        print('[AddPackFrom] No nearby packs found');
      }
    });

    saveUserData();
  }

  addPack() async {
    
    var geopoint = await getLocation();

    if (geopoint != null) {
      addPackFrom(geopoint, 15.0);
    }
    else {
      print('[AddPack] User location not found');
    }

  }

  openPack(int index) {
    var packs = currentPacks;
    var deck = currentDeck;
    deck.addAll(packs.removeAt(index).cards);
    _packsController.sink.add(packs);
    _deckController.sink.add(deck);

    saveUserData();
  }

  log(String msg, GeoFirePoint geopoint) {
    var currentLogsOrDefault = currentLogs ?? new List<Map<String, dynamic>>(); 
    _logsController.sink.add(currentLogsOrDefault..add(
      {'message': msg,
       'timestamp': DateTime.now(),
       'location': geopoint?.data
      }
    ));
  }

  saveUserData() async {
    firestore.runTransaction((transaction) async {
      final userDocRef = firestore.collection('users').document('0');
      //TODO: we eventually want to uncomment these lines & make sure our user data is up to date with the DB before committing any changes
      //final freshSnapshot = await transaction.get(userDocRef);
      //final freshUserData = UserModel.fromUserDocument(freshSnapshot.data);
      final packsMap = currentPacks.map((p) => p.toMapPartial()).toList();
      final deckMap = currentDeck.map((d) => d.toMapPartial()).toList();
      final logsMap = currentLogs;

      await transaction.update(userDocRef, {
        'packs': packsMap,
        'cards': deckMap,
        'logs': logsMap
      });

    });
  }

  dispose() {
    _navController.close();
    _packsController.close();
    _deckController.close();
    _logsController.close();
    _timeController.close();
    _geoController.close();
  }

}