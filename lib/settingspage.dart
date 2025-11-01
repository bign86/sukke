import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sukke/db.dart';
import 'package:sukke/constants.dart';
import 'package:sukke/objects/dateobj.dart';
import 'package:sukke/theme/elements.dart';
import 'package:sukke/theme/functions.dart';
import 'package:sukke/theme/theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int numPlants = 0;
  int numSamples = 0;
  DateTime winterStart = DateFormat('MM-dd').parse('10-01');
  DateTime winterEnd = DateFormat('MM-dd').parse('04-01');

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final db = await DBService().db;
    final plantsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM [Plant];'),
    );
    final samplesCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM [Sample];'),
    );

    final wStartRes = await db.rawQuery(
      "SELECT [valueText] FROM [System] WHERE [key] = 'winterStart';",
    );
    final wEndRes = await db.rawQuery(
      "SELECT [valueText] FROM [System] WHERE [key] = 'winterEnd';",
    );

    final wStartString = (wStartRes.firstOrNull?['valueText'] as String?);
    DateTime wStart = winterStart;
    if (wStartString != null) {
      wStart = DateFormat('MM-dd').parse(wStartString);
    }
    final wEndString = (wEndRes.firstOrNull?['valueText'] as String?);
    DateTime wEnd = winterEnd;
    if (wEndString != null) {
      wEnd = DateFormat('MM-dd').parse(wEndString);
    }

    setState(() {
      numPlants = plantsCount ?? 0;
      numSamples = samplesCount ?? 0;
      winterStart = wStart;
      winterEnd = wEnd;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Settings', style: textTheme.titleLarge),
      ),
      body: Center(child: settingsPage()),
    );
  }

  Widget settingsPage() {
    return CupertinoScrollbar(
      child: ListView(
        padding: padAll8,
        children: [
          vBox10,
          createSimpleBodyText(
            'There are: ${numPlants.toString()} plants and ${numSamples.toString()} specimens in the DB!',
            true,
          ),
          vBox10,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              createSimpleBodyText('Winter time', true),
              hBox10,
              Column(
                children: [
                  Row(
                    children: [
                      createSimpleBodyText('Start:', true),
                      createSimpleBodyText(
                        '${winterStart.day} of ${DateFormat('MMMM').format(winterStart)}',
                        true,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      createSimpleBodyText('End:', true),
                      createSimpleBodyText(
                        '${winterEnd.day} of ${DateFormat('MMMM').format(winterEnd)}',
                        true,
                      ),
                    ],
                  ),
                ],
              ),
              hBox10,
              Center(
                child: TextButton.icon(
                  onPressed: () async {
                    DateTime tempWinterStart = winterStart;
                    DateTime tempWinterEnd = winterEnd;

                    final result = await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (context, setDialogState) {
                            return AlertDialog(
                              title: const Text('Set Winter Period'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Select Winter Start Date (Month and Day)',),
                                  ElevatedButton(
                                    child: Text(DateFormat('MMMM d',).format(tempWinterStart),),
                                    onPressed: () async {
                                      await showDialog<String?>(
                                        context: context,
                                        builder: (context) => DateSelectionWidget(
                                          month: tempWinterStart.month,
                                          day: tempWinterStart.day,
                                        ),
                                      ).then((date) {
                                        if (!context.mounted) return;
                                        if (date != null) {
                                          setState(() {tempWinterStart = DateFormat('MM-dd',).parse(date);});
                                        }
                                      });
                                    },
                                  ),
                                  vBox20,
                                  const Text('Select Winter End Date (Month and Day)',),
                                  ElevatedButton(
                                    child: Text(DateFormat('MMMM d',).format(tempWinterEnd),),
                                    onPressed: () async {
                                      await showDialog<String?>(
                                        context: context,
                                        builder: (context) => DateSelectionWidget(
                                          month: tempWinterEnd.month,
                                          day: tempWinterEnd.day,
                                        ),
                                      ).then((date) {
                                        if (!context.mounted) return;
                                        if (date != null) {
                                          setState(() {tempWinterEnd = DateFormat('MM-dd',).parse(date);});
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                TextButton(
                                  child: const Text('Save'),
                                  onPressed: () {
                                    String dates = "${DateFormat('MM-dd').format(tempWinterStart)}|${DateFormat('MM-dd').format(tempWinterEnd)}";
                                    Navigator.of(context).pop(dates);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );

                    if (result != null) {
                      final parts = result.split('|');
                      final newWinterStart = DateFormat('MM-dd').parse(parts[0]);
                      final newWinterEnd = DateFormat('MM-dd').parse(parts[1]);

                      final db = await DBService().db;
                      await db.rawUpdate("UPDATE [System] SET [valueText] = ? WHERE [key] = 'winterStart';", [DateFormat('MM-dd').format(newWinterStart)]);
                      await db.rawUpdate("UPDATE [System] SET [valueText] = ? WHERE [key] = 'winterEnd';", [DateFormat('MM-dd').format(newWinterEnd)]);

                      _loadCounts();
                    }

                  },
                  icon: const Icon(Icons.edit_calendar),
                  label: const Text('Edit'),
                  iconAlignment: IconAlignment.end,
                ),
              ),
            ],
          ),
          vBox20,
          dividerGray20,
          vBox20,
          Center(
            child: TextButton.icon(
              onPressed: () async {
                final db = await DBService().db;
                Share.shareXFiles(
                  [XFile(db.path)],
                  subject: 'Backup $appTitle',
                  text: 'Allegato il database di $appTitle!',
                );
              },
              icon: const Icon(Icons.share),
              label: const Text('Backup the Database by sharing'),
            ),
          ),
          Center(
            child: TextButton.icon(
              onPressed: () async {
                await backupDatabaseToDownloads(context);
              },
              icon: const Icon(Icons.download),
              label: const Text('Backup the Database in Downloads'),
            ),
          ),
          Center(
            child: TextButton.icon(
              onPressed: () async {
                final err = await substituteDB();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(err);
                }
              },
              icon: const Icon(Icons.upload),
              label: const Text('Upload a backup Database'),
            ),
          ),
          vBox20,
          dividerGray20,
          vBox20,
          createSimpleBodyText('Version: $appVersion', true),
          createSimpleBodyText('Author: $appAuthor', true),
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
        return createErrorSnackBar('Error in substituting the Database');
      }

      // If everything is well just return
      return createErrorSnackBar(
        'Database recovered up successfully',
        color: statusGood,
      );

      // In case of error print out an error
    } catch (err) {
      return createErrorSnackBar(
        'Error in substituting the Database with error:\n$err',
      );
    }
  } else {
    // User canceled the picker
    return createErrorSnackBar('Nothing has been picked', color: statusWarn);
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
          createErrorSnackBar(
            'Database backed up successfully at $newPath',
            color: statusGood,
          ),
        );
      }
    } else {
      throw Exception('Could not get downloads directory');
    }
  } catch (err) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(createErrorSnackBar('Error backing up database: $err'));
    }
  }
}
