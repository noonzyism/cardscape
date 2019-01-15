import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'providers/main_provider.dart';

class App extends StatelessWidget {
  build(context) {
    return MainProvider(
      child: MaterialApp(
        title: 'CardScape',
        home: MainScreen()
      )
    );
  }
}