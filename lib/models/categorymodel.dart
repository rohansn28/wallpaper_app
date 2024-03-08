import 'dart:convert';

List<CategoryWall> categoryWallFromJson(String str) => List<CategoryWall>.from(
    json.decode(str).map((x) => CategoryWall.fromJson(x)));

String categoryWallToJson(List<CategoryWall> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryWall {
  int id;
  String category;
  dynamic createdAt;
  dynamic updatedAt;

  CategoryWall({
    required this.id,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryWall.fromJson(Map<String, dynamic> json) => CategoryWall(
        id: json["id"],
        category: json["category"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
