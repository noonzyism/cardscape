class UserCardModel {
  int id;
  String imageUrl;
  String title;
  String description;
  //int class; //common, legendary, etc, tbd
  //GeoFirePoint acquirePoint;

  UserCardModel(this.id, this.imageUrl, this.title);

  UserCardModel.fromJson(Map<String, dynamic> parsedJson) {
    id          = parsedJson['id'];
    imageUrl    = parsedJson['imageUrl'];
    title       = parsedJson['title'].substring(0, 6).trim();
    description = parsedJson['description'];
  }

  //creates a UserCard from a Card db document
  UserCardModel.generateFromCardDoc(Map<String, dynamic> parsedJson) {
    //currently, this model is just a subset of the info available from a Card document, but it will eventually have user-specific fields such as class & acquireTime/Point
    print("parsedJson: $parsedJson");
    id          = parsedJson['id'];
    imageUrl    = parsedJson['imageUrl'];
    title       = parsedJson['title'].substring(0, 6).trim();
    description = parsedJson['description'];
  }

  Map<String, dynamic> toMapPartial() {
    return {
      'id':           this.id,
      'imageUrl':     this.imageUrl,
      'description':  this.description
    };
  }
  
  @override
  String toString() {
    return '$title';
  }
}
