import 'package:flutter/material.dart';
import '../blocs/main_bloc.dart';
import '../providers/main_provider.dart';
import '../widgets/packs_view.dart';
import '../widgets/deck_view.dart';
import 'package:splashscreen/splashscreen.dart';
import 'main_screen.dart';

class LaunchScreen extends StatelessWidget {
  Widget build(context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: MainScreen(),
      /*
      title: new Text('Welcome In SplashScreen',
      style: new TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0
      ),),
      */
      image: new Image.network('https://i.imgur.com/DtOkHot.png'),
      backgroundColor: Colors.black,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      onClick: ()=>print("Flutter Egypt"),
      loaderColor: Colors.black,
    );
  }
}