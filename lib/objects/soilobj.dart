import 'package:sukke/db.dart';

class Soil {
  final int id;
  int peat = 0;
  int cactusSoil = 0;
  int akadama = 0;
  int coconutFiber = 0;
  int lapillus = 0;
  int pumice = 0;
  int sand = 0;
  int zeolite = 0;
  int perlite = 0;
  int seramis = 0;
  int gravel = 0;
  int wormCasting = 0;
  int marl = 0;

  Soil({
    required this.id,
    required this.peat,
    required this.cactusSoil,
    required this.akadama,
    required this.coconutFiber,
    required this.lapillus,
    required this.pumice,
    required this.sand,
    required this.zeolite,
    required this.perlite,
    required this.seramis,
    required this.gravel,
    required this.wormCasting,
    required this.marl,
  }) :
    assert(peat <= 100 && peat >= 0),
    assert(cactusSoil <= 100 && cactusSoil >= 0),
    assert(akadama <= 100 && akadama >= 0),
    assert(coconutFiber <= 100 && coconutFiber >= 0),
    assert(lapillus <= 100 && lapillus >= 0),
    assert(pumice <= 100 && pumice >= 0),
    assert(sand <= 100 && sand >= 0),
    assert(zeolite <= 100 && zeolite >= 0),
    assert(perlite <= 100 && perlite >= 0),
    assert(seramis <= 100 && seramis >= 0),
    assert(gravel <= 100 && gravel >= 0),
    assert(wormCasting <= 100 && wormCasting >= 0),
    assert(marl <= 100 && marl >= 0)
  {
    int total = 0;
    for (var v in [
      peat, cactusSoil, akadama, coconutFiber, lapillus, pumice,
      sand, zeolite, perlite, seramis, gravel, wormCasting, marl
    ]) {
      total += v;
    }

    if (total < 0 || total > 100) {
      throw RangeError('Total soil amount $total % != 100 %');
    }
  }

  Soil.fromMap(Map item):
    id=item["id"],
    peat=item["peat"]?.toInt(),
    cactusSoil=item["cactusSoil"]?.toInt(),
    akadama=item["akadama"]?.toInt(),
    coconutFiber=item["coconutFiber"]?.toInt(),
    lapillus=item["lapillus"]?.toInt(),
    pumice=item["pumice"]?.toInt(),
    sand=item["sand"]?.toInt(),
    zeolite=item["zeolite"]?.toInt(),
    perlite=item["perlite"]?.toInt(),
    seramis=item["seramis"]?.toInt(),
    gravel=item["gravel"]?.toInt(),
    wormCasting=item["wormCasting"]?.toInt(),
    marl=item["marl"]?.toInt()
  {
    int total = 0;
    for (var v in [
      peat, cactusSoil, akadama, coconutFiber, lapillus, pumice,
      sand, zeolite, perlite, seramis, gravel, wormCasting, marl
    ]) {
      total += v;
    }

    if (total < 0 || total > 100) {
      throw RangeError('Total soil amount $total % != 100 %');
    }
  }

  Map<String, num> toMap(){
    return {
      'id':id, 'peat':peat, 'cactusSoil':cactusSoil, 'akadama':akadama,
      'coconutFiber':coconutFiber, 'lapillus':lapillus, 'pumice':pumice,
      'sand':sand, 'zeolite':zeolite, 'perlite':perlite, 'seramis':seramis,
      'gravel':gravel, 'wormCasting':wormCasting, 'marl':marl
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Soil{id: $id}';
  }

  Map<String, int> getSoilComponents() {
    final Map<String, int> components = {};

    for (var item in {
      'peat':peat, 'cactusSoil':cactusSoil, 'akadama':akadama,
      'coconutFiber':coconutFiber, 'lapillus':lapillus, 'pumice':pumice,
      'sand':sand, 'zeolite':zeolite, 'perlite':perlite, 'seramis':seramis,
      'gravel':gravel, 'wormCasting':wormCasting, 'marl':marl
    }.entries) {
      if (item.value > 0) components[item.key] = item.value;
    }

    return components;
  }

  List getSortedSoilComponents() {
    final Map<String, int> components = getSoilComponents();
    var sortedEntries = components.entries.toList()..sort((e1, e2) {
      var diff = e2.value.compareTo(e1.value);
      if (diff == 0) diff = e2.key.compareTo(e1.key);
      return diff;
    });
    return sortedEntries;
  }

  static String selectAllQuery = '''
  SELECT
    [id], [peat], [cactusSoil], [akadama], [coconutFiber], [lapillus], [pumice],
    [sand], [zeolite], [perlite], [seramis], [gravel], [wormCasting], [marl]
  FROM [SoilMix]
  ORDER BY [id];
  ''';

  static String selectQuery = '''
  SELECT
    [id], [peat], [cactusSoil], [akadama], [coconutFiber], [lapillus], [pumice],
    [sand], [zeolite], [perlite], [seramis], [gravel], [wormCasting], [marl]
  FROM [SoilMix]
  WHERE [id] = ?1;
  ''';

  static Map<String, String>componentsNames = {
    'peat':'Peat', 'cactusSoil':'Cactus Mix', 'akadama':'Akadama',
    'coconutFiber':'Cocco', 'lapillus':'Lapillo', 'pumice':'Pomice',
    'sand':'Sabbia', 'zeolite':'Zeolite', 'perlite':'Perlite',
    'seramis':'Seramis', 'gravel':'Ghiaia', 'wormCasting':'Humus', 'marl':'Marna'
  };

  static String? mapComponentsNames(String key) {
    return componentsNames[key];
  }

  static Future<List<Soil>> fetchSoilList() async {
    final db = await DBService().db;
    final maps = await db.rawQuery(Soil.selectAllQuery);
    return maps.map((e) => Soil.fromMap(e)).toList();
  }
}

Future<Soil> fetchSoil(int soilId) async {
  final db = await DBService().db;
  final mapSoil = await db.rawQuery(Soil.selectQuery, [soilId]);
  return Soil.fromMap(mapSoil[0]);
}
