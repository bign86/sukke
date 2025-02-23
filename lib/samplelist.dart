import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sukke/db.dart';
import 'package:sukke/theme/theme.dart';
import 'package:sukke/theme/elements.dart';
import 'package:sukke/samplepage.dart';
import 'package:sukke/plantlist.dart';
import 'package:sukke/soillist.dart';
import 'package:sukke/datelist.dart';
import 'package:sukke/objects/sampleobj.dart';
import 'package:sukke/addsample.dart';
import 'package:sukke/settingspage.dart';


class SampleSummaryPage extends StatefulWidget {
  const SampleSummaryPage({super.key});

  @override
  State<SampleSummaryPage> createState() => _SampleSummaryPage();
}

class _SampleSummaryPage extends State<SampleSummaryPage> {
  Key sampleSummaryPageKey = UniqueKey();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.grass),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PlantSummaryPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DateSummaryPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bubble_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SoilSummaryPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SampleAddPage()
                ),
              ).then( (n) async {
                setState(() {sampleSummaryPageKey = UniqueKey();});
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SettingsPage()
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          key: sampleSummaryPageKey,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            box5,
            Text(
              'Le mie piante',
              textAlign: TextAlign.center,
              style: textTheme.titleLarge,
            ),
            box5,
            Padding(
              padding: padLR8,
              child: TextField(
                style: textTheme.labelLarge,
                autofocus: false,
                showCursor: true,
                maxLines: 1,
                selectionHeightStyle: BoxHeightStyle.tight,
                cursorHeight: textTheme.labelLarge?.fontSize,
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintMaxLines: 1,
                  isCollapsed: false,
                  hintStyle: textTheme.labelLarge,
                  border: OutlineInputBorder(
                    borderRadius: borderR10,
                  ),
                  fillColor: Colors.grey[200],
                  prefixIcon: Icon(Icons.search,),
                ),
              ),
            ),
            box10,
            const Padding(
              padding: padLR8,
              child: Row(
                key: ValueKey('sample_summary_head'),
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      'ID',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Nome',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
            ),
            dividerGray10,
            //SampleSummaryTable(key: sampleSummaryPageKey),
            Expanded(
              child: FutureBuilder(
                key: UniqueKey(),
                future: fetchSamples(_query),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return summaryTable(snapshot.data!);
                  } else {
                    return const Text("No data available");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget summaryTable(List<SampleListItem> data) {
    return CupertinoScrollbar(
      child: ListView(
        padding: padLR8,
        children: data.map((sample) => summaryRow(sample)).toList(),
      ),
    );
  }

  Widget summaryRow(SampleListItem sample) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SampleMainPage(id: sample.id)
          ),
        ).then((c) {
          setState(() {
            //sampleSummaryKey = UniqueKey();
          });
        });
      },
      child: Row(
        key: ValueKey(sample.id),
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              sample.id.toString(),
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              sample.name,
              style: textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  static Future<List<SampleListItem>> fetchSamples(String partialSearch) async {
    var query = 'SELECT [id], [name] FROM [Summary]';
    if (partialSearch.isNotEmpty) {
      query += ' WHERE [name] LIKE "%$partialSearch%" OR [id] LIKE "%$partialSearch%";';
    }
    query += ' ORDER BY [name];';

    final db = await DBService().db;
    final maps = await db.rawQuery(query);
    return maps.map((e) => SampleListItem.fromMap(e)).toList();
  }
}
