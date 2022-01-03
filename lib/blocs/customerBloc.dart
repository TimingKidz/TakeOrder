import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerBloc {
  CustomerBloc() {
    getCustomer();
  }

  SharedPreferences? prefs;
  Iterable<Contact> contacts = [];
  String dropdownValue = "All";

  final _customerController = StreamController<Iterable<Contact>>.broadcast();

  get customer => _customerController.stream;

  getCustomer() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    contacts = await ContactsService.getContacts(withThumbnails: false);
    _customerController.sink.add(contacts);
    String f = prefs?.getString("cusCate") ?? "All";
    dropdownValue = f;
  }

  Future<void> searchFilter(String s) async {
    if (s.isNotEmpty) {
      List<Contact> filter = contacts.where((cus) {
        var displayName = cus.displayName?.toLowerCase() ?? "";
        return displayName.contains(s);
      }).toList();
      _customerController.sink.add(filter);
    } else{
      _customerController.sink.add(contacts);
    }
  }

  dispose() {
    _customerController.close();
  }
}