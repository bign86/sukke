
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sukke/db.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static const String version = '0.1.1';
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
        child: settingsPage(),
      ),
    );
  }

  Widget settingsPage() {
    return CupertinoScrollbar(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const SizedBox(height: 30),
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
              icon: const Icon(Icons.share),
              label: const Text('Backup the Database by sharing',),
            ),
          ),
          const SizedBox(height: 30),
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
}
