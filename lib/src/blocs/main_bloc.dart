import 'dart:async';
import 'dart:convert';

import '../mixins/validators.dart';
import '../models/pack_model.dart';
import '../models/card_model.dart';

import 'package:rxdart/rxdart.dart';

import 'package:http/http.dart' show get;

class MainState {
  int viewIndex;
  List<PackModel> packs;
  List<CardModel> deck;

  MainState(this.viewIndex, this.packs, this.deck);
}

class MainBloc extends Validators {

  // default initial state
  // TODO: if possible we should try to keep only one location for the state (i.e. just the stateStream) instead of holding this separate reference and pushing it to the stream every time
  // or alternatively just have this reference listen to the stateStream and update itself automatically
  MainState state = MainState(0, [], []);

  final _navController = BehaviorSubject<int>();
  final _packsController = BehaviorSubject<List<PackModel>>();
  final _deckController = BehaviorSubject<List<CardModel>>();

  Stream<int> get navStream => _navController.stream;
  Stream<List<PackModel>> get packStream => _packsController.stream;
  Stream<List<CardModel>> get deckStream => _deckController.stream;
  Stream<MainState> get stateStream => Observable.combineLatest3(navStream, packStream, deckStream, (n, p, d) => MainState(n, p, d));

  // TODO: for combineLatest2 to emit a first event, all derivative streams must emit an event first - so we need a good way to initialize all data streams with defaults
  MainBloc() {
    _navController.sink.add(0);
    _packsController.sink.add([]);
    _deckController.sink.add([]);
  }

  // called by main_screen navigation bar
  Function(int) get changeView => _navController.sink.add;

  addPack() async {
    var response = await get('https://jsonplaceholder.typicode.com/photos/${state.packs.length+1}');
    state.packs.add(PackModel.fromJson(json.decode(response.body)));
    _packsController.sink.add(state.packs);
  }

  openPack(int index) {
    state.deck.addAll(state.packs.removeAt(index).cards);
    _packsController.sink.add(state.packs);
    _deckController.sink.add(state.deck);
  }

  dispose() {
    _navController.close();
    _packsController.close();
    _deckController.close();
  }

}