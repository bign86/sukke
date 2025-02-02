import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:sukke/db.dart';
import 'package:sukke/objects/potobj.dart';
import 'package:sukke/objects/plantobj.dart';
import 'package:sukke/theme/elements.dart';
import 'package:sukke/theme/theme.dart';

class SampleAddPage extends StatefulWidget {
  const SampleAddPage({super.key});

  @override
  _SampleAddPage createState() => _SampleAddPage();
}

class _SampleAddPage extends State<SampleAddPage> {
  Future<List<DropdownItem<String>>> plants = fetchPlants();
  Map<String, dynamic> controllers = {};
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    populateControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text('New Sample',),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              if (
                controllers['material'] == null ||
                controllers['shape'] == null
              ) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.red[700],
                    content: const Text('Il vaso DEVE essere inizializzato!'),
                  )
                );
              } else if (
                controllers['plant'] == null ||
                controllers['plant'].isEmpty
              ) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.red[700],
                    content: const Text('Non hai selezionato alcuna pianta!'),
                  )
                );
              } else {
                newSampleToDB(controllers);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: CupertinoScrollbar(
        child: Center(
          child: Form(
            key: _formKey,
            child: FutureBuilder(
              future: plants,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return formsList(snapshot.data!);
                } else {
                  return const Text("No data available");
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void populateControllers() {
    // Boolean controllers
    controllers['bought'] = false;
    controllers['fromSeed'] = false;
    controllers['fromCutting'] = false;
    controllers['crested'] = false;
    controllers['variegated'] = false;
    controllers['grafted'] = false;
    controllers['monstrous'] = false;
    controllers['deep'] = false;

    // Multiple choice controllers
    controllers['material'] = PotMaterial.toList[0];
    controllers['shape'] = PotShape.toList[0];

    // List controllers
    controllers['plant'] = null;

    // Numeric controllers
    controllers['born'] = DateTime.now().year;
    controllers['size'] = 1;
  }

  ListView formsList(List<DropdownItem<String>> plants) {
    List<Widget> l = <Widget>[
      box10,
      const Center(
        child: Text(
          'Plant',
          style: TextStyle(
            color: Colors.black38,
            fontSize: 18,
          ),
        ),
      ),
      box10,
      Center(
        child: MultiDropdown(
          items: plants,
          controller: MultiSelectController<String>(), //controllers['plantControl'],
          singleSelect: true,
          validator: (option) {
            if (option == null || option.isEmpty) {
              return 'Select a plant';
            }
            return null;
          },
          onSelectionChange: (options) {
            controllers['plant'] = options;
          },
          dropdownDecoration: DropdownDecoration(
            marginTop: 2,
            maxHeight: 300,
            header: Padding(
              padding: padAll8,
              child: Text(
                'Select a plant from the list',
                textAlign: TextAlign.start,
                style: textTheme.bodyMedium,
              ),
            ),
          ),
          dropdownItemDecoration: const DropdownItemDecoration(
            selectedIcon: Icon(Icons.check_circle),
          ),
          chipDecoration: const ChipDecoration(
            backgroundColor: Colors.white,
            wrap: true,
            runSpacing: 2,
            spacing: 5,
          ),
        ),
      ),
      box5,
      const Center(
        child: Text(
          'Campione',
          style: TextStyle(
            color: Colors.black38,
            fontSize: 18,
          ),
        ),
      ),
      box10,
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Born',),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: NumberPicker(
                value: controllers['born'],
                minValue: 1990,
                maxValue: 2040,
                step: 1,
                axis: Axis.horizontal,
                itemHeight: 30,
                itemWidth: 70,
                haptics: true,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black26),
                ),
                onChanged: (value) => setState(() {
                  controllers['born'] = value;
                }),
              ),
            ),
          ),
        ],
      ),
      box5,
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Bought',),
          ),
          Expanded(
            flex: 3,
            child: Switch(
              value: controllers['bought'],
              activeColor: Colors.indigo[200],
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {
                  controllers['bought'] = value;
                });
              },
            ),
          ),
        ],
      ),
      box5,
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('From seed',),
          ),
          Expanded(
            flex: 3,
            child: Switch(
              value: controllers['fromSeed'],
              activeColor: Colors.indigo[200],
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {
                  controllers['fromSeed'] = value;
                });
              },
            ),
          ),
        ],
      ),
      box5,
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('From cutting',),
          ),
          Expanded(
            flex: 3,
            child: Switch(
              value: controllers['fromCutting'],
              activeColor: Colors.indigo[200],
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {
                  controllers['fromCutting'] = value;
                });
              },
            ),
          ),
        ],
      ),
      box5,
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Crested',),
          ),
          Expanded(
            flex: 3,
            child: Switch(
              value: controllers['crested'],
              activeColor: Colors.indigo[200],
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {
                  controllers['crested'] = value;
                });
              },
            ),
          ),
        ],
      ),
      box5,
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Variegated',),
          ),
          Expanded(
            flex: 3,
            child: Switch(
              value: controllers['variegated'],
              activeColor: Colors.indigo[200],
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {
                  controllers['variegated'] = value;
                });
              },
            ),
          ),
        ],
      ),
      box5,
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Grafted',),
          ),
          Expanded(
            flex: 3,
            child: Switch(
              value: controllers['grafted'],
              activeColor: Colors.indigo[200],
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {
                  controllers['grafted'] = value;
                });
              },
            ),
          ),
        ],
      ),
      box5,
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Monstrous',),
          ),
          Expanded(
            flex: 3,
            child: Switch(
              value: controllers['monstrous'],
              activeColor: Colors.indigo[200],
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {
                  controllers['monstrous'] = value;
                });
              },
            ),
          ),
        ],
      ),
      box5,
      const Divider(
        height: 30,
        thickness: 1,
        indent: 20,
        endIndent: 20,
        color: Colors.black45,
      ),
      box5,
      const Center(
        child: Text(
          'Vaso',
          style: TextStyle(
            color: Colors.black38,
            fontSize: 18,
          ),
        ),
      ),
      box10,
      Center(child: Text('Materiale',),),
      box5,
      Center(
        child: SegmentedButton<PotMaterial>(
          segments: PotMaterial.values.map(
                  (material) => ButtonSegment<PotMaterial>(
                value: material,
                label: Text(material.label),
              )
          ).toList(),
          selected: <PotMaterial>{controllers['material']},
          multiSelectionEnabled: false,
          onSelectionChanged: (Set<PotMaterial> newSelection) {
            setState(() {
              controllers['material'] = newSelection.first;
            });
          },
        ),
      ),
      box5,
      Center(child: Text('Forma',),),
      box5,
      Center(
        child: SegmentedButton<PotShape>(
          segments: PotShape.values.map(
                  (shape) => ButtonSegment<PotShape>(
                value: shape,
                label: Text(shape.label),
              )
          ).toList(),
          selected: <PotShape>{controllers['shape']},
          multiSelectionEnabled: false,
          onSelectionChanged: (Set<PotShape> newSelection) {
            setState(() {
              controllers['shape'] = newSelection.first;
            });
          },
        ),
      ),
      box5,
      Row(
        children: [
          const Expanded(
            flex: 2,
            child: Center(child: Text('Size',),),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: NumberPicker(
                value: controllers['size'],
                minValue: 1,
                maxValue: 50,
                step: 1,
                axis: Axis.horizontal,
                itemHeight: 30,
                itemWidth: 30,
                haptics: true,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black26),
                ),
                onChanged: (value) => setState(() {
                  controllers['size'] = value;
                }),
              ),
            ),
          ),
        ],
      ),
      box5,
      Row(
        children: [
          const Expanded(
            flex: 2,
            child: Center(child: Text('Deep',),),
          ),
          Expanded(
            flex: 3,
            child: Switch(
              value: controllers['deep'],
              activeColor: Colors.indigo[200],
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {
                  controllers['deep'] = value;
                });
              },
            ),
          ),
        ],
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      children: l,
    );
  }

  static Future<List<DropdownItem<String>>> fetchPlants() async {
    final db = await DBService().db;
    final res = await db.rawQuery("SELECT [id], COALESCE([species], [commonName])||' '||COALESCE([variant], '') AS [name] FROM [Plant] ORDER BY [name];");

    List<PlantListItem> plantsList = res.map((e) => PlantListItem.fromMap(e)).toList();
    return plantsList.map<DropdownItem<String>>(
            (c) => DropdownItem<String>(label: c.name.toString(), value: c.id.toString())
    ).toList();
  }

  Future<Null> newSampleToDB(Map<String, dynamic> newFields) async {
    // Extract the info for the pot
    Map<String, dynamic> potData = {
      'material': newFields['material'],
      'shape': newFields['shape'],
      'deep': newFields['deep'],
      'size': newFields['size']
    };
    final int potId = await getNewPotId(potData);
    final int sampleId = await getMaxId('maxIdSample') + 1;

    final db = await DBService().db;

    // Add the new sample to the DB
    String newSampleQuery = '''
    INSERT INTO [Sample]
    ([id], [plant], [pot], [born], [crested], [variegated],
    [grafted], [monstrous], [bought], [fromSeed], [fromCutting])
    VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11);
    ''';
    final List<dynamic> arguments = <dynamic>[
      sampleId, newFields['plant'][0], potId, newFields['born'],
      newFields['crested'], newFields['variegated'], newFields['grafted'],
      newFields['monstrous'], newFields['bought'], newFields['fromSeed'],
      newFields['fromCutting']
    ];
    await db.rawInsert(newSampleQuery, arguments);

    // Update the max id of samples
    String maxIdQuery = '''
    UPDATE [System] SET [valueNum] = ?1
    WHERE [key] = 'maxIdSample';
    ''';
    await db.rawUpdate(maxIdQuery, [sampleId]);
  }
}