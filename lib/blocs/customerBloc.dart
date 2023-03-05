import 'dart:async';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerBloc {
  CustomerBloc() {
    getCustomer();
  }

  SharedPreferences? prefs;
  Iterable<Contact> contacts = [];
  String dropdownValue = "All";

  final _customerController = StreamController<Iterable<Contact>>.broadcast();
  final _isShowKeyboardController = StreamController<bool>.broadcast();

  get customer => _customerController.stream;

  get isShowKeyboard => _isShowKeyboardController.stream;

  getCustomer() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    contacts = await FlutterContacts.getContacts();
    _customerController.sink.add(contacts);
    String f = prefs?.getString("cusCate") ?? "All";
    dropdownValue = f;
  }

  Future<void> searchFilter(String s) async {
    if (s.isNotEmpty) {
      List<Contact> filter = contacts.where((cus) {
        var displayName = cus.displayName.toLowerCase();
        return displayName.contains(s);
      }).toList();
      filter.sort((a, b) =>
          a.displayName.indexOf(s).compareTo(b.displayName.indexOf(s)));
      _customerController.sink.add(filter);
    } else {
      _customerController.sink.add(contacts);
    }
  }

  void isShowKeyboardToggle(bool isShow) {
    _isShowKeyboardController.sink.add(isShow);
  }

  dispose() {
    _customerController.close();
    _isShowKeyboardController.close();
  }
}