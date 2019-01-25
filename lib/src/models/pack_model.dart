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
    title = parsedJson['title'];

    cards = new List<CardModel>();
    var rand = Random().nextInt(7) + 2;
    for (var i = 0; i < rand; i++) {
      cards.add(new CardModel(i, parsedJson['thumbnailUrl'], title.substring(0, 6).trim()+'$i'));
    }

  }

  // from Firestore Packs collection document
  PackModel.fromPackDocument(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    imageUrl = parsedJson['imageUrl'];
    title = parsedJson['title'];
    var cardPool = (parsedJson['cardPool'] as List).map((c) => CardModel.fromPeripheralDocument(new Map<String, dynamic>.from(c))).toList();
    //for now being lazy and including all cards from the cardPool into the pack, in the future it'll be a random subset of these
    cards = cardPool;
  }

  // for parsing Cards from a Users or Packs document, where not all data is included (only id & imageUrl)
  PackModel.fromPeripheralDocument(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    imageUrl = parsedJson['imageUrl'];
    title = "Empty";
    cards = new List<CardModel>();
    var rand = Random().nextInt(7) + 2;
    for (var i = 0; i < rand; i++) {
      cards.add(new CardModel(i, imageUrl, 'Card $i'));
    }
  }

  @override
  String toString() {
    return cards.toString();
  }
}