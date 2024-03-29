import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukke/objects/plantobj.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:numberpicker/numberpicker.dart';

class PlantAnagraphicEditPage extends StatefulWidget {
  const PlantAnagraphicEditPage({
    super.key, required this.fieldsMap   // fields
  });

  final Map<String, dynamic> fieldsMap;

  @override
  State<PlantAnagraphicEditPage> createState() => _PlantAnagraphicEditPageState();
}

class _PlantAnagraphicEditPageState extends State<PlantAnagraphicEditPage> {
  Map<String, dynamic> controllers = {};
  Map<String, dynamic> newFields = {};
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
    // Text controllers
    controllers['family'] =
        TextEditingController(text: widget.fieldsMap['family'] ?? "");
    controllers['genus'] =
        TextEditingController(text: widget.fieldsMap['genus'] ?? "");
    controllers['species'] =
        TextEditingController(text: widget.fieldsMap['species'] ?? "");
    controllers['variant'] =
        TextEditingController(text: widget.fieldsMap['variant'] ?? "");
    controllers['commonName'] =
        TextEditingController(text: widget.fieldsMap['commonName'] ?? "");

    // List controllers
    controllers['synonyms'] =
        TextEditingController(text: widget.fieldsMap['synonyms'].join(', '));
    var countries = widget.fieldsMap['countries'];
    var setCountries = countries.map<ValueItem<String>>(
            (c) => ValueItem<String>(label: c.trim().toString(), value: c.trim().toString())
    ).toList();
    MultiSelectController controller = MultiSelectController();
    controller.setOptions(knownCountries);
    controller.setSelectedOptions(setCountries);
    controllers['countries'] = controller;

    // Boolean controllers
    controllers['cultivar'] = (widget.fieldsMap['cultivar'] as bool);

    // Multiple choice controllers
    var controlsGR = List<bool>.filled(GrowthRate.len(), false);
    if (widget.fieldsMap.containsKey('growthRate')) {
      controlsGR[widget.fieldsMap['growthRate'].value] = true;
    }
    controllers['growthRate'] = controlsGR;
    var controlsDS = List<bool>.filled(DormantSeason.len(), false);
    if (widget.fieldsMap.containsKey('dormantSeason')) {
      controlsDS[widget.fieldsMap['dormantSeason'].value] = true;
    }
    controllers['dormantSeason'] = controlsDS;
    var controlsWN = List<bool>.filled(Needs.len(), false);
    if (widget.fieldsMap.containsKey('wateringNeeds')) {
      controlsWN[widget.fieldsMap['wateringNeeds'].value - 1] = true;
    }
    controllers['wateringNeeds'] = controlsWN;
    var controlsLN = List<bool>.filled(Needs.len(), false);
    if (widget.fieldsMap.containsKey('lightNeeds')) {
      controlsLN[widget.fieldsMap['lightNeeds'].value - 1] = true;
    }
    controllers['lightNeeds'] = controlsLN;

    // Numeric controllers
    controllers['TMin'] = widget.fieldsMap['TMin'];
  }

  List<Widget> formsList() {
    const box = SizedBox(height: 5);
    return <Widget>[
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Family',),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              controller: controllers['family'],
              style: const TextStyle(fontSize: 12,),
              onChanged: (String value) {
                newFields['family'] = value;
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
      box,
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Genus',),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              controller: controllers['genus'],
              style: const TextStyle(fontSize: 12,),
              onChanged: (String value) {
                newFields['genus'] = value;
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
      box,
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Species',),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              controller: controllers['species'],
              style: const TextStyle(fontSize: 12,),
              onChanged: (String value) {
                newFields['species'] = value;
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
      box,
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Variant',),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              controller: controllers['variant'],
              style: const TextStyle(fontSize: 12,),
              onChanged: (String value) {
                newFields['variant'] = value;
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
      box,
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Sinonimi',),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              controller: controllers['synonyms'],
              style: const TextStyle(fontSize: 12,),
              onChanged: (String value) {
                newFields['synonyms'] = value.split(',').map((name) => name.trim()).toList();
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
      box,
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Paesi',),
          ),
          Expanded(
            flex: 3,
            child: MultiSelectDropDown(
              controller: controllers['countries'],
              onOptionSelected: (options) {
                newFields['countries'] = controllers['countries'].selectedOptions;
              },
              onOptionRemoved: (index, option) {
                newFields['countries'] = controllers['countries'].selectedOptions;
              },
              options: knownCountries,
              selectionType: SelectionType.multi,
              chipConfig: const ChipConfig(wrapType: WrapType.wrap),
              dropdownHeight: 300,
              optionTextStyle: const TextStyle(fontSize: 12),
              selectedOptionIcon: const Icon(Icons.check_circle),
            ),
          ),
        ],
      ),
      box,
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Cultivar',),
          ),
          Expanded(
            flex: 3,
            child: Switch(
              value: controllers['cultivar'],
              activeColor: Colors.indigo[200],
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {
                  controllers['cultivar'] = value;
                  newFields['cultivar'] = value;
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
            child: Text('Common names',),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              controller: controllers['commonName'],
              style: const TextStyle(fontSize: 12,),
              onChanged: (String value) {
                newFields['commonName'] = value.trim();
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
      box,
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Growing speed',),
          ),
          Expanded(
            flex: 3,
            child: ToggleButtons(
              direction: Axis.horizontal,
              isSelected: controllers['growthRate'],
              onPressed: (int index) {
                setState(() {
                  var list = controllers['growthRate'];
                  for (int i = 0; i < list.length; i++) {
                    list[i] = i == index;
                  }
                  newFields['growthRate'] = GrowthRate.getSelection(index);
                });
              },
              children: GrowthRate.toList
                  .map((GrowthRate rate) => Text(rate.label))
                  .toList(),
            ),
          ),
        ],
      ),
      box,
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Dormant season',),
          ),
          Expanded(
            flex: 3,
            child: ToggleButtons(
              direction: Axis.horizontal,
              isSelected: controllers['dormantSeason'],
              onPressed: (int index) {
                setState(() {
                  var list = controllers['dormantSeason'];
                  for (int i = 0; i < list.length; i++) {
                    list[i] = i == index;
                  }
                  newFields['dormantSeason'] = DormantSeason.getSelection(index);
                });
              },
              children: DormantSeason.toList
                  .map((DormantSeason rate) => Text(rate.label))
                  .toList(),
            ),
          ),
        ],
      ),
      box,
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('T Min',),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: NumberPicker(
                value: controllers['TMin'],
                minValue: -30,
                maxValue: 20,
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
                  controllers['TMin'] = value;
                  newFields['TMin'] = value;
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
            child: Text('Water',),
          ),
          Expanded(
            flex: 3,
            child: ToggleButtons(
              direction: Axis.horizontal,
              isSelected: controllers['wateringNeeds'],
              onPressed: (int index) {
                setState(() {
                  var list = controllers['wateringNeeds'];
                  for (int i = 0; i < list.length; i++) {
                    list[i] = i == index;
                  }
                  newFields['wateringNeeds'] = Needs.getSelection(index + 1);
                });
              },
              children: Needs.toList
                  .map((Needs v) => Text(v.value.toString()))
                  .toList(),
            ),
          ),
        ],
      ),
      box,
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Light',),
          ),
          Expanded(
            flex: 3,
            child: ToggleButtons(
              direction: Axis.horizontal,
              isSelected: controllers['lightNeeds'],
              onPressed: (int index) {
                setState(() {
                  var list = controllers['lightNeeds'];
                  for (int i = 0; i < list.length; i++) {
                    list[i] = i == index;
                  }
                  newFields['lightNeeds'] = Needs.getSelection(index + 1);
                });
              },
              children: Needs.toList
                  .map((Needs v) => Text(v.value.toString()))
                  .toList(),
            ),
          ),
        ],
      ),
    ];
  }
}

const List<ValueItem> knownCountries = <ValueItem>[
  ValueItem(label: 'Argentina', value: 'Argentina'),
  ValueItem(label: 'Bolivia', value: 'Bolivia'),
  ValueItem(label: 'Brazil', value: 'Brazil'),
  ValueItem(label: 'Canada', value: 'Canada'),
  ValueItem(label: 'Chile', value: 'Chile'),
  ValueItem(label: 'Madagascar', value: 'Madagascar'),
  ValueItem(label: 'Mexico', value: 'Mexico'),
  ValueItem(label: 'Namibia', value: 'Namibia'),
  ValueItem(label: 'Oman', value: 'Oman'),
  ValueItem(label: 'Paraguay', value: 'Paraguay'),
  ValueItem(label: 'Peru', value: 'Peru'),
  ValueItem(label: 'South Africa', value: 'South Africa'),
  ValueItem(label: 'United States', value: 'United States'),
  ValueItem(label: 'Uruguay', value: 'Uruguay'),
];
