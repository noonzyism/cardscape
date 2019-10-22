import 'package:flutter/material.dart';
import '../models/user_card_model.dart';
import '../blocs/main_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DeckView extends StatelessWidget {
  final MainBloc bloc;
  final List<UserCardModel> cards;

  DeckView(this.bloc, this.cards);

  Widget build(context) {
    return originalPackGrid();
  }

  Widget staggeredPackGrid() {
    return StaggeredGridView.count(
      crossAxisCount: 3,
      children: cards.map<Widget>((UserCardModel card) {
        return Container(
          margin: EdgeInsets.all(1.0),
          child: GestureDetector(
            onTap: () {},
            child: GridTile(
              child: Image.network(card.imageUrl),
              footer: Text(card.title),
            )
          )
        );
      }).toList()
    );
  }

  Widget originalPackGrid() {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: (720 / 1280),
      children: cards.map<Widget>((UserCardModel card) {
        return Container(
          margin: EdgeInsets.all(1.0),
          child: GestureDetector(
            onTap: () {},
            child: GridTile(
              child: Image.network(card.imageUrl),
              footer: Text(card.title),
            )
          )
        );
      }).toList()
    );
  }
}