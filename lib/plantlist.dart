import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukke/db.dart';
import 'package:sukke/plantpage.dart';
import 'package:sukke/objects/plantobj.dart';
import 'package:sukke/plantAnagraphicEditPage.dart';


class PlantSummaryPage extends StatefulWidget {
  const PlantSummaryPage({super.key});

  @override
  State<PlantSummaryPage> createState() => _PlantSummaryPageState();
}

class _PlantSummaryPageState extends State<PlantSummaryPage> {
  Future<List<PlantListItem>> samples = fetchPlants();
  static Map<String, dynamic> newAnagraphicalMap = {
    'family': '', 'genus': '', 'species': '', 'variant': null,
    'synonyms': [], 'countries': [], 'cultivar': false,
    'commonName': '', 'growthRate': GrowthRate.na,
    'dormantSeason': DormantSeason.na, 'TMin': 0,
    'wateringNeeds': Needs.medium, 'lightNeeds': Needs.medium,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Piante',),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantAnagraphicEditPage(fieldsMap: newAnagraphicalMap)
                ),
              ).then( <Map>(newFields) async {
                if (newFields != null) {
                  if (newFields.isNotEmpty) {
                    newPlantToDB(newFields);
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
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
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
            const Divider(
              height: 10,
              thickness: 1,
              indent: 8,
              endIndent: 8,
              color: Colors.black45,
            ),
            Expanded(
              child: FutureBuilder(
                future: samples,
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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: data.map((plant) => summaryRow(plant)).toList(),
      ),
    );
  }

  Widget summaryRow(PlantListItem plant) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PlantMainPage(id: plant.id)),
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
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(plant.name),
          ),
        ],
      ),
    );
  }

  static Future<List<PlantListItem>> fetchPlants() async {
    final db = await DBService().db;
    final res = await db.rawQuery('SELECT [id], COALESCE([species], [commonName])||" "||COALESCE([variant], "") AS [name] FROM [Plant] ORDER BY [name];');
    return res.map((e) => PlantListItem.fromMap(e)).toList();
  }

  Future<Null> newPlantToDB(Map<String, dynamic> newFields) async {
    final db = await DBService().db;
    final List<Map> res = await db.rawQuery('SELECT [valueNum] FROM [System] WHERE [key] = "maxIdPlant";');
    final int id = (res[0]['valueNum'] as int) + 1;

    Map<String, dynamic> data = Map.of(newAnagraphicalMap)..addAll(newFields);
    String newPlantQuery = '''
    UPDATE [Plant] SET
    [family] = "${data['family']}",
    [genus] = "${data['genus']}",
    [species] = "${data['species']}",
    [variant] = "${data['variant']}",
    [synonyms] = ?1,
    [countries] = ?2,
    [cultivar] = ${data['cultivar'] ? 1 : 0},
    [commonName] = "${data['commonName']}",
    [growthRate] = ${data['growthRate'].value},
    [dormantSeason] = ${data['dormantSeason'].value},
    [TMin] = ${data['TMin']}, 
    [wateringNeeds] = ${data['wateringNeeds'].value},
    [lightNeeds] = ${data['lightNeeds'].value}
    WHERE [id] = ?3;
    ''';
    final List arguments = [jsonEncode(data['synonyms']), jsonEncode(data['countries']), id];
    await db.rawUpdate(newPlantQuery, arguments);

    String maxIdQuery = '''
    UPDATE [System] SET [valueNum] = ?1
    WHERE [key] = "maxIdPlant";
    ''';
    await db.rawUpdate(maxIdQuery, [id]);

    setState(() {});
  }
}
