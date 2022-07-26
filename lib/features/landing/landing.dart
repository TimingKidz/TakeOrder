import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_manage/features/landing/landing_provider.dart';

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPage,
          selectedItemColor: selectColor(currentPage),
          onTap: (cur) => ref.read(currentPageProvider.notifier).state = cur,
          selectedFontSize: 12.0,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.note), label: "Memo"),
            BottomNavigationBarItem(
                icon: Icon(Icons.insert_chart), label: "Summary"),
            BottomNavigationBarItem(
                icon: Icon(Icons.sticky_note_2), label: "Order"),
          ],
        ),
        body: ref.read(pageRoute)[currentPage],
      ),
    );
  }

  Color selectColor(int currentPage) {
    if (currentPage == 0) return Colors.orange;
    if (currentPage == 1)
      return Colors.green;
    else
      return Colors.blue;
  }
}
