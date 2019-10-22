import 'user_card_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class UserPackModel {
  int id;
  String imageUrl;
  String title;
  List<UserCardModel> cards;

  UserPackModel(this.id, this.imageUrl, this.title, this.cards);

  UserPackModel.fromJson(Map<String, dynamic> parsedJson) {
    this.id       = parsedJson['id'];
    this.imageUrl = parsedJson['imageUrl'];
    this.title    = parsedJson['title'];
    var cardData  = parsedJson['cards'] as List;
    this.cards    = cardData?.map((c) => UserCardModel.fromJson(new Map<String, dynamic>.from(c)))?.toList();
  }

  // generates a UserPack, filled with cards from within the Pack's radius
  UserPackModel.generateFromPackDoc(Map<String, dynamic> parsedJson, Firestore firestore, Geoflutterfire geo) {
    var cardsRef = firestore.collection('cards');
    var parsedCards = new List<UserCardModel>();

    var location = toGeoFirePoint(new Map<String, dynamic>.from(parsedJson['location']));
    int radius = parsedJson['radius'];

    //create query stream
    var stream = geo.collection(collectionRef: cardsRef).within(location, 1000.0, 'location');

    // listen for results
    stream.listen((List<DocumentSnapshot> resultList) {
      if (resultList.length > 0) {
        print('[generateFromPackDoc] Found nearby cards');
        parsedCards = resultList.map((r) { 
          var c = new UserCardModel.generateFromCardDoc(r.data);
          print('[generateFromPackDoc] mapping to UserCard: ${c.title}, ${c.description}, ${c.imageUrl}, ${c.id}');
          return c;
          }).toList();
      }
      else {
        print('[generateFromPackDoc] No nearby cards for pack found');
      }
    });

    print("[generateFromPackDoc] finalCard list: $parsedCards");

    this.id       = parsedJson['id'];
    this.imageUrl = parsedJson['imageUrl'];
    this.title    = parsedJson['title'];
    this.cards    = parsedCards;
  }

  static GeoFirePoint toGeoFirePoint(Map<String, dynamic> locationBlob) {
    var geopoint = locationBlob['geopoint'] as GeoPoint;
    return GeoFirePoint(geopoint.latitude, geopoint.longitude);
  }

  Map<String, dynamic> toMapPartial() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title
    };
  }
}