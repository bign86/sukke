import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sukke/db.dart';
import 'package:sukke/theme/theme.dart';
import 'package:sukke/theme/elements.dart';
import 'package:sukke/plantpage.dart';
import 'package:sukke/objects/plantobj.dart';
import 'package:sukke/plantAnagraphicEditPage.dart';


class PlantSummaryPage extends StatefulWidget {
  const PlantSummaryPage({super.key});

  @override
  State<PlantSummaryPage> createState() => _PlantSummaryPageState();
}

class _PlantSummaryPageState extends State<PlantSummaryPage> {
  String _query = '';
  UniqueKey futureKey = UniqueKey();

  Null reset() {
    setState(() {
      _query = '';
    });
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
                  builder: (context) => PlantAnagraphicEditPage(fieldsMap: newAnagraphicalMap)
                ),
              ).then( <Map>(newFields) async {
                if (newFields != null) {
                  if (newFields.isNotEmpty) {
                    newPlantToDB(newFields);
                    setState(() {
                      _query = '';
                      futureKey = UniqueKey();
                    });
                    //reset();
                  }
                }
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                key: futureKey,
                future: fetchPlants(_query),
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
              builder: (context) => PlantMainPage(id: plant.id)),
          ).then( (value) async => setState(() {
            _query = '';
            futureKey = UniqueKey();
          })
        );
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
            child: Text(
              plant.name,
              style: textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  static Future<List<PlantListItem>> fetchPlants(String partialSearch) async {
    var query = 'SELECT [id], COALESCE([species], [commonName])||" "||COALESCE([variant], "") AS [name] FROM [Plant]';
    if (partialSearch.isNotEmpty) {
      query += '''
       WHERE [name] LIKE "%$partialSearch%"
       OR [id] LIKE "%$partialSearch%";
      ''';
    }
    query += ' ORDER BY [name];';

    final db = await DBService().db;
    final res = await db.rawQuery(query);
    return res.map((e) => PlantListItem.fromMap(e)).toList();
  }
}

