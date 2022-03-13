import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../base/Injector.dart';
import 'SummaryProvider.dart';

class SummaryPageSearchBar extends StatelessWidget {
  final SummaryProvider provider;
  final TextEditingController searchText;
  final FocusNode textFieldFocusNode;

  const SummaryPageSearchBar({Key? key, required this.provider, required this.searchText, required this.textFieldFocusNode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchText,
      focusNode: textFieldFocusNode,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          prefixIcon: Icon(Icons.search),
          hintText: "Search...",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              searchText.clear();
              provider.searchFilter(searchText.text);
              textFieldFocusNode.requestFocus();
            },
            splashRadius: 18.0,
          )),
      onChanged: (text) {
        text = text.toLowerCase();
        provider.searchFilter(searchText.text);
      },
    );
  }
}
