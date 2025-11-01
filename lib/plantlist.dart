import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sukke/db.dart';
import 'package:sukke/theme/functions.dart';
import 'package:sukke/theme/theme.dart';
import 'package:sukke/theme/elements.dart';
import 'package:sukke/plantpage.dart';
import 'package:sukke/objects/plantobj.dart';
import 'package:sukke/plantEditPage.dart';


class PlantSummaryPage extends StatefulWidget {
  const PlantSummaryPage({super.key});

  @override
  State<PlantSummaryPage> createState() => _PlantSummaryPageState();
}

class _PlantSummaryPageState extends State<PlantSummaryPage> {
  late Future<List<PlantListItem>> _futurePlantList;
  late TextEditingController searchController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: '');
    _futurePlantList = _fetchPlants(searchController.text);
  }

  void _refreshData() {
    setState(() {
      _futurePlantList = _fetchPlants(searchController.text);
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
        title: Text(
          'Piante',
          style: textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantAnagraphicEditPage(
                    fieldsMap: newAnagraphicalMap, plantId: null
                  )
                ),
              );
              searchController.text = '';
              Timer(const Duration(milliseconds: 200), () {
                _refreshData();
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                key: ValueKey('plant_summary_head'),
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
                future: _futurePlantList,
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

  Widget summaryTable(List<PlantListItem> data) {
    return CupertinoScrollbar(
      child: ListView(
        padding: padLR8,
        children: data.map((plant) => summaryRow(plant)).toList(),
      ),
    );
  }

  Widget summaryRow(PlantListItem plant) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantMainPage(id: plant.id)
          ),
        );
        searchController.text = '';
        Timer(const Duration(milliseconds: 200), () {
          _refreshData();
        });
      },
      child: Row(
        key: ValueKey(plant.id),
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              plant.id.toString(),
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 5,
            child: createSimpleBodyText(plant.name, false),
          ),
        ],
      ),
    );
  }

  Future<List<PlantListItem>> _fetchPlants(String partialSearch) async {
    var query = '''
      SELECT [id], COALESCE([species], [commonName])||' '||COALESCE([variant], '') AS [name]
      FROM [Plant]
    ''';
    if (partialSearch.isNotEmpty) {
      query += '''
       WHERE [name] LIKE '%$partialSearch%'
       OR [id] LIKE '%$partialSearch%'
      ''';
    }
    query += ' ORDER BY [name];';

    final db = await DBService().db;
    final res = await db.rawQuery(query);
    return res.map((e) => PlantListItem.fromMap(e)).toList();
  }
}

