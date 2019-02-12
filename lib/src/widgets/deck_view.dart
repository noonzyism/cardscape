import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../blocs/main_bloc.dart';

class DeckView extends StatelessWidget {
  final MainBloc bloc;
  final List<CardModel> cards;

  DeckView(this.bloc, this.cards);

  Widget build(context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: (480 / 600),
      children: cards.map<Widget>((CardModel card) {
        return Container(
          margin: EdgeInsets.all(0.0),
          child: GestureDetector(
            onTap: () {},
            child: GridTile(
              child: Image.network(card.imageUrl),
              //footer: Text(card.title),
            )
          )
        );
      }).toList()
    );
  }
}