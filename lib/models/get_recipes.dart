class GetRecipes {
  GetRecipes({
    this.done,
    this.body,
    this.message,
  });
  bool done;
  BodyOfRecipes body;
  String message;

  GetRecipes.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = BodyOfRecipes.fromJson(json['body']);
    message = null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['done'] = done;
    data['body'] = body.toJson();
    data['message'] = message;
    return data;
  }
}

class BodyOfRecipes {
  BodyOfRecipes({
    this.count,
    this.recipes,
  });
  int count;
  List<Recipes> recipes;

  BodyOfRecipes.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    recipes =
        List.from(json['recipes']).map((e) => Recipes.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['count'] = count;
    data['recipes'] = recipes.map((e) => e.toJson()).toList();
    return data;
  }
}

class Recipes {
  Recipes(
      {this.id,
      this.name,
      this.descriptions,
      this.mediaUrl,
      this.dateCreated,
      this.dateUpdated,
      this.thumbImage});
  String id;
  String name;
  String readName;
  String descriptions;
  String mediaUrl;
  String dateCreated;
  String dateUpdated;
  String thumbImage;

  Recipes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    readName = json['read_name'];
    name = json['name'];
    descriptions = json['descriptions'];
    mediaUrl = json['media_url'];
    dateCreated = json['date_created'];
    dateUpdated = json['date_updated'];
    thumbImage = json['thumb_image'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['read_name'] = readName;
    data['descriptions'] = descriptions;
    data['media_url'] = mediaUrl;
    data['date_created'] = dateCreated;
    data['date_updated'] = dateUpdated;
    data['thumb_image'] = thumbImage;
    return data;
  }
}
