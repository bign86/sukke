import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukke/objects/sampleobj.dart';
import 'package:numberpicker/numberpicker.dart';


class SampleEditPage extends StatefulWidget {
  const SampleEditPage({
    super.key, required this.data // fields
  });

  final SampleDetails data;

  @override
  State<SampleEditPage> createState() => _SampleEditPageState();
}

class _SampleEditPageState extends State<SampleEditPage> {
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
        title: const Text('Edit - Anagrafica',),
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
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              children: formsList(),
            ),
          ),
        ),
      ),
    );
  }

  void populateControllers() {
    // Text controllers
    controllers['location'] =
        TextEditingController(text: widget.data.location ?? "");

    // Boolean controllers
    controllers['bought'] = widget.data.bought;
    controllers['fromSeed'] = widget.data.fromSeed;
    controllers['fromCutting'] = widget.data.fromCutting;
    controllers['crested'] = widget.data.crested;
    controllers['variegated'] = widget.data.variegated;
    controllers['grafted'] = widget.data.grafted;
    controllers['monstrous'] = widget.data.monstrous;

    // Numeric controllers
    controllers['born'] = widget.data.born;
  }

  List<Widget> formsList() {
    const box = SizedBox(height: 5);
    return <Widget>[
      box,
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
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Notes',),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              controller: controllers['notes'],
              style: const TextStyle(fontSize: 12,),
              onChanged: (String value) {
                controllers['notes'] = value;
              },
              autofocus: false,
              autocorrect: false,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 2,
            ),
          ),
        ],
      ),
    ];
  }
}
