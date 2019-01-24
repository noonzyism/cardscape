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

  
  CardModel.fromUserJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    imageUrl = parsedJson['imageUrl'];
    title = "Empty";
  }

  @override
  String toString() {
    return '$title';
  }
}