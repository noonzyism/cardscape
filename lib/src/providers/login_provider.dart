import 'package:flutter/material.dart';
import '../blocs/login_bloc.dart';

class LoginProvider extends InheritedWidget {

  final bloc = LoginBloc();

  LoginProvider({Key key, Widget child}) : super(key: key, child: child);

  static LoginBloc of(BuildContext context) {
    // used by children widgets to find the scoped bloc from its parent widget of type Provider
    return (context.inheritFromWidgetOfExactType(LoginProvider) as LoginProvider).bloc;
  }

  @override
    bool updateShouldNotify(InheritedWidget oldWidget) {
      // TODO: implement updateShouldNotify
      return null;
    }
}