
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sukke/db.dart';
import 'package:sukke/constants.dart';
import 'package:sukke/theme/theme.dart';
import 'package:sukke/theme/elements.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Settings',
          style: textTheme.titleLarge,
        ),
      ),
      body: Center(
        child: settingsPage(),
      ),
    );
  }

  Widget settingsPage() {
    return CupertinoScrollbar(
      child: ListView(
        padding: padAll8,
        children: [
          box10,
          Center(
            child: TextButton.icon(
              onPressed: () async {
                final db = await DBService().db;
                Share.shareXFiles(
                    [XFile(db.path)],
                    subject: 'Backup $appTitle',
                    text: 'Allegato il database di $appTitle!'
                );
              },
              icon: const Icon(Icons.share),
              label: const Text('Backup the Database by sharing',),
            ),
          ),
          box5,
          Center(
            child: TextButton.icon(
              onPressed: () async {
                await backupDatabaseToDownloads(context);
              },
              icon: const Icon(Icons.download),
              label: const Text('Backup the Database in Downloads',),
            ),
          ),
          box5,
          Center(
            child: TextButton.icon(
              onPressed: () async {
                final err = await substituteDB();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(err);
                }
              },
              icon: const Icon(Icons.upload),
              label: const Text('Upload a backup Database',),
            ),
          ),
          box30,
          dividerGray20,
          box30,
          Text(
            'Version: $appVersion',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
          Text(
            'Author: $appAuthor',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

Future<SnackBar> substituteDB() async {
  // Pick the file
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  // If a file has been picked
  if (result != null) {
    File newDB = File(result.files.single.path!);
    final dbPath = DBService().path();

    try {

      // If the DB exists eliminate it and substitute
      if (await databaseExists(dbPath!)) {
        await deleteDatabase(dbPath);
        await newDB.copy(dbPath);

      // If it does not exists send out an error
      } else {
        return SnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red[700],
          content: const Text('Error in substituting the Database'),
        );
      }

      // If everything is well just return
      return SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green[700],
        content: const Text('Database recovered up successfully'),
      );

    // In case of error print out an error
    } catch (err) {
      return SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red[700],
        content: Text('Error in substituting the Database with error:\n$err'),
      );
    }

  } else {
    // User canceled the picker
    return SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.amber[700],
      content: const Text('Nothing has been picked'),
    );
  }
}

Future<void> backupDatabaseToDownloads(BuildContext context) async {
  try {
    final db = await DBService().db;
    final Directory? downloadsDir = await getDownloadsDirectory();

    if (downloadsDir != null) {
      final String newPath = '${downloadsDir.path}/plants.db';
      await File(db.path).copy(newPath);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.green[700],
            content: Text('Database backed up successfully at $newPath'),
          ),
        );
      }
    } else {
      throw Exception('Could not get downloads directory');
    }
  } catch (err) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red[700],
          content: Text('Error backing up database: $err'),
        ),
      );
    }
  }
}

