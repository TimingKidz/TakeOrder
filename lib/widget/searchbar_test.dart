import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_manage/core/constants/spacing_constants.dart';
import 'package:invoice_manage/features/summary/presenter/summary_provider.dart';

import '../core/localize/localize_en.dart';

class SearchBar extends ConsumerStatefulWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<SearchBar> {
  final searchKeywordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final summaryState = ref.watch(summaryDisplayProvider.notifier);

    return Container(
      padding: EdgeInsets.fromLTRB(
          spacingSmallX, spacingSmallX, spacingSmallX, spacingZero),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
      ),
      child: TextField(
          controller: searchKeywordController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              prefixIcon: Icon(Icons.search),
              hintText: searchBarHint,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () async {
                  searchKeywordController.clear();
                  summaryState.state = ref.read(allSummaryProvider);
                },
                splashRadius: 18.0,
              )),
          onChanged: (text) {
            summaryState.state =
                ref.read(searchFilterProvider(text.toLowerCase()));
          }),
    );
  }
}
