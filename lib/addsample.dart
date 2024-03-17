import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sukke/db.dart';
import 'package:sukke/objects/potobj.dart';
import 'package:sukke/objects/plantobj.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:numberpicker/numberpicker.dart';


class SampleAddPage extends StatefulWidget {
  const SampleAddPage({super.key});

  @override
  _SampleAddPage createState() => _SampleAddPage();
}

class _SampleAddPage extends State<SampleAddPage> {
  Future<List<ValueItem>> plants = fetchPlants();
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
              if (controllers['material'] == null || controllers['shape'] == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.red[700],
                    content: const Text('Il vaso DEVE essere inizializzato!'),
                  )
                );
              } else {
                var list = controllers['material'];
                for (int i = 0; i < list.length; i++) {
                  if (list[i] == true) {
                    controllers['material'] = PotMaterial.getSelection(i);
                  }
                }
                list = controllers['shape'];
                for (int i = 0; i < list.length; i++) {
                  if (list[i] == true) {
                    controllers['shape'] = PotShape.getSelection(i);
                  }
                }
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
    var controlsMat = List<bool>.filled(PotMaterial.len(), false);
    controllers['material'] = controlsMat;
    var controlsShp = List<bool>.filled(PotShape.len(), false);
    controllers['shape'] = controlsShp;

    // List controllers
    MultiSelectController controller = MultiSelectController();
    controllers['plantControl'] = controller;
    controllers['plant'] = null;

    // Numeric controllers
    controllers['born'] = DateTime.now().year as int;
    controllers['size'] = 1;
  }

  ListView formsList(List<ValueItem> plants) {
    const box = SizedBox(height: 5);
    const doubleBox = SizedBox(height: 10);
    List<Widget> l = <Widget>[
      doubleBox,
      const Center(
        child: Text(
          'Plant',
          style: TextStyle(
            color: Colors.black38,
            fontSize: 18,
          ),
        ),
      ),
      doubleBox,
      Center(
        child: MultiSelectDropDown(
          controller: controllers['plantControl'],
          onOptionSelected: (options) {
            controllers['plant'] = controllers['plantControl'].selectedOptions[0];
          },
          onOptionRemoved: (index, option) {
            controllers['plant'] = null;
          },
          options: plants,
          selectionType: SelectionType.single,
          chipConfig: const ChipConfig(wrapType: WrapType.wrap),
          dropdownHeight: 300,
          optionTextStyle: const TextStyle(fontSize: 12),
          selectedOptionIcon: const Icon(Icons.check_circle),
        ),
      ),
      box,
      const Center(
        child: Text(
          'Campione',
          style: TextStyle(
            color: Colors.black38,
            fontSize: 18,
          ),
        ),
      ),
      doubleBox,
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
      box,
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
      box,
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
      box,
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
      box,
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
      box,
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
      box,
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
      box,
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
      box,
      const Divider(
        height: 30,
        thickness: 1,
        indent: 20,
        endIndent: 20,
        color: Colors.black45,
      ),
      box,
      const Center(
        child: Text(
          'Vaso',
          style: TextStyle(
            color: Colors.black38,
            fontSize: 18,
          ),
        ),
      ),
      doubleBox,
      Row(
        children: [
          const Expanded(
            flex: 2,
            child: Center(child: Text('Materiale',),),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child:ToggleButtons(
                direction: Axis.horizontal,
                isSelected: controllers['material'],
                onPressed: (int index) {
                  setState(() {
                    var list = controllers['material'];
                    for (int i = 0; i < list.length; i++) {
                      list[i] = i == index;
                    }
                  });
                },
                children: PotMaterial.toList
                    .map((PotMaterial mat) => Text(mat.label))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      box,
      Row(
        children: [
          const Expanded(
            flex: 2,
            child: Center(child: Text('Forma',),),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: ToggleButtons(
                direction: Axis.horizontal,
                isSelected: controllers['shape'],
                onPressed: (int index) {
                  setState(() {
                    var list = controllers['shape'];
                    for (int i = 0; i < list.length; i++) {
                      list[i] = i == index;
                    }
                  });
                },
                children: PotShape.toList
                    .map((PotShape shape) => Text(shape.label))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      box,
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
      box,
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

  static Future<List<ValueItem>> fetchPlants() async {
    final db = await DBService().db;
    final res = await db.rawQuery('SELECT [id], COALESCE([species], [commonName])||" "||COALESCE([variant], "") AS [name] FROM [Plant] ORDER BY [name];');

    List<PlantListItem> plantsList = res.map((e) => PlantListItem.fromMap(e)).toList();
    return plantsList.map<ValueItem<String>>(
            (c) => ValueItem<String>(label: c.name.toString(), value: c.id.toString())
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

    final db = await DBService().db;
    final List<Map> res = await db.rawQuery('SELECT [valueNum] FROM [System] WHERE [key] = "maxIdSample";');
    final sampleId = (res[0]['valueNum'] as int) + 1;

    String newSampleQuery = '''
    INSERT INTO [Sample]
    ([id], [plant], [pot], [born], [crested], [variegated],
    [grafted], [monstrous], [bought], [fromSeed], [fromCutting])
    VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11);
    ''';
    final List<dynamic> arguments = <dynamic>[
      sampleId, newFields['plant'].value, potId, newFields['born'],
      newFields['crested'], newFields['variegated'], newFields['grafted'],
      newFields['monstrous'], newFields['bought'], newFields['fromSeed'],
      newFields['fromCutting']
    ];
    await db.rawInsert(newSampleQuery, arguments);

    String maxIdQuery = '''
    UPDATE [System] SET [valueNum] = ?1
    WHERE [key] = "maxIdSample";
    ''';
    await db.rawUpdate(maxIdQuery, [sampleId]);

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
      String maxIdQuery = '''SELECT [valueNum] FROM [System] WHERE [key] = "maxIdPot";''';
      final maxId = await db.rawQuery(maxIdQuery);
      newId = maxId[0]['valueNum'] as int;
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

      String maxIdPot = '''
      UPDATE [System] SET [valueNum] = ?1
      WHERE [key] = "maxIdPot";
      ''';
      await db.rawUpdate(maxIdPot, [newId]);
    } else {
      newId = mapId[0]['id'] as int;
    }

    // Return the pot ID to update the Sample table
    return newId;
  }
}