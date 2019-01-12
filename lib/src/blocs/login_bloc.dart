import 'dart:async';
import '../mixins/validators.dart';

import 'package:rxdart/rxdart.dart';

class LoginBloc extends Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Add data to stream
  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password => _passwordController.stream.transform(validatePassword);
  Stream<bool> get submitValid => Observable.combineLatest2(email, password, (e, p) => true);

  // Change data
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  submit() {
    final validEmail = _emailController.value;
    final validPassword = _passwordController.value;

    print('Email = $validEmail');
    print('Password = $validPassword');
  }

  dispose() {
    _emailController.close();
    _passwordController.close();
  }

}