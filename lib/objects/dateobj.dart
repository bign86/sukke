
class DateListItem{
  final int id;
  final String name;
  final int? water;
  final int? fertilize;

  DateListItem({
    required this.id,
    required this.name,
    this.water,
    this.fertilize,
  });

  DateListItem.fromMap(Map item):
    id=item["id"],
    name=item["name"],
    water=item["water"],
    fertilize=item["fertilize"];

  Map<String, dynamic> toMap(){
    return {
      'id':id, 'name':name.toString(), 'water':water, 'fertilize':fertilize
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Date{id: $id}';
  }
}
