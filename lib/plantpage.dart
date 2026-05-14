import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sukke/db.dart';
import 'package:sukke/theme/elements.dart';
import 'package:sukke/theme/functions.dart';
import 'package:sukke/theme/theme.dart';
import 'package:sukke/objects/plantobj.dart';
import 'package:sukke/texteditpage.dart';
import 'package:sukke/plantEditPage.dart';
import 'package:sukke/plantlinkseditpage.dart';


class PlantMainPage extends StatefulWidget {
  const PlantMainPage({super.key, required this.id});

  final int id;

  @override
  State<PlantMainPage> createState() => _PlantMainPageState();
}

class _PlantMainPageState extends State<PlantMainPage> {
  late Future<Plant> _futurePlant;

  @override
  void initState() {
    super.initState();
    _futurePlant = fetchPlantData(widget.id);
  }

  void _refreshData() {
    setState(() {
      _futurePlant = fetchPlantData(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Plant #${widget.id.toString()}',
          style: textTheme.titleLarge,
        ),
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
                          _deletePlant(widget.id);
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
          future: _futurePlant,
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

  Widget plantDetailsPage(Plant? data) {
    return CupertinoScrollbar(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 20),
        children: [
          vBox5,
          Text(
            '${data?.species ?? data?.commonName} ${data?.variant ?? ""}',
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
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlantAnagraphicEditPage(
                        fieldsMap: anagraphicalMap(data!), plantId: widget.id
                      )
                    ),
                  );
                  _refreshData();
                },
              ),
            ],
          ),
          vBox5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    createKeyValueItem('Family: ', data!.family),
                    createKeyValueItem('Genus: ', data.genus),
                    createKeyValueItem('Specie: ', data.species ?? ""),
                    createKeyValueItem('Variant: ', data.variant ?? ""),
                    createKeyValueItem('Sinonimi: ', data.synonyms.join(', ')),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(''),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    createKeyValueItem('Paesi: ', data.countries.join(', ')),
                    createKeyValueItem('Cultivar: ', data.cultivar ? "Yes" : "No"),
                    createKeyValueItem('Common names: ', data.commonName ?? ""),
                    createKeyValueItem('Growing speed: ', data.growthRate.label),
                    createKeyValueItem('Dormant Season: ', data.dormantSeason.label),
                  ],
                ),
              ),
            ],
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
          vBox20,
          const Text(
            'Coltivazione',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          vBox5,
          _buildEditableRow(context, data, 'Habitat', 'habitat', data.habitat),
          _buildEditableRow(context, data, 'Altitudine', 'altitude', data.altitude),
          _buildEditableRow(context, data, 'Note di coltivazione', 'cultivation', data.cultivation),
          _buildEditableRow(context, data, 'Esposizione', 'light', data.light),
          _buildEditableRow(context, data, 'Innaffiature', 'wateringNotes', data.wateringNotes),
          _buildEditableRow(context, data, 'Propagazione', 'propagation', data.propagation),
          _buildEditableRow(context, data, 'Note', 'notes', data.notes),
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
                      await _updateLinks(newLinks);
                      if (!mounted) return;
                      _refreshData();
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

  Widget _buildEditableRow(BuildContext context, Plant data, String title, String fieldName, String? text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black45, size: 15),
              onPressed: () => _navigateToTextEditPage(context, data, title, fieldName, text),
            ),
          ],
        ),
        Text(text ?? "-", textAlign: TextAlign.left),
        vBox5,
      ],
    );
  }

  void _navigateToTextEditPage(BuildContext context, Plant data, String title, String fieldName, String? text) async {
    var newText = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TextEditPage(title: title, text: text ?? "")
      ),
    );
    newText = newText?.trim();

    if (newText != null) {
      await _updateTextField(data, fieldName, newText);
      if (!mounted) return;
      _refreshData();
    }
  }

  Future<Null> _updateTextField(Plant plant, String column, String? text) async {
    final db = await DBService().db;
    final query = plant.updateQuery(column);
    await db.rawUpdate(query, [text, widget.id]);
  }

  Map<String, dynamic> anagraphicalMap(Plant plant) {
    Map<String, dynamic> map = {};
    for (var key in newAnagraphicalMap.keys) {
      map[key] = plant.get(key);
    }
    return map;
  }

  Future<Null> _updateLinks(List<String> newLinks) async {
    String query = 'UPDATE [Plant] SET [links] = ?1 WHERE [id] = ?2;';
    List arguments = [jsonEncode(newLinks), widget.id];

    final db = await DBService().db;
    await db.rawUpdate(query, arguments);
  }

  Future<Null> _deletePlant(int id) async {
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

