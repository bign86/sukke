import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sukke/db.dart';
import 'package:sukke/theme/elements.dart';
import 'package:sukke/theme/functions.dart';
import 'package:sukke/theme/theme.dart';
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
  late Future<List<SampleListItem>> _futureSampleList;
  late TextEditingController searchController;
  Timer? _debounce;
  List<SampleListItem>? _cachedList;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: '');
    _futureSampleList = _fetchSamples(searchController.text);
  }

  void _refreshData() {
    setState(() {
      _futureSampleList = _fetchSamples(searchController.text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

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
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SampleAddPage()
                ),
              );
              if (!mounted) return;
              searchController.text = '';
              _refreshData();
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            vBox5,
            Text(
              'I miei esemplari',
              textAlign: TextAlign.center,
              style: textTheme.titleLarge,
            ),
            vBox5,
            Padding(
              padding: padLR8,
              child: TextField(
                controller: searchController,
                style: textTheme.labelLarge,
                autofocus: false,
                showCursor: true,
                maxLines: 1,
                selectionHeightStyle: BoxHeightStyle.tight,
                cursorHeight: textTheme.labelLarge?.fontSize,
                onChanged: (value) {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    _refreshData();
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
            vBox10,
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
            Expanded(
              child: FutureBuilder(
                future: _futureSampleList,
                builder: (context, snapshot) {

                  if (snapshot.hasData) {
                    _cachedList = snapshot.data;
                  }

                  if (_cachedList != null) {
                    return summaryTable(_cachedList!); // Show existing data even if loading
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return const Text("No data available");
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
      child: ListView.builder(
        padding: padLR8,
        itemCount: data.length,
        itemBuilder: (context, index) => summaryRow(data[index]),
        //children: data.map((sample) => summaryRow(sample)).toList(),
      ),
    );
  }

  Widget summaryRow(SampleListItem sample) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SampleMainPage(id: sample.id)
          ),
        );
        if (!mounted) return;
        searchController.text = '';
        _refreshData();
      },
      child: Row(
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
            child: createSimpleBodyText(sample.name, false),
          ),
        ],
      ),
    );
  }

  Future<List<SampleListItem>> _fetchSamples(String partialSearch) async {
    var query = 'SELECT [id], [name] FROM [Summary]';
    List<dynamic> args = [];


    if (partialSearch.isNotEmpty) {
      //query += '''
      //  WHERE [name] LIKE '%$partialSearch%'
      //  OR [id] LIKE '%$partialSearch%'
      //''';
      query += ' WHERE [name] LIKE ? OR [id] LIKE ?';
      args.add('%$partialSearch%');
      args.add('%$partialSearch%');
    }
    query += ' ORDER BY [name];';

    final db = await DBService().db;
    final maps = await db.rawQuery(query, args);
    return maps.map((e) => SampleListItem.fromMap(e)).toList();
  }
}
