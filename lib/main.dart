import 'package:flutter/material.dart';
import 'package:sukke/samplelist.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sukke',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: 0.8,
              fontSizeDelta: 0.9,
            ),
      ),
      home: const SampleSummaryPage(),
    );
  }
}
