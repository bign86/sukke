import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:sukke/db.dart';
import 'package:sukke/objects/plantobj.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sukke/texteditpage.dart';
import 'package:sukke/plantAnagraphicEditPage.dart';
import 'package:sukke/plantlinkseditpage.dart';


class PlantMainPage extends StatefulWidget {
  const PlantMainPage({super.key, required this.id});

  final int id;

  @override
  State<PlantMainPage> createState() => _PlantMainPageState();
}

class _PlantMainPageState extends State<PlantMainPage> {
  static const List<String> anagraphicalKeys = <String>[
    'family', 'genus', 'species', 'variant', 'synonyms',
    'countries', 'cultivar', 'commonName', 'growthRate',
    'dormantSeason', 'TMin', 'wateringNeeds', 'lightNeeds'
  ];
  TextStyle keywordStyle = const TextStyle(fontStyle: FontStyle.italic,);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Plant #${widget.id.toString()}',),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () {
              showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Attenzione!'),
                  content: const Text('Vuoi davvero cancellare questa pianta?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('Annulla')
                    ),
                    ElevatedButton(
                        onPressed: () {
                          deletePlant(widget.id);
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
        child: FutureBuilder<Plant>(
          future: fetchPlantData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Future creation error'); // error
              } else if (snapshot.hasData) {
                return plantDetailsPage(snapshot.data);
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

  Future<Plant> fetchPlantData() async {
    final db = await DBService().db;
    final map = await db.rawQuery(Plant.selectQuery, [widget.id]);
    return Plant.fromMap(map[0]);
  }

  Widget plantDetailsPage(Plant? data) {
    return CupertinoScrollbar(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 20),
        children: [
          const SizedBox(height: 5),
          Text(
            '${data?.species ??
                data?.commonName} ${data?.variant ?? ""}',
            textAlign: TextAlign.center,
            softWrap: true,
            style: const TextStyle(
              color: Colors.black45,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Anagrafica',
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
                        builder: (context) => PlantAnagraphicEditPage(
                            fieldsMap: anagraphicalMap(data!),
                        )
                    ),
                  ).then( <Map>(newFields) async {
                    if (newFields != null) {
                      if (newFields.isNotEmpty) {
                        updateAnagraphical(newFields);
                      }
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
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Family: ',
                            style: keywordStyle,
                          ),
                          TextSpan(text: data!.family,),
                        ]
                      )
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Genus: ',
                            style: keywordStyle,
                          ),
                          TextSpan(text: data.genus,),
                        ]
                      )
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Specie: ',
                            style: keywordStyle,
                          ),
                          TextSpan(text: data.species,),
                        ]
                      )
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Variant: ',
                            style: keywordStyle,
                          ),
                          TextSpan(text: data.variant,),
                        ]
                      )
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Sinonimi: ',
                            style: keywordStyle,
                          ),
                          TextSpan(text: data.synonyms.join(', '),),
                        ]
                      )
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                        TextSpan(
                            children: [
                              TextSpan(
                                text: 'Paesi: ',
                                style: keywordStyle,
                              ),
                              TextSpan(text: data.countries.join(', '),),
                            ]
                        )
                    ),
                    Text.rich(
                        TextSpan(
                            children: [
                              TextSpan(
                                text: 'Cultivar: ',
                                style: keywordStyle,
                              ),
                              TextSpan(text: data.cultivar ? "Yes" : "No",),
                            ]
                        )
                    ),
                    Text.rich(
                        TextSpan(
                            children: [
                              TextSpan(
                                text: 'Common names: ',
                                style: keywordStyle,
                              ),
                              TextSpan(text: data.commonName ?? "",),
                            ]
                        )
                    ),
                    Text.rich(
                        TextSpan(
                            children: [
                              TextSpan(
                                text: 'Growing speed: ',
                                style: keywordStyle,
                              ),
                              TextSpan(text: data.growthRate.label),
                            ]
                        )
                    ),
                    Text.rich(
                        TextSpan(
                            children: [
                              TextSpan(
                                text: 'Dormant Season: ',
                                style: keywordStyle,
                              ),
                              TextSpan(text: data.dormantSeason.label,),
                            ]
                        )
                    ),
                  ],
                ),
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
            height: 30,
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
            children: [
              const Text(
                'Habitat',
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
                        builder: (context) => TextEditPage(title: 'Habitat', text: data.habitat ?? "-")),
                  ).then( (newText) async {
                    updateTextField(data, 'habitat', newText);
                  });
                },
              ),
            ],
          ),
          Text(
            data.habitat ?? "-",
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text(
                'Altitudine',
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
                        builder: (context) => TextEditPage(title: 'Altitude', text: data.altitude ?? "-")),
                  ).then( (newText) async {
                    updateTextField(data, 'altitude', newText);
                  });
                },
              ),
            ],
          ),
          Text(
            data.altitude ?? "-",
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text(
                'Note di coltivazione',
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
                        builder: (context) => TextEditPage(title: 'Note di coltivazione', text: data.cultivation ?? "-")),
                  ).then( (newText) async {
                    updateTextField(data, 'cultivation', newText);
                  });
                },
              ),
            ],
          ),
          Text(
            data.cultivation ?? "-",
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text(
                'Esposizione',
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
                        builder: (context) => TextEditPage(title: 'Esposizione', text: data.light ?? "-")),
                  ).then( (newText) async {
                    updateTextField(data, 'light', newText);
                  });
                },
              ),
            ],
          ),
          Text(
            data.light ?? "-",
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text(
                'Innaffiature',
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
                        builder: (context) => TextEditPage(title: 'Innaffiature', text: data.wateringNotes ?? "-")),
                  ).then( (newText) async {
                    updateTextField(data, 'wateringNotes', newText);
                  });
                },
              ),
            ],
          ),
          Text(
            data.wateringNotes ?? "-",
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text(
                'Propagazione',
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
                        builder: (context) => TextEditPage(title: 'Propagazione', text: data.propagation ?? "-")),
                  ).then( (newText) async {
                    updateTextField(data, 'propagation', newText);
                  });
                },
              ),
            ],
          ),
          Text(
            data.propagation ?? "-",
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 5),
          Row(
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
                    updateTextField(data, 'notes', newText);
                  });
                },
              ),
            ],
          ),
          Text(
            data.notes ?? "-",
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text(
                'Links',
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlantLinksEditPage(links: data.links)
                    ),
                  ).then( (newLinks) async {
                    if (newLinks != null) {
                      updateLinks(newLinks);
                    }
                  });
                },
              ),
            ],
          ),
          ListView.builder(
            //padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: data.links.length,
            itemBuilder: (BuildContext context, int index) {
              return Linkify(
                onOpen: (link) async {
                  if (!await launchUrl(Uri.parse(data.links[index]))) {
                    throw Exception('Could not launch ${data.links[index]}');
                  }
                },
                text: "\u2022 ${data.links[index]}",
              );
            }
          ),
        ],
      ),
    );
  }

  Future<Null> updateTextField(Plant plant, String column, String? text) async {
    final db = await DBService().db;
    final query = plant.updateQuery(column);
    await db.rawUpdate(query, [text, widget.id]);
    setState(() {});
  }

  Map<String, dynamic> anagraphicalMap(Plant plant) {
    Map<String, dynamic> map = {};
    for (var key in anagraphicalKeys) {
      map[key] = plant.get(key);
    }
    return map;
  }

  Future<Null> updateAnagraphical(Map<String, dynamic> newFields) async {
    String query = 'UPDATE [Plant] SET ';
    List<String> setField = <String>[];
    List arguments = [];

    if (newFields.containsKey('family')) {
      setField.add('[family] = "${newFields['family']}"');
    }
    if (newFields.containsKey('genus')) {
      setField.add('[genus] = "${newFields['genus']}"');
    }
    if (newFields.containsKey('species')) {
      setField.add('[species] = "${newFields['species']}"');
    }
    if (newFields.containsKey('variant')) {
      setField.add('[variant] = "${newFields['variant']}"');
    }
    if (newFields.containsKey('synonyms')) {
      arguments.add(jsonEncode(newFields['synonyms']));
      final int pos = arguments.length;
      setField.add('[synonyms] = ?$pos');
    }
    if (newFields.containsKey('countries')) {
      List<String> countries = newFields['countries']
        .map<String>((DropdownItem c) => c.label.toString())
        .toList();
      arguments.add(jsonEncode(countries));
      final int pos = arguments.length;
      setField.add('[countries] = ?$pos');
    }
    if (newFields.containsKey('cultivar')) {
      setField.add('[cultivar] = ${newFields['cultivar'] ? 1 : 0}');
    }
    if (newFields.containsKey('commonName')) {
      setField.add('[commonName] = "${newFields['commonName']}"');
    }
    if (newFields.containsKey('growthRate')) {
      setField.add('[growthRate] = ${newFields['growthRate'].value}');
    }
    if (newFields.containsKey('dormantSeason')) {
      setField.add('[dormantSeason] = ${newFields['dormantSeason'].value}');
    }
    if (newFields.containsKey('TMin')) {
      setField.add('[TMin] = ${newFields['TMin']}');
    }
    if (newFields.containsKey('wateringNeeds')) {
      setField.add('[wateringNeeds] = ${newFields['wateringNeeds'].value}');
    }
    if (newFields.containsKey('lightNeeds')) {
      setField.add('[lightNeeds] = ${newFields['lightNeeds'].value}');
    }

    query += setField.join(', ');

    arguments.add(widget.id);
    final int pos = arguments.length;
    query += ' WHERE [id] = ?$pos;';

    final db = await DBService().db;
    await db.rawUpdate(query, arguments);
    setState(() {});
  }

  Future<Null> updateLinks(List<String> newLinks) async {
    String query = 'UPDATE [Plant] SET [links] = ?1 WHERE [id] = ?2;';
    List arguments = [jsonEncode(newLinks), widget.id];

    final db = await DBService().db;
    await db.rawUpdate(query, arguments);
    setState(() {});
  }

  Future<Null> deletePlant(int id) async {
    final db = await DBService().db;

    final List<Map> specimens = await db.rawQuery('SELECT COUNT(*) AS count FROM [Sample] WHERE [plant] = ?1', [id]);
    final int count = specimens[0]['count'];
    if (count == 0) {
      await db.rawDelete('DELETE FROM [Plant] WHERE [id] = ?1;', [id]);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.red[700],
          content: Text('Ci sono $count campioni per questa pianta! Elimina quelli per primi.'),
        )
      );
    }
  }
}

