import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clean_calendar/clean_calendar.dart';
import 'package:intl/intl.dart';

import 'package:sukke/db.dart';
import 'package:sukke/theme/elements.dart';
import 'package:sukke/theme/functions.dart';
import 'package:sukke/theme/theme.dart';
import 'package:sukke/objects/sampleobj.dart';
import 'package:sukke/objects/potobj.dart';
import 'package:sukke/plantpage.dart';
import 'package:sukke/poteditpage.dart';
import 'package:sukke/objects/events.dart';
import 'package:sukke/sampleeditpage.dart';
import 'package:sukke/objects/soilobj.dart';
import 'package:sukke/soilEditPage.dart';
import 'package:sukke/texteditpage.dart';


class SamplePageData {
  final SampleDetails sampleDetails;
  final Soil? soil;
  final List<DateTime> wateringDates;
  final double wateringFrequency;

  SamplePageData({
    required this.sampleDetails,
    this.soil,
    required this.wateringDates,
    required this.wateringFrequency,
  });
}

class SampleMainPage extends StatefulWidget {
  const SampleMainPage({super.key, required this.id});

  final int id;

  @override
  State<SampleMainPage> createState() => _SampleMainPageState();
}

class _SampleMainPageState extends State<SampleMainPage> {
  TextEditingController eventDate = TextEditingController();
  List<DateTime>? selectedDates;
  late Future<SamplePageData> _futureSamplePageData;
  SamplePageData? _cachedData;

  @override
  void initState() {
    super.initState();
    _futureSamplePageData = _fetchPageData(widget.id);
  }

  void _refreshData() {
    setState(() {
      _futureSamplePageData = _fetchPageData(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () async {
              final bool? confirmed = await showDialog<bool>(
                // Store a local reference to the context as the async
                // operation might occur after the widget is disposed
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Attenzione!'),
                  content: const Text('Vuoi davvero cancellare questo campione?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Annulla')
                    ),
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Cancella!')
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                try {
                  await deleteSample(widget.id);
                  if (!context.mounted) return;
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Errore durante la cancellazione: $e")),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<SamplePageData>(
          future: _futureSamplePageData,
          builder: (context, snapshot) {
            // If we have new data, update the cache
            if (snapshot.hasData) {
              _cachedData = snapshot.data;
            }

            // If there's an error and no cache, show error
            if (snapshot.hasError && _cachedData == null) {
              return Center(child: Text('Errore: ${snapshot.error}'));
            }

            // If we are waiting and have NO cache, show the spinner (Initial Load)
            if (snapshot.connectionState == ConnectionState.waiting && _cachedData == null) {
              return const CircularProgressIndicator();
            }

            // Build the page using the cached data
            if (_cachedData != null) {
              return sampleDetailsPage(_cachedData!, widget.id);
            }

            if (snapshot.hasError) {
              return const Text('Future creation error'); // error
            }

            return const Center(child: Text("Nessun dato disponibile"));
          },
        ),
      ),
    );
  }

  Widget sampleDetailsPage(SamplePageData pageData, int id) {
    final data = pageData.sampleDetails;
    final soil = pageData.soil;
    final selectedDates = pageData.wateringDates;
    final wateringFrequency = pageData.wateringFrequency;

    return CupertinoScrollbar(
      child: ListView(
        padding: padAll10,
        children: [
          vBox5,
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantMainPage(id: data.plant)
                ),
              );
            },
            child: Text(
              '#$id - ${data.species ?? data.commonName} ${data.variant}',
              textAlign: TextAlign.center,
              softWrap: true,
              style: textTheme.titleMedium,
            ),
          ),
          Center(
            child: TextButton.icon(
              icon: editIcon,
              label: createSectionHeaderText('Informazioni'),
              iconAlignment: IconAlignment.end,
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SampleEditPage(data: data)
                  ),
                );
                if (!mounted) return;
                _refreshData();
              },
            ),
          ),
          vBox5,
          Container(
            padding: padLR12,
            child: Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(1),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(
                  children: <TableCell>[
                    TableCell(child: Text('Born', style: keywordStyle,)),
                    TableCell(child: Text(data.born.toString(), style: textTheme.bodyMedium,)),
                    TableCell(child: Text('Crested', style: keywordStyle,)),
                    TableCell(child: createCheckIcon(data.crested),),
                  ],
                ),
                TableRow(
                  children: <TableCell>[
                    TableCell(child: Text('Bought', style: keywordStyle,)),
                    TableCell(child: createCheckIcon(data.bought),),
                    TableCell(child: Text('Variegated', style: keywordStyle,)),
                    TableCell(child: createCheckIcon(data.variegated),),
                  ],
                ),
                TableRow(
                  children: <TableCell>[
                    TableCell(child: Text('From seed', style: keywordStyle,)),
                    TableCell(child: createCheckIcon(data.fromSeed),),
                    TableCell(child: Text('Grafted', style: keywordStyle,)),
                    TableCell(child: createCheckIcon(data.grafted),),
                  ],
                ),
                TableRow(
                  children: <TableCell>[
                    TableCell(child: Text('From cutting', style: keywordStyle,)),
                    TableCell(child: createCheckIcon(data.fromCutting),),
                    TableCell(child: Text('Monstrous', style: keywordStyle,)),
                    TableCell(child: createCheckIcon(data.monstrous),),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: padLR12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                createKeyValueItem('Field Number: ', (data.fieldNumber ?? "-").toString(), textAlign: TextAlign.left),
                createKeyValueItem('Sample location: ', (data.location ?? "-").toString(), textAlign: TextAlign.left),
              ],
            ),
          ),
          vBox10,
          Container(
            padding: padAll12,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black45),
              shape: BoxShape.rectangle,
                borderRadius: borderR8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.severe_cold,
                          color: Colors.grey,
                        ),
                        if (data.tMin == null) const Text(' -')
                        else Text(' ${data.tMin.toString()} °C')
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.water_drop,
                          color: COLOR_ACCENT,
                        ),
                        Text(' ${data.wateringNeeds.value.toString()}'),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.light_mode,
                          color: Colors.amber,
                        ),
                        Text(' ${data.lightNeeds.value.toString()}'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          vBox10,
          Center(
            child: TextButton.icon(
              icon: editIcon,
              label: createSectionHeaderText('Note'),
              iconAlignment: IconAlignment.end,
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TextEditPage(title: 'Note', text: data.notes ?? "-")),
                ).then( (newText) async {
                  await updateSampleNotes(widget.id, newText.trim());
                  if (!mounted) return;
                  _refreshData();
                });
              },
            ),
          ),
          Padding(
            padding: padLR12,
            child: Text(data.notes ?? "-",),
          ),
          vBox10,
          Center(
            child: TextButton.icon(
              icon: editIcon,
              label: createSectionHeaderText('Vaso'),
              iconAlignment: IconAlignment.end,
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PotEditPage(fieldsMap: _potMap(data)),
                  ),
                ).then( (newPot) async {
                  if (newPot != null) {
                    await updatePot(newPot, widget.id);
                    if (!mounted) return;
                    _refreshData();
                  }
                });
              },
            ),
          ),
          Container(
            padding: padLR12,
            child: Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(
                  children: <TableCell>[
                    TableCell(child: Text('Materiale', style: keywordStyle, textAlign: TextAlign.center,)),
                    TableCell(child: Text(data.material.label, textAlign: TextAlign.left,),),
                    TableCell(child: Text('Size', style: keywordStyle, textAlign: TextAlign.center,)),
                    TableCell(child: Text(data.size.toString(), textAlign: TextAlign.center,),),
                  ],
                ),
                TableRow(
                  children: <TableCell>[
                    TableCell(child: Text('Forma', style: keywordStyle, textAlign: TextAlign.center,)),
                    TableCell(child: Text(data.shape.label, textAlign: TextAlign.left,),),
                    TableCell(child: Text('Deep', style: keywordStyle, textAlign: TextAlign.center,)),
                    TableCell(child: createCheckIcon(data.deep),),
                  ],
                ),
              ],
            ),
          ),
          vBox10,
          Center(
            child: TextButton.icon(
              icon: editIcon,
              label: createSectionHeaderText('Terreno'),
              iconAlignment: IconAlignment.end,
              onPressed: () async {
                int? soilId;
                if (soil != null) {
                  soilId = soil.id;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SampleSoilEditPage(id: soilId),
                  ),
                ).then( (newSoil) async {
                  if (newSoil != null) {
                    await updateSampleSoil(widget.id, newSoil);
                    if (!mounted) return;
                    _refreshData();
                  }
                });
              },
            ),
          ),
          // Replace the GridView block with this:
          if (soil != null)
            Padding(
              padding: padLR12,
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                alignment: WrapAlignment.center,
                children: _createSoilGrid(soil),
              ),
            ),
          //GridView.count(
            // crossAxisCount is the number of columns
          //  crossAxisCount: 2,
          //  scrollDirection: Axis.vertical,
          //  shrinkWrap: true,
          //  childAspectRatio: 5,
            // This creates two columns with two items in each column
          //  children: _createSoilGrid(soil),
          //),
          vBox5,
          createSectionHeaderText('Eventi'),
          vBox5,
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      'Innaffiato',
                      style: textTheme.headlineSmall,
                    ),
                    Text(' ${data.water ?? "-"}'),
                    Text('${data.waterDelta ?? "-"} gg'),
                    _buildEventIconButton(Event.water),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      'Concimato',
                      style: textTheme.headlineSmall,
                    ),
                    Text(' ${data.fertilize ?? "-"}'),
                    Text('${data.fertilizeDelta ?? "-"} gg'),
                    _buildEventIconButton(Event.fertilize),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      'Insetti',
                      style: textTheme.headlineSmall,
                    ),
                    Text(' ${data.pests ?? "-"}'),
                    Text('${data.pestsDelta ?? "-"} gg'),
                    _buildEventIconButton(Event.pests),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      'Rinvaso',
                      style: textTheme.headlineSmall,
                    ),
                    Text(' ${data.repot ?? "-"}'),
                    Text('${data.repotDelta ?? "-"} gg'),
                    _buildEventIconButton(Event.repot),
                  ],
                ),
              ),
            ],
          ),
          vBox10,
          Text(
            'Calendario delle innaffiature',
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall,
          ),
          vBox10,
          createSimpleBodyText('Average water frequency: ${wateringFrequency.toStringAsFixed(1)} days', true),
          vBox5,
          Padding(
            padding: padLR12,
            child: CleanCalendar(
              calendarDatesSectionMaxHeight: 180,
              datePickerCalendarView: DatePickerCalendarView.monthView,
              enableDenseViewForDates: true,
              enableDenseSplashForDates: true,
              dateSelectionMode: DatePickerSelectionMode.singleOrMultiple,
              onCalendarViewDate: (DateTime calendarViewDate) {
                // print(calendarViewDate);
              },
              selectedDatesProperties: DatesProperties(
                disable: true,  // To disable taps on selected dates.
              ),
              selectedDates: selectedDates,
              onSelectedDates: (List<DateTime> value) {
                setState(() {
                  if (selectedDates.contains(value.first)) {
                    selectedDates.remove(value.first);
                  } else {
                    selectedDates.add(value.first);
                  }
                });
              },
            ),
          ),
          vBox10,
        ],
      ),
    );
  }

  Widget _buildEventIconButton(Event event) {
    return IconButton(
      onPressed: () async {
        final bool? eventWasAdded = await _addEvent(event);
        if (eventWasAdded == true) {
          _refreshData();
        }
      },
      icon: Icon(
        Icons.add_circle_outline,
        color: Colors.grey[600],
      ),
    );
  }

  Future<List<DateTime>> _fetchWateringDates(int sampleId) async {
    final db = await DBService().db;
    final q = '''SELECT date FROM [Events] WHERE [event] = 'water' AND [id] = ?1;''';
    final List<Map<String, dynamic>> map = await db.rawQuery(q, [sampleId]);
    List<DateTime> dateTimes = map.map((e) {
      String? dateStr = e['date'] as String?;
      return dateStr != null ? DateTime.parse(dateStr) : DateTime.now();
    }).toList();
    return dateTimes;
  }

  Future<bool?> _addEvent(Event event) async {
    eventDate.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: Form(
          //key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: padAll8,
                child: Text('Date',),
              ),
              Padding(
                padding: padAll8,
                child: TextField(
                  controller: eventDate,
                  decoration: const InputDecoration(icon: Icon(Icons.calendar_today),),
                  readOnly: true,
                  onTap: () async {
                    // This prevents the main page from rebuilding when just the date in the dialog changes.
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.tryParse(eventDate.text) ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2050))
                    .then((pickedDate) {
                      if (pickedDate != null) {
                        (context as Element).markNeedsBuild();
                        eventDate.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                      }
                    });
                  },
                )
              ),
              Padding(
                padding: padAll8,
                child: ElevatedButton(
                  child: const Text('Save',),
                  onPressed: () async {
                    final db = await DBService().db;
                    await db.rawInsert(event.qInsert(), [widget.id, event.id_, eventDate.text]);
                    if (!context.mounted) return;
                    Navigator.of(context).pop(true);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _potMap(SampleDetails sample) {
    return {
      'material': sample.material,
      'shape': sample.shape,
      'size': sample.size,
      'deep': sample.deep,
    };
  }

  List<Center> _createSoilGrid(Soil? soil) {
    if (soil == null) {
      return <Center>[const Center(child: Text('N/A'),),];
    } else {
      final List soilComponents = soil.getSortedSoilComponents();

      return List.generate(soilComponents.length, (index) {
        return Center(
          child: createKeyValueItem(
            '${Soil.mapComponentsNames(soilComponents[index].key)}: ',
            soilComponents[index].value.toString(),
            textAlign: TextAlign.left
          ),
        );
      });
    }
  }

  Future<num> _calculateWateringFrequency(int sampleId) async {
    final db = await DBService().db;
    const query = '''
      SELECT 
        MAX([date]) AS max_date, 
        MIN([date]) AS min_date,
        COUNT(*) AS count
      FROM [Events]
      WHERE [id] = ?1 AND [event] = 'water';
    ''';
    final result = await db.rawQuery(query, [sampleId]);

    if (result.isNotEmpty && result.first['max_date'] != null && result.first['min_date'] != null) {
      final maxDate = DateTime.parse(result.first['max_date'] as String);
      final minDate = DateTime.parse(result.first['min_date'] as String);
      final count = result.first['count'] as int;
      return maxDate.difference(minDate).inDays / (count - 1);
    }

    return 0.0; // Return 0 if no data or only one entry
  }

  Future<SamplePageData> _fetchPageData(int sampleId) async {
    // Fetch all data in parallel for better performance
    final results = await Future.wait([
      fetchSampleData(sampleId),
      _fetchWateringDates(sampleId),
      _calculateWateringFrequency(sampleId),
    ]);

    final sample = results[0] as SampleDetails;
    final wateringDates = results[1] as List<DateTime>;
    final wateringFrequency = results[2] as double;

    Soil? soil;
    if (sample.soil != null) {
      soil = await fetchSoil(sample.soil!);
    }

    return SamplePageData(
      sampleDetails: sample,
      soil: soil,
      wateringDates: wateringDates,
      wateringFrequency: wateringFrequency,
    );
  }

}
