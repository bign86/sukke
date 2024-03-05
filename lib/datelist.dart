import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukke/db.dart';
import 'package:sukke/objects/dateobj.dart';
import 'package:sukke/samplepage.dart';

class DateSummaryPage extends StatelessWidget {
  const DateSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Date'),
        actions: [],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                key: ValueKey('date_summary_head'),
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
                      'Water',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Fertilize',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Repot',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Pests',
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
            DateSummaryTable(),
          ],
        ),
      ),
    );
  }
}

class DateSummaryTable extends StatefulWidget {
  const DateSummaryTable({super.key});

  @override
  _DateSummaryTable createState() => _DateSummaryTable();
}

class _DateSummaryTable extends State<DateSummaryTable> {
  //Future<List<DateListItem>> dates = fetchDates();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: fetchDates(),
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

  Widget summaryTable(List<DateListItem> data) {
    return CupertinoScrollbar(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
        children: data.map((date) => summaryRow(date)).toList(),
      ),
    );
  }

  Widget summaryRow(DateListItem date) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SampleMainPage(id: date.id)
          ),
        );
      },
      child: Row(
        key: ValueKey(date.id),
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              date.id.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              (date.water ?? '-').toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              (date.fertilize ?? '-').toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
            (date.repot ?? '-').toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              (date.pests ?? '-').toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  static Future<List<DateListItem>> fetchDates() async {
    const String query = '''
    SELECT
    	[id], [waterDelta] AS water, [repotDelta] AS repot,
    	[fertilizeDelta] AS fertilize, [pestsDelta] AS pests
    FROM [Summary] ORDER BY [id];
    ''';
    final db = await DBService().db;
    final maps = await db.rawQuery(query);
    return maps.map((e) => DateListItem.fromMap(e)).toList();
  }
}
