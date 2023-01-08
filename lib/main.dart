import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoice_manage/blocs/SummaryBloc.dart';
import 'package:invoice_manage/pages/SummaryPage.dart';
import 'package:invoice_manage/pages/memoPage.dart';
import 'package:invoice_manage/pages/orderPage.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'blocs/memoBloc.dart';
import 'blocs/orderBloc.dart';

final memoBloc = MemoBloc();
var summaryBloc = SummaryBloc();
final orderBloc = OrderBloc();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    // statusBarColor is used to set Status bar color in Android devices.
    statusBarColor: Colors.transparent,

    // To make Status bar icons color white in Android devices.
    // statusBarIconBrightness: Brightness.light,
    //
    // // statusBarBrightness is used to set Status bar icon color in iOS.
    // statusBarBrightness: Brightness.light,
    // Here light means dark color Status bar icons.

    // systemNavigationBarColor: Color(0xfffafafa),
    // systemNavigationBarIconBrightness: Brightness.dark
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Take Order',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
              backgroundColor: Theme.of(context).canvasColor,
              foregroundColor: Colors.black,
              elevation: 0.0),
          textTheme: TextTheme(headline6: TextStyle(fontSize: 20))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 2);

  final List<Widget> pageRoute = [MemoPage(), SummaryPage(), OrderPage()];

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: pageRoute,
      backgroundColor: Color(0xFFFAFAFA),
      items: [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.note),
          title: "Memo",
          activeColorPrimary: Colors.orange,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.insert_chart),
          title: "Summary",
          activeColorPrimary: Colors.green,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.sticky_note_2),
          title: "Order",
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        )
      ],
      navBarStyle: NavBarStyle.style3,
      popAllScreensOnTapOfSelectedTab: false,
      onWillPop: (context) async {
        return false;
      },
    );
  }
}
