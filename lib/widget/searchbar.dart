import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final bloc;

  const SearchBar({Key? key, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchText = TextEditingController();

    return TextField(
      controller: searchText,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: "Search...",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              searchText.clear();
              bloc.searchFilter("");
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

