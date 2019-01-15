class PackModel {
  int id;
  String imageUrl;
  String title;

  PackModel(this.id, this.imageUrl, this.title);

  PackModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    imageUrl = parsedJson['url'];
    title = parsedJson['title'];
  }

  @override
  String toString() {
    return 'Pack $imageUrl';
  }
}