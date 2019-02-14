class CardModel {
  int id;
  String imageUrl;
  String title;

  CardModel(this.id, this.imageUrl, this.title);

  CardModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    imageUrl = parsedJson['thumbnailUrl'];
    title = parsedJson['title'].substring(0, 6).trim();
  }

  // for parsing Cards from a Users or Packs document, where not all data is included (only id, imageUrl, & title)
  CardModel.fromPeripheralDocument(Map<String, dynamic> parsedJson) {
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
  
  @override
  String toString() {
    return '$title';
  }
}