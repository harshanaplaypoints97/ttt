class GetBanners {
  bool done;
  Body body;
  String message;

  GetBanners({this.done, this.body, this.message});

  GetBanners.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['done'] = done;
    if (body != null) {
      data['body'] = body.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Body {
  String id;
  List<Media> media;

  Body({this.id, this.media});

  Body.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media.add( Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (media != null) {
      data['media'] = media.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Media {
  String id;
  String bannerId;
  String mediaType;
  String mediaUrl;
  String redirectUrl;
  String dateCreated;

  Media(
      {this.id,
      this.bannerId,
      this.mediaType,
      this.mediaUrl,
      this.redirectUrl,
      this.dateCreated});

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bannerId = json['banner_id'];
    mediaType = json['media_type'];
    mediaUrl = json['media_url'];
    redirectUrl = json['redirect_url'];
    dateCreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['banner_id'] = bannerId;
    data['media_type'] = mediaType;
    data['media_url'] = mediaUrl;
    data['redirect_url'] = redirectUrl;
    data['date_created'] = dateCreated;
    return data;
  }
}