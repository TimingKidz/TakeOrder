import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/logger/logger.dart';
import 'features/landing/landing.dart';

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

      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(ProviderScope(observers: [Logger()], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Take Order',
      theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.indigo,
          navigationBarTheme:
              NavigationBarThemeData(backgroundColor: Colors.white),
          appBarTheme: AppBarTheme(
              backgroundColor: Theme.of(context).canvasColor,
              foregroundColor: Colors.black,
              scrolledUnderElevation: 0,
              elevation: 0.0),
          textTheme:
              GoogleFonts.notoSansThaiTextTheme(Theme.of(context).textTheme)),
      home: MyHomePage(),
    );
  }
}
