import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sukke/db.dart';
import 'package:sukke/theme/elements.dart';
import 'package:sukke/theme/theme.dart';
import 'package:sukke/objects/sampleobj.dart';
import 'package:sukke/objects/potobj.dart';
import 'package:sukke/plantpage.dart';
import 'package:sukke/poteditpage.dart';
import 'package:sukke/objects/events.dart';
import 'package:sukke/sampleeditpage.dart';
import 'package:sukke/objects/soilobj.dart';
import 'package:sukke/sampleSoilEditPage.dart';
import 'package:sukke/texteditpage.dart';


class SampleMainPage extends StatefulWidget {
  const SampleMainPage({super.key, required this.id});

  final int id;

  @override
  State<SampleMainPage> createState() => _SampleMainPageState();
}

class _SampleMainPageState extends State<SampleMainPage> {
  TextEditingController eventDate = TextEditingController();
  TextStyle keywordStyle = TextStyle(
    fontSize: textTheme.bodyMedium?.fontSize,
    fontStyle: FontStyle.italic,
  );
  Soil? soil;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // title: Text('Sample #${widget.id.toString()}',),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () {
              showDialog<bool>(
                // Store a local reference to the context
                // as the async operation might occur after the widget is disposed
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Attenzione!'),
                  content: const Text('Vuoi davvero cancellare questo campione?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('Annulla')
                    ),
                    ElevatedButton(
                        onPressed: () {
                          deleteSample(widget.id);
                          Navigator.pop(context, true);
                        },
                        child: const Text('Cancella!')
                    ),
                  ],
                ),
              ).then((deleted) {
                // Check if the widget is still mounted before calling setState or Navigator.pop
                if (!context.mounted) return;
                if (deleted == true) {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                }
              });
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<SampleDetails>(
          future: fetchData(widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Future creation error'); // error
              } else if (snapshot.hasData) {
                return sampleDetailsPage(snapshot.data, widget.id);
              } else {
                return const Text("No data available");
              }
            } else {
              return const Text('Error'); // error
            }
          },
        ),
      ),
    );
  }

  Widget sampleDetailsPage(SampleDetails? data, int id) {
    return CupertinoScrollbar(
      child: ListView(
        padding: padAll10,
        children: [
          box5,
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PlantMainPage(id: data!.plant)),
              );
              setState(() {});
            },
            child: Text(
              '#$id - ${data?.species ?? data?.commonName} ${data?.variant}',
              textAlign: TextAlign.center,
              softWrap: true,
              style: textTheme.titleMedium,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Informazioni',
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium,
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: COLOR_PRIMARY,
                  size: 15,
                ),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SampleEditPage(data: data!)
                    ),
                  ).then(<Map>(newFields) async {
                    if (newFields != null) {
                      setState(() {
                        updateSample(widget.id, newFields);
                      });
                    }
                  });
                },
              ),
            ],
          ),
          box5,
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
                    TableCell(child: Text(data!.born.toString(), style: textTheme.bodyMedium,)),
                    TableCell(child: Text('Crested', style: keywordStyle,)),
                    TableCell(child: data.crested ? Icon(
                      Icons.check,
                      color: Colors.green,
                    ) : Icon(
                      Icons.close,
                      color: Colors.red,
                    ),),
                  ],
                ),
                TableRow(
                  children: <TableCell>[
                    TableCell(child: Text('Bought', style: keywordStyle,)),
                    TableCell(child: data.bought ? Icon(
                      Icons.check,
                      color: Colors.green,
                    ) : Icon(
                      Icons.close,
                      color: Colors.red,
                    ),),
                    TableCell(child: Text('Variegated', style: keywordStyle,)),
                    TableCell(child: data.variegated ? Icon(
                      Icons.check,
                      color: Colors.green,
                    ) : Icon(
                      Icons.close,
                      color: Colors.red,
                    ),),
                  ],
                ),
                TableRow(
                  children: <TableCell>[
                    TableCell(child: Text('From seed', style: keywordStyle,)),
                    TableCell(child: data.fromSeed ? Icon(
                      Icons.check,
                      color: Colors.green,
                    ) : Icon(
                      Icons.close,
                      color: Colors.red,
                    ),),
                    TableCell(child: Text('Grafted', style: keywordStyle,)),
                    TableCell(child: data.grafted ? Icon(
                      Icons.check,
                      color: Colors.green,
                    ) : Icon(
                      Icons.close,
                      color: Colors.red,
                    ),),
                  ],
                ),
                TableRow(
                  children: <TableCell>[
                    TableCell(child: Text('From cutting', style: keywordStyle,)),
                    TableCell(child: data.fromCutting ? Icon(
                      Icons.check,
                      color: Colors.green,
                    ) : Icon(
                      Icons.close,
                      color: Colors.red,
                    ),),
                    TableCell(child: Text('Monstrous', style: keywordStyle,)),
                    TableCell(child: data.monstrous ? Icon(
                      Icons.check,
                      color: Colors.green,
                    ) : Icon(
                      Icons.close,
                      color: Colors.red,
                    ),),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: padLR12,
            child: Row(
              children: <Text>[
                Text('Location: ', style: keywordStyle,),
                Text(data.location.toString(), style: textTheme.bodyMedium,),
              ],
            ),
          ),
          box10,
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
          box10,
          Padding(
            padding: padLR12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Note',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: COLOR_PRIMARY,
                    size: 15,
                  ),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TextEditPage(title: 'Note', text: data.notes ?? "-")),
                    ).then( (newText) async {
                      updateSampleNotes(widget.id, newText);
                      setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: padLR12,
            child: Text(data.notes ?? "-",),
          ),
          box10,
          Padding(
            padding: padLR12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Vaso',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: COLOR_PRIMARY,
                    size: 15,
                  ),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PotEditPage(fieldsMap: potMap(data)),
                      ),
                    ).then( (newPot) async {
                      if (newPot != null) {
                        updatePot(newPot);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          //box5,
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
                    TableCell(child: data.deep ? Icon(
                        Icons.check,
                        color: Colors.green,
                      ) : Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          box10,
          Padding(
            padding: padLR12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Terreno',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: COLOR_PRIMARY,
                    size: 15,
                  ),
                  onPressed: () async {
                    int? soilId;
                    if (soil != null) {
                      soilId = soil!.id;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SampleSoilEditPage(id: soilId),
                      ),
                    ).then( (newSoil) async {
                      if (newSoil != null) {
                        updateSampleSoil(widget.id, newSoil);
                        setState(() {});
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          GridView.count(
            // crossAxisCount is the number of columns
            crossAxisCount: 2,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            childAspectRatio: 5,
            // This creates two columns with two items in each column
            children: createSoilGrid(),
          ),
          box5,
          Text(
            'Eventi',
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium,
          ),
          box5,
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const Text(
                      'Innaffiato',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 14,
                      ),
                    ),
                    Text(' ${data.water ?? "-"}'),
                    Text('${data.waterDelta ?? "-"} gg'),
                    IconButton(
                      onPressed: () async {addEvent(Event.water);},
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Colors.grey[600],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const Text(
                      'Concimato',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 14,
                      ),
                    ),
                    Text(' ${data.fertilize ?? "-"}'),
                    Text('${data.fertilizeDelta ?? "-"} gg'),
                    IconButton(
                      onPressed: () async {addEvent(Event.fertilize);},
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Colors.grey[600],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const Text(
                      'Insetti',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 14,
                      ),
                    ),
                    Text(' ${data.pests ?? "-"}'),
                    Text('${data.pestsDelta ?? "-"} gg'),
                    IconButton(
                      onPressed: () async {addEvent(Event.pests);},
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Colors.grey[600],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const Text(
                      'Rinvaso',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 14,
                      ),
                    ),
                    Text(' ${data.repot ?? "-"}'),
                    Text('${data.repotDelta ?? "-"} gg'),
                    IconButton(
                      onPressed: () async {
                        addEvent(Event.repot);
                        },
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Colors.grey[600],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          box10,
        ],
      ),
    );
  }

  Future<SampleDetails> fetchData(int sampleId) async {
    final SampleDetails sample = await fetchSampleData(sampleId);
    if (sample.soil != null) {
      soil = await fetchSoil(sample.soil!);
    }
    return sample;
  }

  Future<Null> addEvent(Event event) async {
    eventDate.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    await showDialog<void>(
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
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2050),
                    );
                    if (pickedDate != null ) {
                      setState(() {
                        eventDate.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: padAll8,
                child: ElevatedButton(
                  child: const Text('Save',),
                  onPressed: () async {
                    final db = await DBService().db;
                    await db.rawInsert(event.qInsert(), [widget.id, event.id_, eventDate.text]);
                    setState(() {});
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> updatePot(Map<String, dynamic> newFields) async {
    // Get the new pot ID to update the Sample table
    final int id = await getNewPotId(newFields);

    // Update the sample table with the new pot
    String query = 'UPDATE [Sample] SET [pot] = ?1 WHERE [id] = ?2;';

    final db = await DBService().db;
    await db.rawUpdate(query, [id, widget.id]);
    setState(() {});
  }

  Map<String, dynamic> potMap(SampleDetails sample) {
    return {
      'material': sample.material,
      'shape': sample.shape,
      'size': sample.size,
      'deep': sample.deep,
    };
  }

  List<Center> createSoilGrid() {
    if (soil == null) {
      return <Center>[const Center(child: Text('N/A'),),];
    } else {
      final List soilComponents = soil!.getSortedSoilComponents();

      return List.generate(soilComponents.length, (index) {
        return Center(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${Soil.mapComponentsNames(
                      soilComponents[index].key)}: ',
                  style: keywordStyle,
                ),
                TextSpan(
                  text: soilComponents[index].value.toString(),
                ),
              ],
            ),
          ),
        );
      });
    }
  }
}
