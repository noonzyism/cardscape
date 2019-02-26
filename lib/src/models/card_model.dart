class CardModel {
  int id;
  String imageUrl;
  String title;
  String description;
  int rarity;

  CardModel(this.id, this.imageUrl, this.title, this.rarity);

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