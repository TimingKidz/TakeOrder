import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final bloc;

  const SearchBar({Key? key, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: "Search...",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))
      ),
      onChanged: (text) {
        text = text.toLowerCase();
        bloc.searchFilter(text);
      },
    );
  }
}

