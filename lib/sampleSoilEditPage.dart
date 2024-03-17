import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukke/objects/soilobj.dart';


class SampleSoilEditPage extends StatefulWidget {
  const SampleSoilEditPage({super.key, this.id});

  final int? id;

  @override
  State<SampleSoilEditPage> createState() => _SampleSoilEditPage();
}

class _SampleSoilEditPage extends State<SampleSoilEditPage> {
  Future<List<Soil>> soils = Soil.fetchSoilList();
  int? selectedId;

  @override
  void initState() {
    super.initState();
    selectedId = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Edit - Terreno'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              Navigator.of(context).pop(selectedId);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                key: const ValueKey('soil_edit_head'),
                children: soilLabelsList(),
              ),
            ),
            const Divider(
              height: 10,
              thickness: 1,
              indent: 8,
              endIndent: 8,
              color: Colors.black45,
            ),
            Expanded(
              child: FutureBuilder(
                future: soils,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return summaryTable(snapshot.data!);
                  } else {
                    return const Text("No data available");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> soilLabelsList() {
    const box = SizedBox(height: 5);
    List<Widget> l = [box];
    for (MapEntry e in Soil.componentsNames.entries) {
      l.add(
        Expanded(
          flex: 1,
          child: RotatedBox(
            quarterTurns: 1,
            child: Text(
              e.value,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.w300),
            ),
          ),
        )
      );
    }
    return l;
  }

  Widget summaryTable(List<Soil> data) {
    return CupertinoScrollbar(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: data.map((soil) => summaryRow(soil)).toList(),
      ),
    );
  }

  Widget summaryRow(Soil soil) {
    return InkWell(
      highlightColor: Colors.indigo[200],
      onTap: () {
        setState(() {
          selectedId = soil.id;
        });
      },
      child: Container(
        color: (selectedId == soil.id) ? Theme.of(context)
            .colorScheme.inversePrimary : null,
        child: Row(
        key: ValueKey(soil.id),
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              soil.id.toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              soil.peat.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              soil.cactusSoil.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              soil.akadama.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              soil.coconutFiber.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              soil.lapillus.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              soil.pumice.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              soil.sand.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              soil.perlite.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              soil.seramis.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              soil.gravel.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              soil.wormCasting.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              soil.marl.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),),
    );
  }
}
