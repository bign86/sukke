import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:sukke/constants.dart';
import 'package:sukke/samplelist.dart';
import 'package:sukke/theme/theme.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );

    return MaterialApp(
      title: appTitle,
      theme: mainTheme,

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('it'), // Italian
      ],
      home: const SampleSummaryPage(),
    );
  }
}
