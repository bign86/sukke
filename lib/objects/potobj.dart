import 'package:sukke/db.dart';

class Pot{
  final int id;
  final PotMaterial material;
  final PotShape shape;
  final bool deep;
  final int size;

  Pot({
    required this.id,
    required this.material,
    required this.shape,
    required this.deep,
    required this.size,
  });

  Pot.fromMap(Map item):
    id       = item["id"],
    material = PotMaterial.getSelection(item["material"]),
    shape    = PotShape.getSelection(item["shape"]),
    deep     = item["deep"] == 0 ? false : true,
    size     = item["size"];

  Map<String, Object> toMap(){
    return {
      'id':id,
      'material':material,
      'shape':shape,
      'deep':deep,
      'size':size
    };
  }

  // Implement toString to make it easier to see information about
  // each pot when using the print statement.
  @override
  String toString() {
    return 'Pot{id: $id, material: $material, size: $size}';
  }
}

Future<int> getNewPotId(Map<String, dynamic> newFields) async {
  // Take the ID of the new pot. If null it does not exists.
  final db = await DBService().db;
  int newId;

  String idQuery = '''
    SELECT [id] FROM [Pot] WHERE
      [material] = ?1 AND [shape] = ?2 AND
      [deep] = ?3 AND [size] = ?4;
    ''';
  final mapId = await db.rawQuery(
      idQuery,
      [
        newFields['material'].value, newFields['shape'].value,
        newFields['deep'] ? 1 : 0, newFields['size']
      ]
  );

  // If no existing pot corresponds to the new one
  if (mapId.isEmpty) {
    // Get the MAX(id)
    newId = await getMaxId('maxIdPot');
    // String maxIdQuery = '''SELECT MAX([id]) AS id FROM [Pot];''';
    // final maxId = await db.rawQuery(maxIdQuery);
    // newId = maxId[0]['id'] as int;
    // Add 1 to the ID and save the new pot in Pot
    newId += 1;

    // Save the new pot
    String newPotQuery = '''
      INSERT INTO [Pot] ([id], [material], [shape], [deep], [size])
      VALUES (?1, ?2, ?3, ?4, ?5);
      ''';
    await db.rawInsert(
        newPotQuery,
        [
          newId, newFields['material'].value, newFields['shape'].value,
          newFields['deep'] ? 1 : 0, newFields['size']
        ]
    );

    // Update the maxIdPot
    String newMaxIdPot = "UPDATE [System] SET [valueNum] = ?1 WHERE [key] = 'maxIdPot';";
    await db.rawInsert(newMaxIdPot, [newId]);

  } else {
    newId = mapId[0]['id'] as int;
  }

  // Return the pot ID to update the Sample table
  return newId;
}


enum PotShape {
  square('Square', 1),
  round('Round', 2);

  const PotShape(this.label, this.value);
  final String label;
  final int value;

  static int len() => 2;

  static PotShape getSelection(int v) {
    PotShape selection;
    switch (v) {
      case 1: selection = PotShape.square;
      case 2: selection = PotShape.round;
      default: selection = PotShape.square;
    }
    return selection;
  }

  static List<PotShape> toList = <PotShape>[
    PotShape.square,
    PotShape.round,
  ];
}

enum PotMaterial {
  terracotta('Terracotta', 1),
  plastic('Plastic', 2),
  glazedclay('Glazed clay', 3);

  const PotMaterial(this.label, this.value);
  final String label;
  final int value;

  static int len() => 3;

  static PotMaterial getSelection(int v) {
    PotMaterial selection;
    switch (v) {
      case 1: selection = PotMaterial.terracotta;
      case 2: selection = PotMaterial.plastic;
      case 3: selection = PotMaterial.glazedclay;
      default: selection = PotMaterial.terracotta;
    }
    return selection;
  }

  static List<PotMaterial> toList = <PotMaterial>[
    PotMaterial.terracotta,
    PotMaterial.plastic,
    PotMaterial.glazedclay,
  ];
}

