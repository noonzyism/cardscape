import 'package:flutter/material.dart';
import 'screens/launch_screen.dart';
import 'providers/main_provider.dart';

class App extends StatelessWidget {
  build(context) {
    return MainProvider(
      child: MaterialApp(
        title: 'CardScape',
        home: LaunchScreen(),
        theme: ThemeData.dark().copyWith(accentColor: Colors.cyan[300]),
      )
    );
  }
}