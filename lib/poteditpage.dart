import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukke/objects/potobj.dart';
import 'package:numberpicker/numberpicker.dart';

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
              Map<String, dynamic> newFields = {
                'size': controllers['size'],
                'deep': controllers['deep'],
              };

              var list = controllers['material'];
              for (int i = 0; i < list.length; i++) {
                if (list[i] == true) {
                  newFields['material'] = PotMaterial.getSelection(i);
                }
              }
              list = controllers['shape'];
              for (int i = 0; i < list.length; i++) {
                if (list[i] == true) {
                  newFields['shape'] = PotShape.getSelection(i);
                }
              }

              Navigator.of(context).pop(newFields);
            },
          ),
        ],
      ),
      body: CupertinoScrollbar(
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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

    // Multiple choice controllers
    var controlsMat = List<bool>.filled(PotMaterial.len(), false);
    if (widget.fieldsMap.containsKey('material')) {
      controlsMat[widget.fieldsMap['material'].value - 1] = true;
    }
    controllers['material'] = controlsMat;
    var controlsShp = List<bool>.filled(PotShape.len(), false);
    if (widget.fieldsMap.containsKey('shape')) {
      controlsShp[widget.fieldsMap['shape'].value - 1] = true;
    }
    controllers['shape'] = controlsShp;

    // Numeric controllers
    controllers['size'] = widget.fieldsMap['size'] ?? 1;
  }

  List<Widget> formsList() {
    const box = SizedBox(height: 5);
    return <Widget>[
      box,
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
  }

}
