import 'card_model.dart';
import 'dart:math';
import 'package:geoflutterfire/geoflutterfire.dart';

class PackModel {
  int id;
  String imageUrl;
  String title;
  List<String> collections;
  int radius;
  GeoFirePoint location;

  PackModel(this.id, this.imageUrl, this.title, this.collections, this.radius, this.location);

  // from Firestore Packs collection document
  PackModel.fromPackDocument(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    imageUrl = parsedJson['imageUrl'];
    title = parsedJson['title'];
    collections = parsedJson['collections'] as List<String>;
    radius = parsedJson['radius'];
    location = parsedJson['location'] as GeoFirePoint;
  }

  // for parsing Packs from a Users document, where not all data is included (only id, imageUrl, & title)
  PackModel.fromPeripheralDocument(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    imageUrl = parsedJson['imageUrl'];
    title = parsedJson['title'];
  }

  Map<String, dynamic> toMapPartial() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title
    };
  }
}