import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'providers/login_provider.dart';

class App extends StatelessWidget {
  build(context) {
    return LoginProvider(
      child: MaterialApp(
        title: 'CardScape',
        home: Scaffold(
          appBar: AppBar(title: Text('CardScape')),
          body: LoginScreen(),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.view_carousel), title: Text('Deck')),
              BottomNavigationBarItem(icon: Icon(Icons.photo_album), title: Text('Packs'))
            ]
          ),
        )
      )
    );
  }
}