import 'package:sukke/db.dart';

class Soil{
  final int id;
  double peat = 0;
  double cactusSoil = 0;
  double akadama = 0;
  double coconutFiber = 0;
  double lapillus = 0;
  double pumice = 0;
  double sand = 0;
  double zeolite = 0;
  double perlite = 0;
  double seramis = 0;
  double gravel = 0;
  double wormCasting = 0;
  double marl = 0;

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
    assert(peat <= 1.0 && peat >= 0.0),
    assert(cactusSoil <= 1.0 && cactusSoil >= 0.0),
    assert(akadama <= 1.0 && akadama >= 0.0),
    assert(coconutFiber <= 1.0 && coconutFiber >= 0.0),
    assert(lapillus <= 1.0 && lapillus >= 0.0),
    assert(pumice <= 1.0 && pumice >= 0.0),
    assert(sand <= 1.0 && sand >= 0.0),
    assert(zeolite <= 1.0 && zeolite >= 0.0),
    assert(perlite <= 1.0 && perlite >= 0.0),
    assert(seramis <= 1.0 && seramis >= 0.0),
    assert(gravel <= 1.0 && gravel >= 0.0),
    assert(wormCasting <= 1.0 && wormCasting >= 0.0),
    assert(marl <= 1.0 && marl >= 0.0)
  {
    double total = 0;
    for (var v in [
      peat, cactusSoil, akadama, coconutFiber, lapillus, pumice,
      sand, zeolite, perlite, seramis, gravel, wormCasting, marl
    ]) {
      total += v;
    }

    if (total < 0.0 || total > 1.0) {
      throw RangeError('Total soil amount $total > 1');
    }
  }

  Soil.fromMap(Map item):
    id=item["id"],
    peat=item["peat"]?.toDouble(),
    cactusSoil=item["cactusSoil"]?.toDouble(),
    akadama=item["akadama"]?.toDouble(),
    coconutFiber=item["coconutFiber"]?.toDouble(),
    lapillus=item["lapillus"]?.toDouble(),
    pumice=item["pumice"]?.toDouble(),
    sand=item["sand"]?.toDouble(),
    zeolite=item["zeolite"]?.toDouble(),
    perlite=item["perlite"]?.toDouble(),
    seramis=item["seramis"]?.toDouble(),
    gravel=item["gravel"]?.toDouble(),
    wormCasting=item["wormCasting"]?.toDouble(),
    marl=item["marl"]?.toDouble()
  {
    double total = 0;
    for (var v in [
      peat, cactusSoil, akadama, coconutFiber, lapillus, pumice,
      sand, zeolite, perlite, seramis, gravel, wormCasting, marl
    ]) {
      total += v;
    }

    if (total < 0.0 || total > 1.0) {
      throw RangeError('Total soil amount $total > 1');
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

  Map<String, double> getSoilComponents() {
    final Map<String, double> components = {};

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
    final Map<String, double> components = getSoilComponents();
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
