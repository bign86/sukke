import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:sukke/theme/elements.dart';
import 'package:sukke/objects/plantobj.dart';

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
              padding: padLR12,
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
      box5,
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
      box5,
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
      box5,
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
      box5,
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
      box5,
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Paesi',),
          ),
          Expanded(
            flex: 3,
            child: MultiDropdown(
              items: getKnownCountries(),
              controller: MultiSelectController<String>(),
              singleSelect: false,
              onSelectionChange: (options) {
                newFields['countries'] = options;
              },
              dropdownDecoration: const DropdownDecoration(
                marginTop: 2,
                maxHeight: 300,
                header: Padding(
                  padding: padAll8,
                  child: Text(
                    'Select a country from the list',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12,),
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
        ],
      ),
      box5,
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
      box5,
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
      box5,
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
      box5,
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
      box5,
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
      box5,
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
      box5,
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

  List<DropdownItem<String>> getKnownCountries() {
    List<DropdownItem<String>> knownCountries = <DropdownItem<String>>[
      DropdownItem<String>(label: 'Argentina', value: 'Argentina', selected: false),
      DropdownItem<String>(label: 'Bolivia', value: 'Bolivia', selected: false),
      DropdownItem<String>(label: 'Brazil', value: 'Brazil', selected: false),
      DropdownItem<String>(label: 'Canada', value: 'Canada', selected: false),
      DropdownItem<String>(label: 'Chile', value: 'Chile', selected: false),
      DropdownItem<String>(label: 'Madagascar', value: 'Madagascar', selected: false),
      DropdownItem<String>(label: 'Mexico', value: 'Mexico', selected: false),
      DropdownItem<String>(label: 'Namibia', value: 'Namibia', selected: false),
      DropdownItem<String>(label: 'Oman', value: 'Oman', selected: false),
      DropdownItem<String>(label: 'Paraguay', value: 'Paraguay', selected: false),
      DropdownItem<String>(label: 'Peru', value: 'Peru', selected: false),
      DropdownItem<String>(label: 'South Africa', value: 'South Africa', selected: false),
      DropdownItem<String>(label: 'United States', value: 'United States', selected: false),
      DropdownItem<String>(label: 'Uruguay', value: 'Uruguay', selected: false),
    ];

    // Check if widget.fieldsMap['countries'] is present and is a List
    if (widget.fieldsMap.containsKey('countries') &&
        widget.fieldsMap['countries'] is List) {
      List<String> selectedCountryCodes = List<String>.from(widget.fieldsMap['countries']);

      // Loop over knownCountries and set 'selected' to true if the country code is in selectedCountryCodes
      for (var country in knownCountries) {
        if (selectedCountryCodes.contains(country.label)) {
          country.selected = true;
        }
      }
    }

    return knownCountries;
  }
}
