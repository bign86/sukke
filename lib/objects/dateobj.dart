
class DateListItem{
  final int id;
  final int? water;
  final int? repot;
  final int? fertilize;
  final int? pests;

  DateListItem({
    required this.id,
    this.water,
    this.repot,
    this.fertilize,
    this.pests,
  });

  DateListItem.fromMap(Map item):
    id=item["id"],
    water=item["water"],
    repot=item["repot"],
    fertilize=item["fertilize"],
    pests=item["pests"];

  Map<String, int?> toMap(){
    return {
      'id':id, 'water':water, 'repot':repot, 'fertilize':fertilize, 'pests':pests
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Date{id: $id}';
  }
}
