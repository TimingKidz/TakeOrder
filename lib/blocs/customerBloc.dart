import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:invoice_manage/model/customer.dart';
import 'package:invoice_manage/providers/customer_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerBloc {
  CustomerBloc() {
    getCustomer();
  }

  SharedPreferences? prefs;
  List<Customer> all = [];
  Iterable<Contact> contacts = [];
  List<Customer> focus = [];
  String dropdownValue = "All";
  late Customer fCus;

  final _customerController = StreamController<List<Customer>>.broadcast();
  final _cController = StreamController<Iterable<Contact>>.broadcast();

  get customer => _customerController.stream;
  get c => _cController.stream;

  getCustomer() async {
    if(prefs == null) prefs = await SharedPreferences.getInstance();
    all = await CustomerDbProvider.db.getAllCustomer();
    contacts = await ContactsService.getContacts(withThumbnails: false);
    _cController.sink.add(contacts);
    String f = prefs?.getString("cusCate") ?? "All";
    dropdownValue = f;
    filter();
  }

  Future<void> add(Customer cus) async {
    await CustomerDbProvider.db.newCus(cus);
    await getCustomer();
  }

  Future<void> update(Customer oldCus, Customer upCus) async {
    await CustomerDbProvider.db.updateCus(oldCus, upCus);
    await getCustomer();
  }

  Future<void> delete(Customer cus) async {
    await CustomerDbProvider.db.deleteCus(cus);
    await getCustomer();
  }

  Future<void> searchFilter(String s) async {
    List<Customer> filList = prefs?.getString("cusCate") == "All" ? all : focus;
    if (s.isNotEmpty) {
      List<Customer> filter = filList.where((cus) {
        var company = cus.companyName?.toLowerCase() ?? "";
        var name = cus.cusName?.toLowerCase() ?? "";
        var wNumber = cus.workNum?.toLowerCase() ?? "";
        var mNumber = cus.mobileNum?.toLowerCase() ?? "";
        return company.contains(s) || name.contains(s) || wNumber.contains(s) || mNumber.contains(s);
      }).toList();
      _customerController.sink.add(filter);
    }else{
      _customerController.sink.add(filList);
    }
  }

  Future<void> filter() async {
    if(dropdownValue == "All"){
      focus = all;
      _customerController.sink.add(all);
    }else if(dropdownValue == "Unfiled"){
      List<Customer> filter = all.where((cus) => cus.cusCateName == null).toList();
      focus = filter;
      _customerController.sink.add(filter);
    }else{
      List<Customer> filter = all.where((cus) => cus.cusCateName == dropdownValue).toList();
      focus = filter;
      _customerController.sink.add(filter);
    }
    await prefs?.setString("cusCate", dropdownValue);
  }

  dispose() {
    _customerController.close();
    _cController.close();
  }
}