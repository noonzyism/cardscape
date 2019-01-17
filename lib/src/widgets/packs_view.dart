import 'package:flutter/material.dart';
import '../models/pack_model.dart';
import '../blocs/main_bloc.dart';

class PacksView extends StatelessWidget {
  final MainBloc bloc;
  final List<PackModel> packs;

  PacksView(this.bloc, this.packs);

  Widget build(context) {
    return ListView.builder(
      itemCount: packs.length,
      itemBuilder: (context, int index) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => buildPackOpenDialog(context, index)
            );
          },
          child: Card(
            margin: EdgeInsets.all(20.0),
            child: Image.network(packs[index].imageUrl)
          )
        );
      },
    );
  }

  Widget buildPackOpenDialog(BuildContext context, int index) {
    return AlertDialog(
      title: Text('Opened Pack ${this.packs[index].title}'),
      content: Text('Unlocked cards: ${this.packs[index].cards}'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            bloc.openPack(index);
            Navigator.of(context).pop();
          },
          child: Text('OK')
        )
      ]
    );
  }
}