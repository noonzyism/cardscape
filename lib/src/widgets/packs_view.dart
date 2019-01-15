import 'package:flutter/material.dart';
import '../models/pack_model.dart';

class PacksView extends StatelessWidget {
  final List<PackModel> packs;

  PacksView(this.packs);

  Widget build(context) {
    return ListView.builder(
      itemCount: packs.length,
      itemBuilder: (context, int index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey)
          ),
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Padding(
                child: Image.network(packs[index].imageUrl),
                padding: EdgeInsets.only(bottom: 8.0)
              ),
              Text(packs[index].title)
            ],
          )
        );
      },
    );
  }
}