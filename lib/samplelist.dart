import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukke/db.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Campioni'),
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
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
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
              const Divider(
                height: 10,
                thickness: 1,
                indent: 8,
                endIndent: 8,
                color: Colors.black45,
              ),
              SampleSummaryTable(key: sampleSummaryPageKey),
            ],
        ),
      ),
    );
  }
}

class SampleSummaryTable extends StatefulWidget {
  const SampleSummaryTable({super.key});

  @override
  _SampleSummaryTable createState() => _SampleSummaryTable();
}

class _SampleSummaryTable extends State<SampleSummaryTable> {
  Future<List<SampleListItem>> samples = fetchSamples();
  Key sampleSummaryKey = new UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        key: sampleSummaryKey,
        future: fetchSamples(),
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

  Widget summaryTable(List<SampleListItem> data) {
    return CupertinoScrollbar(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
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
            sampleSummaryKey = new UniqueKey();
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
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(sample.name),
          ),
        ],
      ),
    );
  }

  static Future<List<SampleListItem>> fetchSamples() async {
    final db = await DBService().db;
    final maps = await db.rawQuery('SELECT [id], [name] FROM [Summary] ORDER BY [name];');
    return maps.map((e) => SampleListItem.fromMap(e)).toList();
  }
}
