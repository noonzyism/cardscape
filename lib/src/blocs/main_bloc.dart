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

  final _navController = BehaviorSubject<int>();
  final _packsController = BehaviorSubject<List<PackModel>>();
  final _deckController = BehaviorSubject<List<CardModel>>();

  final firestore = Firestore.instance;
  final geo = Geoflutterfire();

  Stream<int> get navStream => _navController.stream;
  Stream<List<PackModel>> get packStream => _packsController.stream;
  Stream<List<CardModel>> get deckStream => _deckController.stream;
  Stream<MainState> get stateStream => Observable.combineLatest3(navStream, packStream, deckStream, (n, p, d) => MainState(n, p, d));

  //current state
  int get currentView => _navController.value;
  List<PackModel> get currentPacks => _packsController.value;
  List<CardModel> get currentDeck => _deckController.value;

  // TODO: for combineLatest2 to emit a first event, all derivative streams must emit an event first - so we need a good way to initialize all data streams with defaults
  MainBloc() {
    _navController.sink.add(0);
    _packsController.sink.add([]);
    _deckController.sink.add([]);
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
      addPack();
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
    });

    // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      print('[motionchange] - $location');
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
        notificationColor: "red",
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

  }

  // called by main_screen navigation bar
  Function(int) get changeView => _navController.sink.add;

  addPack() async {
    
    var location = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    if (location != null) {
      print('[AddPack] User location: ${location.latitude}, ${location.longitude}');
      var geopoint = geo.point(latitude: location.latitude, longitude: location.longitude);
      var packsRef = firestore.collection('packs');
      var radius = 50.0;

      var stream = geo.collection(collectionRef: packsRef).within(geopoint, radius, 'point');

      stream.listen((List<DocumentSnapshot> resultList) {
        if (resultList.length > 0) {
          print('[AddPack] Found nearby pack, adding');
          var doc = resultList[0];
          var pack = PackModel.fromPackDocument(doc.data);
          _packsController.sink.add(currentPacks..add(pack));
        }
        else {
          print('[AddPack] No nearby packs found');
        }
      });

      /*
      var doc = await firestore.collection('packs').document('1').get();
      var pack = PackModel.fromPackDocument(doc.data);
      _packsController.sink.add(currentPacks..add(pack));
      */

      saveUserData();
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

  saveUserData() async {
    firestore.runTransaction((transaction) async {
      final userDocRef = firestore.collection('users').document('0');
      //final freshSnapshot = await transaction.get(userDocRef);
      //final freshUserData = UserModel.fromUserDocument(freshSnapshot.data);
      final packsMap = currentPacks.map((p) => p.toMapPartial()).toList();
      final deckMap = currentDeck.map((d) => d.toMapPartial()).toList();

      await transaction.update(userDocRef, {
        'packs': packsMap,
        'cards': deckMap
      });

    });
  }

  dispose() {
    _navController.close();
    _packsController.close();
    _deckController.close();
  }

}