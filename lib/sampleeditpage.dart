import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:sukke/theme/elements.dart';
import 'package:sukke/theme/functions.dart';
import 'package:sukke/objects/sampleobj.dart';


class SampleFormData {
  // Text controllers
  late final TextEditingController location;
  late final TextEditingController fieldNumber;

  // Simple value holders
  late bool bought;
  late bool fromSeed;
  late bool fromCutting;
  late bool crested;
  late bool variegated;
  late bool grafted;
  late bool monstrous;
  late int born;

  // Constructor to initialize from the fieldsMap
  SampleFormData.fromSampleDetails(SampleDetails sampleData) {
    location = TextEditingController(text: sampleData.location);
    fieldNumber = TextEditingController(text: sampleData.fieldNumber);

    bought = sampleData.bought;
    fromSeed = sampleData.fromSeed;
    fromCutting = sampleData.fromCutting;
    crested = sampleData.crested;
    variegated = sampleData.variegated;
    grafted = sampleData.grafted;
    monstrous = sampleData.monstrous;
    born = sampleData.born ?? 2020;
  }

  // Method to convert back to a map for saving
  Map<String, dynamic> toMap() {
    String? loc = location.text.trim();
    if (loc.isEmpty) {loc = null;}
    String? fn = fieldNumber.text.trim();
    if (fn.isEmpty) {fn = null;}

    return {
      'location': loc,
      'fieldNumber': fn,
      'bought': bought,
      'fromSeed': fromSeed,
      'fromCutting': fromCutting,
      'crested': crested,
      'variegated': variegated,
      'grafted': grafted,
      'monstrous': monstrous,
      'born': born,
    };
  }
}

class SampleEditPage extends StatefulWidget {
  const SampleEditPage({
    super.key, required this.data
  });

  final SampleDetails data;

  @override
  State<SampleEditPage> createState() => _SampleEditPageState();
}

class _SampleEditPageState extends State<SampleEditPage> {
  late final SampleFormData _formData;
  //Map<String, dynamic> controllers = {};
  final _formKey = GlobalKey<FormState>();
  final int flexTitle = 1;
  final int flexField = 3;

  @override
  void initState() {
    super.initState();
    _formData = SampleFormData.fromSampleDetails(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text('Aggiorna esemplare',),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              try {
                await updateSample(widget.data.id, _formData.toMap());
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              } catch (e) {
                var err = createErrorSnackBar('Error in saving the sample: $e');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(err);
                }
              }
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

  List<Widget> formsList() {
    return <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: createSimpleBodyText('Born', false),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: NumberPicker(
                value: _formData.born,
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
                onChanged: (value) => setState(() {_formData.born = value;}),
              ),
            ),
          ),
        ],
      ),
      vBox5,
      _createSwitchEntry(
        title: 'Bought',
        value: _formData.bought,
        onChanged: (newValue) => _formData.bought = newValue,
      ),
      vBox5,
      _createSwitchEntry(
        title: 'From seed',
        value: _formData.fromSeed,
        onChanged: (newValue) => _formData.fromSeed = newValue,
      ),
      vBox5,
      _createSwitchEntry(
        title: 'From cutting',
        value: _formData.fromCutting,
        onChanged: (newValue) => _formData.fromCutting = newValue,
      ),
      vBox5,
      _createSwitchEntry(
        title: 'Crested',
        value: _formData.crested,
        onChanged: (newValue) => _formData.crested = newValue,
      ),
      vBox5,
      _createSwitchEntry(
        title: 'Variegated',
        value: _formData.variegated,
        onChanged: (newValue) => _formData.variegated = newValue,
      ),
      vBox5,
      _createSwitchEntry(
        title: 'Grafted',
        value: _formData.grafted,
        onChanged: (newValue) => _formData.grafted = newValue,
      ),
      vBox5,
      _createSwitchEntry(
        title: 'Monstrous',
        value: _formData.monstrous,
        onChanged: (newValue) => _formData.monstrous = newValue,
      ),
      vBox5,
      createTextEntryRow(
        title: 'Field Number',
        controller: _formData.fieldNumber,
        flexLabel: flexTitle,
        flexText: flexField
      ),
      vBox5,
      createTextEntryRow(
        title: 'Sample location',
        controller: _formData.location,
        flexLabel: flexTitle,
        flexText: flexField
      ),
    ];
  }

  Widget _createSwitchEntry({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          flex: flexTitle,
          child: createSimpleBodyText(title, false),
        ),
        Expanded(
          flex: flexField,
          child: Switch(
            value: value,
            activeColor: Colors.indigo[200],
            onChanged: (bool newValue) => setState(() => onChanged(newValue)),
          ),
        ),
      ],
    );
  }

}
