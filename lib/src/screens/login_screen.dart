import 'package:flutter/material.dart';
import '../blocs/login_bloc.dart';
import '../providers/login_provider.dart';

class LoginScreen extends StatelessWidget {
  Widget build(context) {
    final bloc = LoginProvider.of(context);

    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: [
          emailField(bloc),
          passwordField(bloc),
          Container(margin: EdgeInsets.only(top: 25.0)),
          submitButton(bloc)
        ],
      )
    );
  }

  Widget emailField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Dan is a cool boy @example.com',
            labelText: 'Email Address',
            errorText: snapshot.error
          ),
        );
      }
    );
  }

    Widget passwordField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changePassword,
          decoration: InputDecoration(
            hintText: 'Password',
            labelText: 'Password',
            errorText: snapshot.error
          ),
        );
      }
    );
  }

  Widget submitButton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return RaisedButton(
          child: Text('Login'),
          color: Colors.blue,
          onPressed: snapshot.hasData ? bloc.submit : null
        );
      }
    );


  }
}