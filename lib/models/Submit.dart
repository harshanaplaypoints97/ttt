class Submit {
  Submit({
    this.done,
    this.body,
    this.message,
  });
  bool done;
  Body body;
  String message;

  Submit.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = Body.fromJson(json['body']);
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['done'] = done;
    _data['body'] = body;
    _data['message'] = message;
    return _data;
  }
}

class Body {
  Body();

  Body.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};

    return _data;
  }
}
