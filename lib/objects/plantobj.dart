import 'dart:convert';

class PlantListItem{
  final int id;
  final String name;

  PlantListItem({required this.id, required this.name});

  PlantListItem.fromMap(Map item):
        id=item["id"],
        name=item["name"];

  Map<String, Object> toMap(){
    return {'id':id, 'name':name};
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Plant{id: $id, name: $name}';
  }
}

class Plant {
  final int id;
  final String family;
  final String genus;
  final String? species;
  final String? commonName;
  final List<String> countries;
  final String? habitat;
  final Needs wateringNeeds;
  final Needs lightNeeds;
  final int? TMin;
  final List<String> links;
  final String? notes;
  final String? propagation;
  final String? cultivation;
  final GrowthRate growthRate;
  final String? light;
  final bool cultivar;
  final String? wateringNotes;
  final DormantSeason dormantSeason;
  final String? variant;
  final List<String> synonyms;
  final String? altitude;

  Plant({
    required this.id,
    required this.family,
    required this.genus,
    required this.species,
    required this.commonName,
    required this.countries,
    required this.habitat,
    required this.wateringNeeds,
    required this.lightNeeds,
    required this.TMin,
    required this.links,
    required this.notes,
    required this.propagation,
    required this.cultivation,
    required this.growthRate,
    required this.light,
    required this.cultivar,
    required this.wateringNotes,
    required this.dormantSeason,
    required this.variant,
    required this.synonyms,
    required this.altitude,
  });

  Plant.fromMap(Map item)
      : id = item["id"],
        family = item["family"],
        genus = item["genus"],
        species = item["species"],
        commonName = item["commonName"],
        countries = (jsonDecode(item["countries"]) as List).cast<String>(),
        habitat = item["habitat"],
        wateringNeeds = Needs.getSelection(item["wateringNeeds"]),
        lightNeeds = Needs.getSelection(item["lightNeeds"]),
        TMin = item["TMin"],
        links = (jsonDecode(item["links"]) as List).cast<String>(),
        notes = item["notes"],
        propagation = item["propagation"],
        cultivation = item["cultivation"],
        growthRate = GrowthRate.getSelection(item["growthRate"] as int),
        light = item["light"],
        cultivar = item["cultivar"] == 0 ? false : true,
        wateringNotes = item["wateringNotes"],
        dormantSeason = DormantSeason.getSelection(item["dormantSeason"] as int),
        variant = item["variant"],
        synonyms = (jsonDecode(item["synonyms"]) as List).cast<String>(),
        altitude = item["altitude"];

  Map<String, dynamic> _toMap() {
    return {
      'id': id, 'family': family, 'genus': genus, 'species': species,
      'commonName': commonName, 'countries': countries, 'habitat': habitat,
      'wateringNeeds': wateringNeeds, 'lightNeeds': lightNeeds, 'TMin': TMin,
      'links': links, 'notes': notes, 'propagation': propagation,
      'cultivation': cultivation, 'growthRate': growthRate, 'light': light,
      'cultivar': cultivar, 'wateringNotes': wateringNotes,
      'dormantSeason': dormantSeason, 'variant': variant, 'synonyms': synonyms,
      'altitude': altitude,
    };
  }

  dynamic get(String propertyName) {
    var mapRep = _toMap();
    if (mapRep.containsKey(propertyName)) {
      return mapRep[propertyName];
    } else {
      return null;
    }
    //throw ArgumentError('Property $propertyName not found');
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Plant{id: $id, species: ${species ?? ""}, commonName: ${commonName ?? ""}}';
  }

  String updateQuery(String column) {
    return '''UPDATE [Plant] SET [$column] = ?1 WHERE [id] = ?2;''';
  }

  static String selectQuery = '''
  SELECT [id], [family], [genus], [species], [commonName], [countries], [habitat],
    [wateringNeeds], [lightNeeds], [TMin], [links], [notes], [propagation],
    [cultivation], [growthRate], [light], [cultivar], [wateringNotes],
    [dormantSeason], [variant], [synonyms], [altitude], [links]
	FROM [Plant]
    WHERE [id]=?1;
  ''';
}

/*enum YesNo {
  yes('Yes', true),
  no('No', false);

  const YesNo(this.label, this.value);
  final String label;
  final bool value;
}*/

enum DormantSeason {
  na('N/A', 0),
  summer('Summer', 1),
  winter('Winter', 2);

  const DormantSeason(this.label, this.value);
  final String label;
  final int value;

  static int len() => 3;

  static DormantSeason getSelection(int v) {
    DormantSeason selection;
    switch (v) {
      case 0: selection = DormantSeason.na;
      case 1: selection = DormantSeason.summer;
      case 2: selection = DormantSeason.winter;
      default: selection = DormantSeason.na;
    }
    return selection;
  }

  static String getLabel(int v) {
    String label;
    switch (v) {
      case 0: label = DormantSeason.na.label;
      case 1: label = DormantSeason.summer.label;
      case 2: label = DormantSeason.winter.label;
      default: label = '';
    }
    return label;
  }

  static List<DormantSeason> toList = <DormantSeason>[
    DormantSeason.na,
    DormantSeason.summer,
    DormantSeason.winter,
  ];
}

enum GrowthRate {
  na('N/A', 0),
  fast('Fast', 1),
  slow('Slow', 2);

  const GrowthRate(this.label, this.value);
  final String label;
  final int value;

  static int len() => 3;

  static GrowthRate getSelection(int v) {
    GrowthRate selection;
    switch (v) {
      case 0: selection = GrowthRate.na;
      case 1: selection = GrowthRate.fast;
      case 2: selection = GrowthRate.slow;
      default: selection = GrowthRate.na;
    }
    return selection;
  }

  static String getLabel(int v) {
    String label;
    switch (v) {
      case 0: label = GrowthRate.na.label;
      case 1: label = GrowthRate.fast.label;
      case 2: label = GrowthRate.slow.label;
      default: label = '';
    }
    return label;
  }

  static List<GrowthRate> toList = <GrowthRate>[
    GrowthRate.na,
    GrowthRate.fast,
    GrowthRate.slow,
  ];
}

enum Needs {
  nothing(1),
  low(2),
  medium(3),
  high(4),
  huge(5);

  const Needs(this.value);
  final int value;

  static int len() => 5;

  static Needs getSelection(int v) {
    Needs selection;
    switch (v) {
      case 1: selection = Needs.nothing;
      case 2: selection = Needs.low;
      case 3: selection = Needs.medium;
      case 4: selection = Needs.high;
      case 5: selection = Needs.huge;
      default: selection = Needs.medium;
    }
    return selection;
  }

  static List<Needs> toList = <Needs>[
    Needs.nothing,
    Needs.low,
    Needs.medium,
    Needs.high,
    Needs.huge,
  ];
}
