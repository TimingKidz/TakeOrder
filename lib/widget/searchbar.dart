import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final bloc;

  const SearchBar({Key? key, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchText = TextEditingController();
    var textFieldFocusNode = FocusNode();

    bloc.isShowKeyboard.listen((value) {
      if (value)
        textFieldFocusNode.requestFocus();
      else
        textFieldFocusNode.unfocus();
    });

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
              bloc.searchFilter("");
              textFieldFocusNode.requestFocus();
            },
            splashRadius: 18.0,
          )),
      onChanged: (text) {
        text = text.toLowerCase();
        bloc.searchFilter(text);
      },
    );
  }
}

