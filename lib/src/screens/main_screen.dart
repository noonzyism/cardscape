import 'package:flutter/material.dart';
import '../blocs/main_bloc.dart';
import '../providers/main_provider.dart';
import '../widgets/packs_view.dart';
import '../models/pack_model.dart';

class MainScreen extends StatelessWidget {
  Widget build(context) {
    final bloc = MainProvider.of(context);

    return StreamBuilder(
      stream: bloc.stateStream,
      builder: (BuildContext context, AsyncSnapshot<MainState> snapshot) {
        
        return Scaffold(
          appBar: AppBar(title: Text('CardScape'), backgroundColor: Colors.grey[800]),
          body: snapshot.hasData ? (snapshot.data.viewIndex == 0 ? deckView(snapshot.data.packs.toString()) : packsView(snapshot.data.packs)) : Text("Empty State"),
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
      fixedColor: Colors.black,
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

  Widget deckView(String msg) {
    return Text('Deck - $msg');
  }

    Widget packsView(List<PackModel> packs) {
    return PacksView(packs);
  }
}