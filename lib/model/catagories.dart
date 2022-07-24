import '../core/constants/database_constants.dart';

class Categories {
  int? cateID;
  late String cateName;

  Categories({this.cateID, required this.cateName});

  factory Categories.fromMap(Map<String, dynamic> json) {
    return Categories(
        cateID: json[DatabaseConstants.cateID],
        cateName: json[DatabaseConstants.cateName]);
  }

  Map<String, dynamic> toMap() =>
      {DatabaseConstants.cateID: cateID, DatabaseConstants.cateName: cateName};
}
