import 'package:cloud_firestore/cloud_firestore.dart';
/*
class Location {

  //this is the model of how locations are stored in the DB, mimics the structure of https://pub.dartlang.org/packages/geoflutterfire
  int id;
  String imageUrl;
  String title;
  String description;
  int rarity;
  List<String> collections;

  String geohash;
  GeoPoint geopoint;
  


  Location(this.id, this.imageUrl, this.title, this.rarity);

  CardModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    imageUrl = parsedJson['thumbnailUrl'];
    title = parsedJson['title'].substring(0, 6).trim();
    description = parsedJson['description'];
    rarity = parsedJson['rarity'];
  }

  // for parsing Cards from a Users or Packs document, where not all data is included
  CardModel.fromPeripheralDocument(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    imageUrl = parsedJson['imageUrl'];
    title = parsedJson['title'];
    rarity = parsedJson['rarity'];
  }

  Map<String, dynamic> toMapPartial() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'rarity': rarity
    };
  }
  
  @override
  String toString() {
    return '$title';
  }
}
*/