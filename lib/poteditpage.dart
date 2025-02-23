import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:sukke/objects/potobj.dart';
import 'package:sukke/theme/elements.dart';

class PotEditPage extends StatefulWidget {
  const PotEditPage({
    super.key, required this.fieldsMap   // fields
  });

  final Map<String, dynamic> fieldsMap;

  @override
  State<PotEditPage> createState() => _PotEditPageState();
}

class _PotEditPageState extends State<PotEditPage> {
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
        title: const Text('Edit - Vaso',),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              Navigator.of(context).pop(controllers);
            },
          ),
        ],
      ),
      body: CupertinoScrollbar(
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: padLR16,
              children: formsList(),
            ),
          ),
        ),
      ),
    );
  }

  void populateControllers() {
    // Boolean controllers
    controllers['deep'] = widget.fieldsMap['deep'] ?? false;

    controllers['material'] = widget.fieldsMap.containsKey('material') ?
      widget.fieldsMap['material'] :
      PotMaterial.toList[0];

    controllers['shape'] = widget.fieldsMap.containsKey('shape') ?
      widget.fieldsMap['shape'] :
      PotShape.toList[0];

    // Numeric controllers
    controllers['size'] = widget.fieldsMap['size'] ?? 1;
  }

  List<Widget> formsList() {
    return <Widget>[
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
      box10,
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
      box10,
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
      box10,
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
  }

}
