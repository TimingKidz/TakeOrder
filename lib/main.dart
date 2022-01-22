import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoice_manage/pages/SummaryPage.dart';
import 'package:invoice_manage/pages/memoPage.dart';
import 'package:invoice_manage/pages/orderPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
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
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).canvasColor,
          foregroundColor: Colors.black,
            elevation: 0.0),
        textTheme: TextTheme(
          headline6: TextStyle(fontSize: 20)
        )
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPage = 2;

  final List<Widget> pageRoute = [MemoPage(), SummaryPage(), OrderPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        selectedItemColor: selectColor(),
        onTap: (cur) {
          setState(() {
            _currentPage = cur;
          });
        },
        selectedFontSize: 12.0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.note), label: "Memo"),
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart), label: "Summary"),
          BottomNavigationBarItem(
              icon: Icon(Icons.sticky_note_2), label: "Order"),
        ],
      ),
      body: pageRoute[_currentPage],
    );
  }

  Color selectColor(){
    if (_currentPage == 0) return Colors.orange;
    if (_currentPage == 1)
      return Colors.green;
    else
      return Colors.blue;
  }
}
