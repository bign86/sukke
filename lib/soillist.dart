import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukke/objects/soilobj.dart';
import 'package:sukke/newsoil.dart';
import 'package:sukke/db.dart';


class SoilSummaryPage extends StatefulWidget {
  const SoilSummaryPage({super.key});

  @override
  State<SoilSummaryPage> createState() => _SoilSummaryPage();
}

class _SoilSummaryPage extends State<SoilSummaryPage> {

  Key soilKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Terreni'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewSoilPage(),
                ),
              ).then( (newSoil) async {
                if (newSoil != null) {
                  saveNewSoil(newSoil);
                  soilKey = UniqueKey();
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                key: const ValueKey('soil_summary_head'),
                children: soilLabelsList(),
              ),
            ),
            const Divider(
              height: 10,
              thickness: 1,
              indent: 8,
              endIndent: 8,
              color: Colors.black45,
            ),
            SoilSummaryTable(key: soilKey),
          ],
        ),
      ),
    );
  }

  List<Expanded> soilLabelsList() {
    List<Expanded> l = [
      const Expanded(
        flex: 1,
        child: Text(
          'ID',
          textAlign: TextAlign.left,
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
      )
    ];
    for (MapEntry e in Soil.componentsNames.entries) {
      l.add(
        Expanded(
          flex: 1,
          child: RotatedBox(
            quarterTurns: 1,
            child: Text(
              e.value,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.w300),
            ),
          ),
        )
      );
    }
    return l;
  }

  Future<Null> saveNewSoil(Map newSoil) async {
    final db = await DBService().db;
    const String idQuery = 'SELECT [valueNum] FROM [System] WHERE key = "maxIdSoilMix";';
    final newIdMap = await db.rawQuery(idQuery);
    final int newId = (newIdMap[0]['valueNum'] as int) + 1;

    String insertQuery = 'INSERT INTO [SoilMix] ([id],[';
    insertQuery += newSoil.keys.join('], [');
    insertQuery += ']) VALUES (';

    var argsString = <String>[];
    for (int i = 1; i <= (newSoil.length + 1); ++i) {
      argsString.add('?$i');
    }
    insertQuery += argsString.join(', ');
    insertQuery += ');';

    var args = <num>[newId];
    for (var element in newSoil.values) {args.add(element);}
    await db.rawInsert(insertQuery, args);

    String maxIdSoilMix = '''
      UPDATE [System] SET [valueNum] = ?1
      WHERE [key] = "maxIdSoilMix";
      ''';
    await db.rawUpdate(maxIdSoilMix, [newId]);

    setState(() {});
  }
}

class SoilSummaryTable extends StatefulWidget {
  const SoilSummaryTable({super.key});

  @override
  _SoilSummaryTable createState() => _SoilSummaryTable();
}

class _SoilSummaryTable extends State<SoilSummaryTable> {
  Future<List<Soil>> soils = Soil.fetchSoilList();
  Key soilSummaryKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        key: soilSummaryKey,
        future: soils,
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
    );
  }

  Widget summaryTable(List<Soil> data) {
    return CupertinoScrollbar(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: data.map((soil) => summaryRow(soil)).toList(),
      ),
    );
  }

  Widget summaryRow(Soil soil) {
    List<Widget> l = [
      Expanded(
        flex: 1,
        child: Text(
          soil.id.toString(),
          textAlign: TextAlign.left,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      )
    ];

    Map<String, num> soilComp = soil.toMap();
    for (MapEntry e in soilComp.entries) {
      if (e.key == 'id') {
        continue;
      } else {
        l.add(
          Expanded(
            flex: 1,
            child: Text(
              (e.value*100).toInt().toString(),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }

    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Attenzione!'),
            content: Text('Vuoi davvero cancellare ${soil.id}?'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Annulla')
              ),
              ElevatedButton(
                onPressed: () {
                  deleteSoil(soil.id);
                  setState(() {soilSummaryKey = UniqueKey();});
                  Navigator.pop(context);
                },
                child: const Text('Cancella!')
              ),
            ],
          ),
        );
      },
      child: Row(
        key: ValueKey(soil.id),
        children: l,
      )
    );
  }

  Future<Null> deleteSoil(int id) async {
    final db = await DBService().db;
    await db.rawDelete('DELETE FROM [SoilMix] WHERE [id] = ?1;', [id]);
  }
}
