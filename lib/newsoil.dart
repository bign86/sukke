import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sukke/theme/elements.dart';
import 'package:sukke/theme/theme.dart';
import 'package:sukke/objects/soilobj.dart';
import 'package:numberpicker/numberpicker.dart';

class NewSoilPage extends StatefulWidget {
  const NewSoilPage({super.key});

  @override
  State<NewSoilPage> createState() => _NewSoilPageState();
}

class _NewSoilPageState extends State<NewSoilPage> {
  Map<String, int> controllers = {};
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
          'Aggiungi terreno',
          style: textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              int total = controllers.values.reduce((sum, element) => sum + element);
              if (total != 100) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 3),
                      backgroundColor: Colors.red[700],
                      content: Text('Percentuale totale $total % != 100 %'),
                    )
                );
              } else {
                Map<String, int> newSoil = {};
                controllers.forEach((key, value) {
                  if (value > 0) {
                    newSoil[key] = value;
                  }
                });

                Navigator.of(context).pop(newSoil);
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
  
  void populateControllers() {
    // Numeric controllers
    for (String key in Soil.componentsNames.keys) {
      controllers[key] = 0;
    }
  }

  List<Widget> formsList() {
    List<Widget> l = [box5];
    for (MapEntry e in Soil.componentsNames.entries) {
      l.add(
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(e.value,),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: NumberPicker(
                  value: controllers[e.key]!,
                  minValue: 0,
                  maxValue: 100,
                  step: 1,
                  axis: Axis.horizontal,
                  itemHeight: 30,
                  itemWidth: 50,
                  haptics: true,
                  decoration: BoxDecoration(
                    borderRadius: borderR12,
                    border: Border.all(color: Colors.black26),
                  ),
                  onChanged: (value) => setState(() {
                    controllers[e.key] = value;
                  }),
                ),
              ),
            ),
          ],
        )
      );
      l.add(box5);
    }
    return l;
  }
}
