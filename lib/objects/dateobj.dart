
import 'package:flutter/material.dart';
import 'package:sukke/theme/elements.dart';


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

class DateSelectionWidget extends StatefulWidget {
  const DateSelectionWidget({super.key, required this.month, required this.day});

  final int month;
  final int day;

  @override
  State<DateSelectionWidget> createState() => _DateSelectionWidgetState();
}

class _DateSelectionWidgetState extends State<DateSelectionWidget> {
  final _monthController = TextEditingController();
  late int _selectedMonth;
  late int _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.month;
    _selectedDay = widget.day;
  }

  final List<DropdownMenuEntry<int>> _months = [
    DropdownMenuEntry(value: 1, label: 'January'),
    DropdownMenuEntry(value: 2, label: 'February'),
    DropdownMenuEntry(value: 3, label: 'March'),
    DropdownMenuEntry(value: 4, label: 'April'),
    DropdownMenuEntry(value: 5, label: 'May'),
    DropdownMenuEntry(value: 6, label: 'June'),
    DropdownMenuEntry(value: 7, label: 'July'),
    DropdownMenuEntry(value: 8, label: 'August'),
    DropdownMenuEntry(value: 9, label: 'September'),
    DropdownMenuEntry(value: 10, label: 'October'),
    DropdownMenuEntry(value: 11, label: 'November'),
    DropdownMenuEntry(value: 12, label: 'December'),
  ];

  List<int> _getDaysInMonth(int month) {
    int year = DateTime.now().year; // Use current year for leap year check
    int days = DateTime(year, month, 0).day;
    return List<int>.generate(days, (i) => i + 1);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DialogThemeData dialogTheme = DialogTheme.of(context);
    List<int> daysInSelectedMonth = _getDaysInMonth(_selectedMonth);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
      backgroundColor: dialogTheme.backgroundColor,
      alignment: dialogTheme.alignment ?? Alignment.center,
      surfaceTintColor: dialogTheme.surfaceTintColor,
      child: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          padding: padAll20,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Month Dropdown
              DropdownMenu<int>(
                enableFilter: false,
                enableSearch: false,
                initialSelection: _selectedMonth,
                controller: _monthController,
                requestFocusOnTap: true,
                label: const Text('Month'),
                onSelected: (month) {
                  setState(() {_selectedMonth = month!;});
                },
                dropdownMenuEntries: _months,
                textStyle: theme.textTheme.bodyMedium,
              ),
              hBox20,
              // Day Dropdown
              DropdownButton<int>(
                hint: const Text('Day'),
                value: _selectedDay,
                style: theme.textTheme.bodyMedium,
                onChanged: (int? newValue) {
                  if (newValue == null) return;
                  setState(() {_selectedDay = newValue;});
                },
                items: daysInSelectedMonth.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
              hBox20,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _handleOk,
                    child: const Text('Select'),
                  ),
                  ElevatedButton(
                    onPressed: _handleCancel,
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          )
        )
      )
    );
  }

  void _handleOk() {
    String month = _selectedMonth.toString().padLeft(2, '0');
    String day = _selectedDay.toString().padLeft(2, '0');

    Navigator.pop(context, '$month-$day');
  }

  void _handleCancel() {
    Navigator.pop(context, null);
  }

}

