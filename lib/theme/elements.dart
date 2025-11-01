import 'package:flutter/material.dart';
import 'package:sukke/theme/theme.dart';

// Vertical boxes
const vBox5 = SizedBox(height: 5);
const vBox10 = SizedBox(height: 10);
const vBox15 = SizedBox(height: 15);
const vBox20 = SizedBox(height: 20);
const vBox30 = SizedBox(height: 30);
const hBox5 = SizedBox(width: 5);
const hBox10 = SizedBox(width: 10);
const hBox15 = SizedBox(width: 15);
const hBox20 = SizedBox(width: 20);
const hBox30 = SizedBox(width: 30);

// Horizontal dividers
const dividerGray10 = Divider(
  height: 10,
  thickness: 1,
  indent: 8,
  endIndent: 8,
  color: Colors.black45,
);
const dividerGray20 = Divider(
  height: 20,
  thickness: 1,
  indent: 20,
  endIndent: 20,
  color: Colors.black38,
);

// Padding
const padAll5 = EdgeInsets.all(5);
const padAll8 = EdgeInsets.all(8);
const padAll10 = EdgeInsets.all(10);
const padAll12 = EdgeInsets.all(12);
const padAll20 = EdgeInsets.all(20);

const padLR8 = EdgeInsets.symmetric(horizontal: 8);
const padLR10 = EdgeInsets.symmetric(horizontal: 10);
const padLR12 = EdgeInsets.symmetric(horizontal: 12);
const padLR16 = EdgeInsets.symmetric(horizontal: 16);

// Borders
const borderR8 = BorderRadius.all(Radius.circular(8));
const borderR10 = BorderRadius.all(Radius.circular(10));
const borderR12 = BorderRadius.all(Radius.circular(12));

// Durations
const errorDuration = Duration(seconds: 3);

// Colors
Color? statusGood = Colors.green[700];
Color? statusWarn = Colors.amber[700];
Color? statusBad = Colors.red[700];

// Icons
Icon editIcon = const Icon(Icons.edit, size: 15, color: COLOR_PRIMARY,);
Icon coldIcon = const Icon(Icons.edit, size: 24,);
Icon waterIcon = const Icon(Icons.edit, size: 24,);

// TextStyles
TextStyle keywordStyle = TextStyle(
  fontSize: textTheme.bodyMedium?.fontSize,
  fontStyle: FontStyle.italic,
);

