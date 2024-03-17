import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukke/db.dart';
import 'package:sukke/objects/sampleobj.dart';
import 'package:sukke/plantpage.dart';
import 'package:sukke/poteditpage.dart';
import 'package:sukke/objects/events.dart';
import 'package:intl/intl.dart';
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
  TextStyle keywordStyle = const TextStyle(fontStyle: FontStyle.italic,);
  late Soil? soil = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Sample #${widget.id.toString()}',),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () {
              showDialog<bool>(
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
              ).then( (deleted) {
                if (deleted == true) {
                  Navigator.pop(context);
                }
              });
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<SampleDetails>(
          future: fetchSampleData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Future creation error'); // error
              } else if (snapshot.hasData) {
                return sampleDetailsPage(snapshot.data);
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

  Widget sampleDetailsPage(SampleDetails? data) {
    return CupertinoScrollbar(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const SizedBox(height: 5),
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
              '${data?.species ?? data?.commonName} ${data?.variant}',
              textAlign: TextAlign.center,
              softWrap: true,
              style: const TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Informazioni',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.indigo,
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
                      updateSample(newFields);
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Born: ',
                          style: keywordStyle,
                        ),
                        TextSpan(text: data!.born.toString(),),
                      ]
                    )
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Bought: ',
                          style: keywordStyle,
                        ),
                        TextSpan(text: data.bought ? "Yes" : "No",),
                      ]
                    )
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'From seed: ',
                          style: keywordStyle,
                        ),
                        TextSpan(text: data.fromSeed ? "Yes" : "No",),
                      ]
                    )
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'From cutting: ',
                          style: keywordStyle,
                        ),
                        TextSpan(text: data.fromCutting ? "Yes" : "No",),
                      ]
                    )
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Location: ',
                          style: keywordStyle,
                        ),
                        TextSpan(text: data.location,),
                      ]
                    )
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(
                              text: 'Crested: ',
                              style: keywordStyle,
                            ),
                            TextSpan(text: data.crested ? "Yes" : "No",),
                          ]
                      )
                  ),
                  Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(
                              text: 'Variegated: ',
                              style: keywordStyle,
                            ),
                            TextSpan(text: data.variegated ? "Yes" : "No",),
                          ]
                      )
                  ),
                  Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(
                              text: 'Grafted: ',
                              style: keywordStyle,
                            ),
                            TextSpan(text: data.grafted ? "Yes" : "No",),
                          ]
                      )
                  ),
                  Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(
                              text: 'Monstrous: ',
                              style: keywordStyle,
                            ),
                            TextSpan(text: data.monstrous ? "Yes" : "No",),
                          ]
                      )
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black45),
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(8),),
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
                        if (data.TMin == null) const Text(' -')
                        else Text(' ${data.TMin.toString()} °C')
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
                          color: Colors.blue,
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
          /*const Divider(
            height: 20,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Colors.black45,
          ),*/
          const SizedBox(height: 20),
          const Text(
            'Coltivazione',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: TextButton(
                onPressed: () {
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
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.square_outlined,
                      color: Colors.black38,
                    ),
                    Text(
                      ' Vaso',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),),
              Expanded(
                flex:3,
                child: Column(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Materiale: ',
                          style: keywordStyle,
                        ),
                        TextSpan(text: data.material.label,),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Forma: ',
                          style: keywordStyle,
                        ),
                        TextSpan(text: data.shape.label,),
                      ],
                    ),
                  ),
                ],
              ),
              ),
              Expanded(
                flex:2,
                child: Column(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Size: ',
                          style: keywordStyle,
                        ),
                        TextSpan(text: data.size.toString(),),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Deep: ',
                          style: keywordStyle,
                        ),
                        TextSpan(text: data.deep ? "Yes" : "No",),
                      ],
                    ),
                  ),
                ],
              ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () {
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
                        updateSoil(newSoil);
                      }
                    });
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bubble_chart,
                        color: Colors.brown,
                      ),
                      Text(
                        ' Suolo',
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              ),
              Expanded(
                flex: 2,
                child:  GridView.count(
                  // crossAxisCount is the number of columns
                  crossAxisCount: 2,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  childAspectRatio: 5,
                  // This creates two columns with two items in each column
                  children: createSoilGrid(),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Row(
              children: [
                const Text(
                  'Note',
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.black45,
                    size: 15,
                  ),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TextEditPage(title: 'Note', text: data.notes ?? "-")),
                    ).then( (newText) async {
                      updateTextField(newText);
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Text(data.notes ?? "-",),
          ),
          const SizedBox(height: 20),
          const Text(
            'Eventi',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<SampleDetails> fetchSampleData() async {
    final db = await DBService().db;

    final map = await db.rawQuery(SampleDetails.selectQuery, [widget.id]);
    final SampleDetails sample = SampleDetails.fromMap(map[0]);

    if (sample.soil != null) {
      final mapSoil = await db.rawQuery(Soil.selectQuery, [sample.soil]);
      soil = Soil.fromMap(mapSoil[0]);
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
                padding: EdgeInsets.all(8),
                child: Text('Date',),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
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
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                child: const Text('Save',),
                  onPressed: () async {
                    final db = await DBService().db;
                    await db.rawInsert(event.qInsert(), [widget.id, eventDate.text]);
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

  Future<Null> updateSample(Map<String, dynamic> newFields) async {
    String query = '''
    UPDATE [Sample] SET
    [born] = ?1, [bought] = ?2, [fromSeed] = ?3, [fromCutting] = ?4
    [crested] = ?5, [variegated] = ?6, [grafted] = ?7, [monstrous] = ?8,
    [location] = ?9
    WHERE [id] = ?10;
    ''';
    final List arguments = [
      newFields['born'] as int,
      newFields['bought'] ? 1 : 0,
      newFields['fromSeed'] ? 1 : 0,
      newFields['fromCutting'] ? 1 : 0,
      newFields['crested'] ? 1 : 0,
      newFields['variegated'] ? 1 : 0,
      newFields['grafted'] ? 1 : 0,
      newFields['monstrous'] ? 1 : 0,
      newFields['location'] as String,
      widget.id
    ];
    final db = await DBService().db;
    await db.rawUpdate(query, arguments);
    setState(() {});
  }

  static Map<String, dynamic> potMap(SampleDetails sample) {
    return {
      'material': sample.material,
      'shape': sample.shape,
      'size': sample.size,
      'deep': sample.deep,
    };
  }

  Future<Null> updateSoil(int soilId) async {
    String query = 'UPDATE [Sample] SET [soil] = ?1 WHERE [id] = ?2;';

    final db = await DBService().db;
    await db.rawUpdate(query, [soilId, widget.id]);
    setState(() {});
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

  Future<int> getNewPotId(Map<String, dynamic> newFields) async {
    // Take the ID of the new pot. If null it does not exists
    final db = await DBService().db;
    int newId;

    String idQuery = '''
    SELECT [id] FROM [Pot] WHERE
      [material] = ?1 AND [shape] = ?2 AND
      [deep] = ?3 AND [size] = ?4;
    ''';
    final mapId = await db.rawQuery(
        idQuery,
        [
          newFields['material'].value, newFields['shape'].value,
          newFields['deep'] ? 1 : 0, newFields['size']
        ]
    );

    // If no existing pot corresponds
    if (mapId.isEmpty) {
      // Get the MAX(id)
      String maxIdQuery = '''SELECT MAX([id]) AS id FROM [Pot];''';
      final maxId = await db.rawQuery(maxIdQuery);
      newId = maxId[0]['id'] as int;
      // Add 1 to the ID and save the new pot in Pot
      newId += 1;

      // Save the new pot
      String newPotQuery = '''
      INSERT INTO [Pot] ([id], [material], [shape], [deep], [size])
      VALUES (?1, ?2, ?3, ?4, ?5);
      ''';
      await db.rawInsert(
          newPotQuery,
          [
            newId, newFields['material'].value, newFields['shape'].value,
            newFields['deep'] ? 1 : 0, newFields['size']
          ]
      );

    } else {
      newId = mapId[0]['id'] as int;
    }

    // Return the pot ID to update the Sample table
    return newId;
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

  Future<Null> deleteSample(int id) async {
    final db = await DBService().db;

    await db.rawDelete('DELETE FROM [Events] WHERE [id] = ?1;', [id]);
    await db.rawDelete('DELETE FROM [Sample] WHERE [id] = ?1;', [id]);
  }

  Future<Null> updateTextField(String? text) async {
    final db = await DBService().db;
    const query = 'UPDATE [Sample] SET [notes] = ?1 WHERE [id] = ?2';
    await db.rawUpdate(query, [text, widget.id]);
    setState(() {});
  }
}
