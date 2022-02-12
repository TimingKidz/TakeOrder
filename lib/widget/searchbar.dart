import 'package:flutter/material.dart';
import 'package:invoice_manage/blocs/catalogBloc.dart';

class SearchBar extends StatelessWidget {
  final bloc;
  final TextEditingController? blocSearchText;

  const SearchBar({Key? key, required this.bloc, this.blocSearchText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchText = blocSearchText != null
        ? blocSearchText ?? TextEditingController()
        : TextEditingController();
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
              if (bloc is CatalogBloc) {
                bloc.searchFilter(searchText.text, searchText);
              } else {
                bloc.searchFilter(searchText.text);
              }
              textFieldFocusNode.requestFocus();
            },
            splashRadius: 18.0,
          )),
      onChanged: (text) {
        text = text.toLowerCase();
        if (bloc is CatalogBloc) {
          bloc.searchFilter(searchText.text, searchText);
        } else {
          bloc.searchFilter(searchText.text);
        }
      },
    );
  }
}

