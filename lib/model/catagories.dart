import 'package:invoice_manage/providers/db_provider.dart';

class Categories {
  int? cateID;
  late String cateName;

  Categories({this.cateID, required this.cateName});

  factory Categories.fromMap(Map<String, dynamic> json) {
    return Categories(cateID: json[DbProvider.cateID], cateName: json[DbProvider.cateName]);
  }

  Map<String, dynamic> toMap() => {
    DbProvider.cateID: cateID,
    DbProvider.cateName: cateName
  };
}