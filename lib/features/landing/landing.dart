import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_manage/core/constants/spacing_constants.dart';
import 'package:invoice_manage/features/landing/landing_provider.dart';

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          elevation: spacingZero,
          onDestinationSelected: (cur) =>
              ref.read(currentPageProvider.notifier).state = cur,
          selectedIndex: currentPage,
          destinations: [
            NavigationDestination(icon: Icon(Icons.note), label: "Memo"),
            NavigationDestination(
                icon: Icon(Icons.insert_chart), label: "Summary"),
            NavigationDestination(
                icon: Icon(Icons.sticky_note_2), label: "Order"),
            NavigationDestination(icon: Icon(Icons.ac_unit), label: "NewUI"),
          ],
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   type: BottomNavigationBarType.fixed,
        //   currentIndex: currentPage,
        //   selectedItemColor: selectColor(currentPage),
        //   onTap: (cur) => ref.read(currentPageProvider.notifier).state = cur,
        //   selectedFontSize: 12.0,
        //   items: [
        //     BottomNavigationBarItem(icon: Icon(Icons.note), label: "Memo"),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.insert_chart), label: "Summary"),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.sticky_note_2), label: "Order"),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.ac_unit), label: "NewUI"),
        //   ],
        // ),
        body: ref.read(pageRoute)[currentPage],
      ),
    );
  }

  Color selectColor(int currentPage) {
    if (currentPage == 0) return Colors.orange;
    if (currentPage == 1) return Colors.green;
    if (currentPage == 2)
      return Colors.blue;
    else
      return Colors.indigo;
  }
}
