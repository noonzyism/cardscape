import 'package:flutter/material.dart';
import '../blocs/main_bloc.dart';

class MainProvider extends InheritedWidget {

  final bloc = MainBloc();

  MainProvider({Key key, Widget child}) : super(key: key, child: child);

  static MainBloc of(BuildContext context) {
    // used by children widgets to find the scoped bloc from its parent widget of type Provider
    return (context.inheritFromWidgetOfExactType(MainProvider) as MainProvider).bloc;
  }

  @override
    bool updateShouldNotify(InheritedWidget oldWidget) {
      return true;
    }
}