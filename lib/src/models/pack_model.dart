import 'card_model.dart';
import 'dart:math';

class PackModel {
  int id;
  String imageUrl;
  String title;
  List<CardModel> cards;

  PackModel(this.id, this.imageUrl, this.title, this.cards);

  PackModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    imageUrl = parsedJson['url'];
    title = parsedJson['title'].substring(0, 15).trim();

    cards = new List<CardModel>();
    var rand = Random().nextInt(7) + 2;
    for (var i = 0; i < rand; i++) {
      cards.add(new CardModel(i, parsedJson['thumbnailUrl'], title.substring(0, 6).trim()+'$i'));
    }

  }

  @override
  String toString() {
    return cards.toString();
  }
}