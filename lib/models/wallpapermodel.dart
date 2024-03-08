import 'dart:convert';

List<Wallpaper> wallpaperFromJson(String str) =>
    List<Wallpaper>.from(json.decode(str).map((x) => Wallpaper.fromJson(x)));

String wallpaperToJson(List<Wallpaper> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Wallpaper {
  int id;
  String wallUrl;
  dynamic createdAt;
  dynamic updatedAt;

  Wallpaper({
    required this.id,
    required this.wallUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Wallpaper.fromJson(Map<String, dynamic> json) => Wallpaper(
        id: json["id"],
        wallUrl: json["wallUrl"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "wallUrl": wallUrl,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
