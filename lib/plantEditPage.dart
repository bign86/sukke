import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:sukke/theme/elements.dart';
import 'package:sukke/theme/functions.dart';
import 'package:sukke/theme/theme.dart';
import 'package:sukke/objects/plantobj.dart';


class PlantFormData {
  // Text controllers
  late final TextEditingController family;
  late final TextEditingController genus;
  late final TextEditingController species;
  late final TextEditingController variant;
  late final TextEditingController commonName;
  late final TextEditingController synonyms;

  // Multi-select controller
  late final MultiSelectController<String> countries;

  // Simple value holders
  bool? cultivar;
  GrowthRate? growthRate;
  DormantSeason? dormantSeason;
  int? tMin;
  Needs? wateringNeeds;
  Needs? lightNeeds;

  // Constructor to initialize from the fieldsMap
  PlantFormData.fromMap(Map<String, dynamic> fieldsMap) {
    family = TextEditingController(text: fieldsMap['family'] ?? '');
    genus = TextEditingController(text: fieldsMap['genus'] ?? '');
    species = TextEditingController(text: fieldsMap['species'] ?? '');
    variant = TextEditingController(text: fieldsMap['variant'] ?? '');
    commonName = TextEditingController(text: fieldsMap['commonName'] ?? '');
    synonyms = TextEditingController(text: (fieldsMap['synonyms'] as List).join(', '));
    countries = MultiSelectController<String>();

    cultivar = fieldsMap['cultivar'] as bool? ?? false;
    growthRate = fieldsMap['growthRate'];
    dormantSeason = fieldsMap['dormantSeason'];
    tMin = fieldsMap['TMin'] ?? 0;
    wateringNeeds = fieldsMap['wateringNeeds'];
    lightNeeds = fieldsMap['lightNeeds'];
  }

  // Method to convert back to a map for saving
  Map<String, dynamic> toMap() {
    String? fam = family.text.trim();
    if (fam.isEmpty) {fam = null;}
    String? gn = genus.text.trim();
    if (gn.isEmpty) {gn = null;}
    String? sp = species.text.trim();
    if (sp.isEmpty) {sp = null;}
    String? vrn = variant.text.trim();
    if (vrn.isEmpty) {vrn = null;}
    String? cn = commonName.text.trim();
    if (cn.isEmpty) {cn = null;}

    return {
      'family': fam,
      'genus': gn,
      'species': sp,
      'variant': vrn,
      'commonName': cn,
      'synonyms': synonyms.text.split(',').map((s) => s.trim()).toList(),
      'countries': countries.selectedItems.map((s) => s.value).toList(),
      'cultivar': cultivar,
      'growthRate': growthRate,
      'dormantSeason': dormantSeason,
      'TMin': tMin,
      'wateringNeeds': wateringNeeds,
      'lightNeeds': lightNeeds,
    };
  }
}

class PlantAnagraphicEditPage extends StatefulWidget {
  const PlantAnagraphicEditPage({
    super.key, required this.fieldsMap, this.plantId
  });

  final Map<String, dynamic> fieldsMap;
  final int? plantId;

  @override
  State<PlantAnagraphicEditPage> createState() => _PlantAnagraphicEditPageState();
}

class _PlantAnagraphicEditPageState extends State<PlantAnagraphicEditPage> {
  late final PlantFormData _formData;
  List<DropdownItem<String>> knownCountries = [];
  final _formKey = GlobalKey<FormState>();
  final int flexTitle = 1;
  final int flexField = 3;

  @override
  void initState() {
    super.initState();
    _formData = PlantFormData.fromMap(widget.fieldsMap);
    knownCountries = _getKnownCountries(widget.fieldsMap['countries']);
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
          'Anagrafica pianta',
          style: textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              var validationErr = _formDataValidate(_formData);
              if (validationErr == null) {
                try {
                  if (widget.plantId == null) {
                    await newPlantToDB(_formData.toMap());
                  } else {
                    await updatePlantInformation(_formData.toMap(), widget.plantId!);
                  }
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  var err = createErrorSnackBar('Error in saving the plant: $e');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(err);
                  }
                }
              } else {
                var err = createErrorSnackBar(validationErr);
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
      createTextEntryRow(
        title: 'Family',
        controller: _formData.family,
        flexText: flexTitle,
        flexLabel: flexField
      ),
      vBox5,
      createTextEntryRow(
        title: 'Genus',
        controller: _formData.genus,
        flexText: flexTitle,
        flexLabel: flexField
      ),
      vBox5,
      createTextEntryRow(
        title: 'Species',
        controller: _formData.species,
        flexText: flexTitle,
        flexLabel: flexField
      ),
      vBox5,
      createTextEntryRow(
        title: 'Variant',
        controller: _formData.variant,
        flexText: flexTitle,
        flexLabel: flexField
      ),
      vBox5,
      createTextEntryRow(
        title: 'Sinonimi',
        controller: _formData.synonyms,
        flexText: flexTitle,
        flexLabel: flexField
      ),
      vBox5,
      Row(
        children: [
          Expanded(
            flex: flexTitle,
            child: createSimpleBodyText('Paesi', false),
          ),
          Expanded(
            flex: flexField,
            child: MultiDropdown(
              items: knownCountries,
              controller: _formData.countries,
              singleSelect: false,
              dropdownDecoration: DropdownDecoration(
                marginTop: 2,
                maxHeight: 300,
                header: Padding(
                  padding: padAll8,
                  child: createSimpleBodyText('Select a country from the list', false),
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
      vBox5,
      Row(
        children: [
          Expanded(
            flex: flexTitle,
            child: createSimpleBodyText('Cultivar', false),
          ),
          Expanded(
            flex: 3,
            child: Switch(
              value: _formData.cultivar ?? false,
              activeColor: Colors.indigo[200],
              onChanged: (bool value) {
              },
            ),
          ),
        ],
      ),
      vBox5,
      createTextEntryRow(
        title: 'Common names',
        controller:_formData.commonName,
        flexLabel: flexTitle,
        flexText: flexField
      ),
      vBox5,
      Row(
        children: [
          Expanded(
            flex: flexTitle,
            child: createSimpleBodyText('Growing speed', false),
          ),
          Expanded(
            flex: flexField,
            child: ToggleButtons(
              direction: Axis.horizontal,
              isSelected: GrowthRate.toList.map((rate) => rate == _formData.growthRate).toList(),
              onPressed: (int index) {
                setState(() {
                  _formData.growthRate = GrowthRate.getSelection(index);
                });
              },
              children: GrowthRate.toList
                  .map((GrowthRate rate) => Text(rate.label))
                  .toList(),
            ),
          ),
        ],
      ),
      vBox5,
      Row(
        children: [
          Expanded(
            flex: flexTitle,
            child: createSimpleBodyText('Dormant season', false),
          ),
          Expanded(
            flex: flexField,
            child: ToggleButtons(
              direction: Axis.horizontal,
              isSelected: DormantSeason.toList.map((s) => s == _formData.dormantSeason).toList(),
              onPressed: (int index) {
                setState(() {
                  _formData.dormantSeason = DormantSeason.getSelection(index);
                });
              },
              children: DormantSeason.toList
                  .map((DormantSeason rate) => Text(rate.label))
                  .toList(),
            ),
          ),
        ],
      ),
      vBox5,
      Row(
        children: [
          Expanded(
            flex: flexTitle,
            child: createSimpleBodyText('T Min', false),
          ),
          Expanded(
            flex: flexField,
            child: Center(
              child: NumberPicker(
                value: _formData.tMin!,
                minValue: -30,
                maxValue: 20,
                step: 1,
                axis: Axis.horizontal,
                itemHeight: 30,
                itemWidth: 30,
                haptics: true,
                decoration: BoxDecoration(
                  borderRadius: borderR12,
                  border: Border.all(color: Colors.black26),
                ),
                onChanged: (value) => setState(() {
                  _formData.tMin = value;
                }),
              ),
            ),
          ),
        ],
      ),
      vBox5,
      Row(
        children: [
          Expanded(
            flex: flexTitle,
            child: createSimpleBodyText('Water', false),
          ),
          Expanded(
            flex: flexField,
            child: ToggleButtons(
              direction: Axis.horizontal,
              isSelected: Needs.toList.map((s) => s == _formData.wateringNeeds).toList(),
              onPressed: (int index) {
                setState(() {
                  _formData.wateringNeeds = Needs.getSelection(index);
                });
              },
              children: Needs.toList
                  .map((Needs v) => Text(v.value.toString()))
                  .toList(),
            ),
          ),
        ],
      ),
      vBox5,
      Row(
        children: [
          Expanded(
            flex: flexTitle,
            child: createSimpleBodyText('Light', false),
          ),
          Expanded(
            flex: flexField,
            child: ToggleButtons(
              direction: Axis.horizontal,
              isSelected: Needs.toList.map((s) => s == _formData.lightNeeds).toList(),
              onPressed: (int index) {
                setState(() {
                  _formData.lightNeeds = Needs.getSelection(index);
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

  static List<DropdownItem<String>> _getKnownCountries(List<String> selectedCountryCodes) {
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

    // Loop over knownCountries and set 'selected' to true if the country code
    // is in selectedCountryCodes
    for (var country in knownCountries) {
      if (selectedCountryCodes.contains(country.label)) {
        country.selected = true;
      }
    }

    return knownCountries;
  }

  static String? _formDataValidate(PlantFormData newFields) {
    // Check for family
    if (newFields.family.text.trim().isEmpty) {
      return "Il campo family è vuoto!";
    }
    // Check for genus
    if (newFields.genus.text.trim().isEmpty) {
      return "Il campo genus è vuoto!";
    }
    // Check for species
    if (newFields.species.text.trim().isEmpty) {
      return "Il campo species è vuoto!";
    }

    // In the end return True
    return null;
  }
}
