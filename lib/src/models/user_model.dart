import 'card_model.dart';
import 'pack_model.dart';

class UserModel {
  int id;
  String username;
  //TODO: Note: these lists do not contain fully populated Card/Pack models, in the user schema we only have a subset of their data (id & imageUrl)
  //which is enough to display the cards/packs for the user - for the full info (i.e. clicking on a card) we'd have to query for it using its ID
  //we might want to use a separate class to indicate these instances to prevent trying to access the missing fields/be more clear about their contents
  List<CardModel> cardThumbs;
  List<PackModel> packThumbs;

  UserModel(this.id, this.username, this.cardThumbs, this.packThumbs);

  UserModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    username = parsedJson['username'];
    var cardData = parsedJson['cards'] as List;
    cardThumbs = cardData.map((c) => CardModel.fromUserJson(new Map<String, dynamic>.from(c))).toList();
    var packData = parsedJson['packs'] as List;
    packThumbs = packData.map((p) => PackModel.fromUserJson(new Map<String, dynamic>.from(p))).toList();
  }

  @override
  String toString() {
    return '$username';
  }
}