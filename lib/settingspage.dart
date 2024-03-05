
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sukke/db.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static const String version = '0.1.0';
  static const String author = 'Nero';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Settings',),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: fetchSettings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Future creation error'); // error
              } else if (snapshot.hasData) {
                return settingsPage(snapshot.data);
              } else {
                return const Text("No data available");
              }
            } else {
              return const Text('Error'); // error
            }
          },
        ),
      ),
    );
  }

  Future<String> fetchSettings() async {
    const String query = 'SELECT [valueText] FROM [System] WHERE [key] = "userEmail"';
    final db = await DBService().db;
    final map = await db.rawQuery(query);
    return map[0]['valueText'] as String;
  }

  Widget settingsPage(String? data) {
    TextEditingController controller = TextEditingController(text: data);

    return CupertinoScrollbar(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const SizedBox(height: 10),
          /*Row(
            children: [
              const Expanded(
                flex: 1,
                child: Text('Email',),
              ),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: controller,
                  style: const TextStyle(fontSize: 12,),
                  onChanged: (String value) {
                    controller.text = value;
                  },
                  onSubmitted: (String value) {
                    updateEmail(value);
                  },
                  autofocus: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),*/
          Center(
            child: TextButton.icon(
              onPressed: () async {
                final db = await DBService().db;
                Share.shareXFiles(
                    [XFile(db.path)],
                    subject: 'Backup Sukke',
                    text: 'Allegato il database di Sukke!'
                );
              },
              icon: const Icon(
                  Icons.share
              ),
              label: const Text('Backup the Database by sharing',),
            ),
          ),
          const SizedBox(height: 50),
          const Divider(
            color: Colors.black26,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: 30),
          const Center(
            child: Text(
              'Version: ${SettingsPage.version}',
            )
          ),
          const Center(
              child: Text(
                'Author: ${SettingsPage.author}',
              )
          ),
        ],
      ),
    );
  }

  /*Future<Null> updateEmail(String? text) async {
    final db = await DBService().db;
    const query = 'UPDATE [System] SET [valueText] = ?1 WHERE [key] = "userEmail"';
    await db.rawUpdate(query, [text]);
    setState(() {});
  }*/
}
