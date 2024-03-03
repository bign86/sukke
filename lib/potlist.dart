import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukke/db.dart';
import 'package:sukke/objects/potobj.dart';

class PotSummaryPage extends StatelessWidget {
  const PotSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Vasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                key: ValueKey('pot_summary_head'),
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(
                      'ID',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Materiale',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Forma',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Deep?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'cm',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 10,
              thickness: 1,
              indent: 8,
              endIndent: 8,
              color: Colors.black45,
            ),
            PotSummaryTable(),
          ],
        ),
      ),
    );
  }
}

class PotSummaryTable extends StatefulWidget {
  const PotSummaryTable({super.key});

  @override
  _PotSummaryTable createState() => _PotSummaryTable();
}

class _PotSummaryTable extends State<PotSummaryTable> {
  Future<List<Pot>> pots = fetchPots();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: pots,
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

  Widget summaryTable(List<Pot> data) {
    return CupertinoScrollbar(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: data.map((pot) => summaryRow(pot)).toList(),
      ),
    );
  }

  Widget summaryRow(Pot pot) {
    return Row(
        key: ValueKey(pot.id),
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              pot.id.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              pot.material.label,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              pot.shape.label,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              pot.deep ? "Yes" : "No",
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              pot.size.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
  }

  static Future<List<Pot>> fetchPots() async {
    const String query = '''
    SELECT
      [id], [material], [shape], [deep], [size]
    FROM [Pot] ORDER BY [material], [shape], [size];
    ''';
    final db = await DBService().db;
    final maps = await db.rawQuery(query);
    return maps.map((e) => Pot.fromMap(e)).toList();
  }
}
