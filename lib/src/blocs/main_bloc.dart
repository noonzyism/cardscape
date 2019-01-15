import 'dart:async';
import '../mixins/validators.dart';
import '../models/pack_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' show get;
import 'dart:convert';

class MainState {
  int viewIndex;
  List<PackModel> packs;

  MainState(this.viewIndex, this.packs);
}

class MainBloc extends Validators {

  final _navController = BehaviorSubject<int>();
  final _packsController = BehaviorSubject<List<PackModel>>();

  Stream<int> get navStream => _navController.stream;
  Stream<List<PackModel>> get packStream => _packsController.stream;
  Stream<MainState> get stateStream => Observable.combineLatest2(navStream, packStream, (n, p) => MainState(n, p));

  // default initial state
  // TODO: for combineLatest2 to emit a first event, all derivative streams must emit an event first - so we need a good way to initialize all data streams with defaults
  MainState state = MainState(0, []);

  // called by main_screen navigation bar
  Function(int) get changeView => _navController.sink.add;

  addPack() async {
    var response = await get('https://jsonplaceholder.typicode.com/photos/${state.packs.length+1}');
    state.packs.add(PackModel.fromJson(json.decode(response.body)));
    _packsController.sink.add(state.packs);
  }

  dispose() {
    _navController.close();
    _packsController.close();
  }

}