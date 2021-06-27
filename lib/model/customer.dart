import 'package:invoice_manage/providers/db_provider.dart';

class Customer {
  int? cusID;
  String? companyName;
  String? cusName;
  String? workNum;
  String? mobileNum;
  String? address;
  int? cusCateID;
  String? cusCateName;

  Customer({
    this.cusID,
    this.companyName,
    this.cusName,
    this.workNum,
    this.mobileNum,
    this.address,
    this.cusCateID,
    this.cusCateName
  });

  factory Customer.fromMap(Map<String, dynamic> json) {
    return Customer(
      cusID: json[DbProvider.cusID],
      companyName: json[DbProvider.companyName],
      cusName: json[DbProvider.cusName],
      workNum: json[DbProvider.workNum],
      mobileNum: json[DbProvider.mobileNum],
      address: json[DbProvider.address],
      cusCateID: json[DbProvider.cusCateID],
      cusCateName: json[DbProvider.cateName]
    );
  }

  Map<String, dynamic> toMap() => {
    DbProvider.cusID: cusID,
    DbProvider.companyName: companyName,
    DbProvider.cusName: cusName,
    DbProvider.workNum: workNum,
    DbProvider.mobileNum: mobileNum,
    DbProvider.address: address,
    DbProvider.cusCateID: cusCateID
  };
}