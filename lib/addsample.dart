import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:sukke/objects/potobj.dart';
import 'package:sukke/objects/plantobj.dart';
import 'package:sukke/objects/sampleobj.dart';
import 'package:sukke/theme/elements.dart';
import 'package:sukke/theme/theme.dart';

class SampleAddPage extends StatefulWidget {
  const SampleAddPage({super.key});

  @override
  _SampleAddPage createState() => _SampleAddPage();
}

class _SampleAddPage extends State<SampleAddPage> {
  Future<List<DropdownItem<String>>> plants = generatePlantsList();
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
        title: Text(
          'Nuovo Esemplare',
          style: textTheme.titleLarge,
        ),
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
                    duration: errorDuration,
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
                    duration: errorDuration,
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
      Text(
        'Pianta',
        textAlign: TextAlign.center,
        style: textTheme.titleSmall,
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
      dividerGray20,
      box5,
      Text(
        'Campione',
        textAlign: TextAlign.center,
        style: textTheme.titleSmall,
      ),
      box10,
      Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Born',
              style: textTheme.bodyMedium,
            ),
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
                  borderRadius: borderR12,
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
          Expanded(
            flex: 1,
            child: Text(
              'Bought',
              style: textTheme.bodyMedium,
            ),
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
          Expanded(
            flex: 1,
            child: Text(
              'From seed',
              style: textTheme.bodyMedium,
            ),
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
          Expanded(
            flex: 1,
            child: Text(
              'From cutting',
              style: textTheme.bodyMedium,
            ),
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
          Expanded(
            flex: 1,
            child: Text(
              'Crested',
              style: textTheme.bodyMedium,
            ),
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
          Expanded(
            flex: 1,
            child: Text(
              'Variegated',
              style: textTheme.bodyMedium,
            ),
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
          Expanded(
            flex: 1,
            child: Text(
              'Grafted',
              style: textTheme.bodyMedium,
            ),
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
          Expanded(
            flex: 1,
            child: Text(
              'Monstrous',
              style: textTheme.bodyMedium,
            ),
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
      dividerGray20,
      box5,
      Text(
        'Vaso',
        textAlign: TextAlign.center,
        style: textTheme.titleSmall,
      ),
      box10,
      Text(
        'Materiale',
        textAlign: TextAlign.center,
        style: textTheme.bodyLarge,
      ),
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
      Text(
        'Forma',
        textAlign: TextAlign.center,
        style: textTheme.bodyLarge,
      ),
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
          Expanded(
            flex: 2,
            child: Text(
              'Size',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
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
          Expanded(
            flex: 2,
            child: Text(
              'Deep',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
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
      box10,
    ];

    return ListView(
      padding: padLR16,
      children: l,
    );
  }

  static Future<List<DropdownItem<String>>> generatePlantsList() async {
    List<PlantListItem> plantsList = await fetchPlantList();
    return plantsList.map<DropdownItem<String>>(
            (c) => DropdownItem<String>(label: c.name.toString(), value: c.id.toString())
    ).toList();
  }
}
