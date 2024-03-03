
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
    id=item["id"],
    material=PotMaterial.getSelection(item["material"]),
    shape=PotShape.getSelection(item["shape"]),
    deep=item["deep"] == 0 ? false : true,
    size=item["size"];

  Map<String, Object> toMap(){
    return {
      'id':id, 'material':material, 'shape':shape, 'deep':deep, 'size':size
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Pot{id: $id, material: $material, size: $size}';
  }
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

