

enum Event {
  water(id_: 'water', title_: 'Water'),
  fertilize(id_: 'fertilize', title_: 'Fertilize'),
  pests(id_: 'pests', title_: 'Pests'),
  repot(id_: 'repot', title_: 'Repot');

  const Event({
    required this.id_,
    required this.title_,
  });

  final String id_;
  final String title_;

  String get id => id_;
  String get title => title_;

  String qInsert() => "INSERT INTO Events (id, event, date) VALUES (?1, 'water', ?2);";
}


