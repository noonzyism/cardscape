import 'package:flutter/material.dart';
import '../blocs/main_bloc.dart';
import '../providers/main_provider.dart';
import '../widgets/packs_view.dart';
import '../widgets/deck_view.dart';

class MainScreen extends StatelessWidget {
  Widget build(context) {
    final bloc = MainProvider.of(context);

    bloc.initBackgroundEvents();

    return StreamBuilder(
      stream: bloc.stateStream,
      builder: (BuildContext context, AsyncSnapshot<MainState> snapshot) {
        
        return Scaffold(
          //appBar: AppBar(title: Text('CardScape'), backgroundColor: Colors.black),
          body: snapshot.hasData ? (snapshot.data.viewIndex == 0 ? DeckView(bloc, snapshot.data.deck) : PacksView(bloc, snapshot.data.packs)) : Text("Empty State"),
          bottomNavigationBar: bottomNav(
            bloc, 
            snapshot.hasData ? snapshot.data.viewIndex : 0
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: bloc.addPack,
          ),
        );
      }
    );
  }

  Widget bottomNav(MainBloc bloc, int index) {
    return BottomNavigationBar(
      onTap: bloc.changeView,
      currentIndex: index,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.view_carousel), 
          title: Text('Deck')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.photo_album),
          title: Text('Packs')
        )
      ]
    );
  }
}