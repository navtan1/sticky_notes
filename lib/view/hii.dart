class Navtan {
  String? bhanderi;
  String? jitendra;

  Navtan({this.bhanderi, this.jitendra});

  Navtan.fromjson(Map<String, dynamic> json) {
    bhanderi = json["bhanderi"];
    jitendra = json["jitendra"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["bhanderi"] = bhanderi;
    data["jitendra"] = jitendra;
    return data;
  }
}
