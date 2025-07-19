import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukke/theme/elements.dart';

import 'package:sukke/theme/theme.dart';
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
        title: Text(
          'Date',
          style: textTheme.titleLarge,
        ),
        actions: const [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            box10,
            Padding(
              padding: padLR16,
              child: Row(
                key: ValueKey('date_summary_head'),
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      'ID',
                      textAlign: TextAlign.center,
                      style: textTheme.labelLarge,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Name',
                      textAlign: TextAlign.center,
                      style: textTheme.labelLarge,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Water',
                      textAlign: TextAlign.center,
                      style: textTheme.labelLarge,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Fertilize',
                      textAlign: TextAlign.center,
                      style: textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
            ),
            dividerGray10,
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
  Key datesSummaryPageKey = UniqueKey();
  Future<List<DateListItem>> fetchedDates = fetchDates();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: fetchedDates,
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
        padding: padLR8,
        children: data.map((date) => summaryRow(date)).toList(),
      ),
    );
  }

  Widget summaryRow(DateListItem date) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SampleMainPage(id: date.id)
          ),
        );
        setState(() {
          fetchedDates = fetchDates();
        });
      },
      child: Row(
        key: ValueKey(date.id),
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              date.id.toString(),
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              date.name.toString(),
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              (date.water ?? '-').toString(),
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              (date.fertilize ?? '-').toString(),
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  static Future<List<DateListItem>> fetchDates() async {
    const String query = '''
    SELECT
    	[id], [name], [waterDelta] AS water, [fertilizeDelta] AS fertilize
    FROM [Summary] ORDER BY [waterDelta] desc;
    ''';
    final db = await DBService().db;
    final maps = await db.rawQuery(query);
    return maps.map((e) => DateListItem.fromMap(e)).toList();
  }
}
