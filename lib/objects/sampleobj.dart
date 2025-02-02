import 'dart:convert';

import 'package:sukke/db.dart';
import 'package:sukke/objects/plantobj.dart';
import 'package:sukke/objects/potobj.dart';

class SampleListItem {
  final int id;
  final String name;

  SampleListItem({required this.id, required this.name});

  SampleListItem.fromMap(Map item) : id = item["id"], name = item["name"];

  Map<String, Object> toMap() {
    return {'id': id, 'name': name};
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'SampleListItem{id: $id, name: $name}';
  }
}

class SampleDetails {
  final int id;
  final int plant;
  final int? soil;
  final String? location;
  final int? born;
  final bool crested;
  final bool variegated;
  final bool grafted;
  final bool monstrous;
  final bool bought;
  final bool fromSeed;
  final bool fromCutting;
  final String? notes;
  final String? species;
  final String? commonName;
  final Needs wateringNeeds;
  final Needs lightNeeds;
  final int? tMin;
  final bool cultivar;
  final String variant;
  final PotMaterial material;
  final PotShape shape;
  final bool deep;
  final int size;
  final String? water;
  final int? waterDelta;
  final String? repot;
  final int? repotDelta;
  final String? fertilize;
  final int? fertilizeDelta;
  final String? pests;
  final int? pestsDelta;

  SampleDetails({
    required this.id,
    required this.plant,
    this.soil,
    this.location,
    this.born,
    required this.crested,
    required this.variegated,
    required this.grafted,
    required this.monstrous,
    required this.bought,
    required this.fromSeed,
    required this.fromCutting,
    this.notes,
    this.species,
    this.commonName,
    required this.wateringNeeds,
    required this.lightNeeds,
    this.tMin,
    required this.cultivar,
    required this.variant,
    required this.material,
    required this.shape,
    required this.deep,
    required this.size,
    this.water,
    this.waterDelta,
    this.repot,
    this.repotDelta,
    this.fertilize,
    this.fertilizeDelta,
    this.pests,
    this.pestsDelta,
  });

  SampleDetails.fromMap(Map item)
    : id = item["id"],
      plant = item["plant"],
      soil = item["soil"],
      location = item["location"],
      born = item["born"],
      crested = item["crested"] == 0 ? false : true,
      variegated = item["variegated"] == 0 ? false : true,
      grafted = item["grafted"] == 0 ? false : true,
      monstrous = item["monstrous"] == 0 ? false : true,
      bought = item["bought"] == 0 ? false : true,
      fromSeed = item["fromSeed"] == 0 ? false : true,
      fromCutting = item["fromCutting"] == 0 ? false : true,
      notes = item["notes"],
      species = item["species"],
      commonName = item["commonName"],
      wateringNeeds = Needs.getSelection(item["wateringNeeds"]),
      lightNeeds = Needs.getSelection(item["lightNeeds"]),
      tMin = item["TMin"],
      cultivar = item["cultivar"] == 0 ? false : true,
      variant = item["variant"] ?? "",
      material = PotMaterial.getSelection(item["material"]),
      shape = PotShape.getSelection(item["shape"]),
      deep = item["deep"] == 0 ? false : true,
      size = item["size"],
      water = item["water"],
      waterDelta = item["waterDelta"],
      repot = item["repot"],
      repotDelta = item["repotDelta"],
      fertilize = item["fertilize"],
      fertilizeDelta = item["fertilizeDelta"],
      pests = item["pests"],
      pestsDelta = item["pestsDelta"];

  Map<String, Object> toMap() {
    return {'id': id, 'plant': plant};
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'SampleDetails{id: $id, plant: $plant}';
  }

  static String selectQuery = '''
  SELECT
		Sa.[id], Sa.[plant], Sa.[soil], Sa.[location], Sa.[born],
		Sa.[crested], Sa.[variegated], Sa.[grafted], Sa.[monstrous],
		Sa.[bought], Sa.[fromSeed], Sa.[fromCutting], Sa.[notes],
		Pl.[species], Pl.[commonName], Pl.[wateringNeeds],
		Pl.[lightNeeds], Pl.[TMin], Pl.[cultivar], Pl.[variant],
		Po.[material], Po.[shape], Po.[deep], Po.[size],
		Su.[water], Su.[waterDelta], Su.[repot], Su.[repotDelta],
		Su.[fertilize], Su.[fertilizeDelta], Su.[pests], Su.[pestsDelta]
	FROM [Sample] AS Sa
  JOIN [Plant] AS Pl ON Sa.[plant] = Pl.[id]
	JOIN [Pot] AS Po ON Sa.[pot] = Po.[id]
	JOIN [Summary] AS Su ON Sa.[id] = Su.[id]
    WHERE Sa.[id] = ?1
  ''';
}

class Sample {
  final int id;
  final int plant;
  final int pot;
  final int? soil;
  final String? location;
  final int? born;
  final bool crested;
  final bool variegated;
  final bool grafted;
  final bool monstrous;
  final bool bought;
  final bool fromSeed;
  final bool fromCutting;
  final String? notes;
  final List<String> links;

  Sample({
    required this.id,
    required this.plant,
    required this.pot,
    this.soil,
    this.location,
    this.born,
    required this.crested,
    required this.variegated,
    required this.grafted,
    required this.monstrous,
    required this.bought,
    required this.fromSeed,
    required this.fromCutting,
    this.notes,
    required this.links,
  });

  Sample.fromMap(Map item)
    : id = item["id"],
      plant = item["plant"],
      pot = item["pot"],
      soil = item["soil"],
      location = item["location"],
      born = item["born"],
      crested = item["crested"] == 0 ? false : true,
      variegated = item["variegated"] == 0 ? false : true,
      grafted = item["grafted"] == 0 ? false : true,
      monstrous = item["monstrous"] == 0 ? false : true,
      bought = item["bought"] == 0 ? false : true,
      fromSeed = item["fromSeed"] == 0 ? false : true,
      fromCutting = item["fromCutting"] == 0 ? false : true,
      notes = item["notes"],
      links = (jsonDecode(item['links']) as List).cast<String>();

  Map<String, Object> toMap() {
    return {'id': id, 'plant': plant};
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Sample{id: $id, plant: $plant, pot: $pot}';
  }
}

Future<Null> updateSample(int sampleId, Map<String, dynamic> newFields) async {
  String query = '''
    UPDATE [Sample] SET
    [born] = ?1, [bought] = ?2, [fromSeed] = ?3, [fromCutting] = ?4
    [crested] = ?5, [variegated] = ?6, [grafted] = ?7, [monstrous] = ?8,
    [location] = ?9
    WHERE [id] = ?10;
    ''';
  final List arguments = [
    newFields['born'] as int,
    newFields['bought'] ? 1 : 0,
    newFields['fromSeed'] ? 1 : 0,
    newFields['fromCutting'] ? 1 : 0,
    newFields['crested'] ? 1 : 0,
    newFields['variegated'] ? 1 : 0,
    newFields['grafted'] ? 1 : 0,
    newFields['monstrous'] ? 1 : 0,
    newFields['location'] as String,
    sampleId,
  ];
  final db = await DBService().db;
  await db.rawUpdate(query, arguments);
}

Future<Null> deleteSample(int id) async {
  final db = await DBService().db;

  await db.rawDelete('DELETE FROM [Events] WHERE [id] = ?1;', [id]);
  await db.rawDelete('DELETE FROM [Sample] WHERE [id] = ?1;', [id]);
}

