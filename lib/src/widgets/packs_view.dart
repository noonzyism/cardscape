import 'package:flutter/material.dart';
import '../models/pack_model.dart';
import '../blocs/main_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class PacksView extends StatelessWidget {
  final MainBloc bloc;
  final List<PackModel> packs;

  PacksView(this.bloc, this.packs);

  Widget build(context) {
    return (packs.length <= 0) ? Text("No packs, loser!") :
      Swiper(
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
              margin: EdgeInsets.all(0.0),
              child: Image.network(packs[index].imageUrl, fit:BoxFit.fill)
            ),
          );
        },
        layout: SwiperLayout.STACK,
        itemWidth: 400.0,
        itemHeight: 600.0,
        pagination: SwiperPagination(),
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