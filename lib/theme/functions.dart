import 'package:flutter/material.dart';
import 'package:sukke/theme/theme.dart';
import 'package:sukke/theme/elements.dart';


Icon createCheckIcon(bool value) {
  return value
      ? const Icon(
    Icons.check,
    color: Colors.green,
  )
      : const Icon(
    Icons.close,
    color: Colors.red,
  );
}

Text createSimpleBodyText(String textString, bool center) {
  return Text(
    textString,
    textAlign: center ? TextAlign.center : TextAlign.left,
    style: textTheme.bodyMedium,
  );
}

Text createSectionHeaderText(String textString) {
  return Text(
    textString,
    textAlign: TextAlign.center,
    style: textTheme.headlineMedium,
  );
}

Text createKeyValueItem(String key, String value, {TextAlign textAlign = TextAlign.justify}) {
  return Text.rich(
      textAlign: textAlign,
      TextSpan(
          children: [
            TextSpan(
              text: key,
              style: keywordStyle,
            ),
            TextSpan(text: value,),
          ]
      )
  );
}

SnackBar createErrorSnackBar(String error, {Color? color}) {
  return SnackBar(
    duration: errorDuration,
    backgroundColor: color ?? statusBad,
    content: createSimpleBodyText(error, false),
  );
}

Row createTextEntryRow({
  required String title,
  required TextEditingController controller,
  required int flexLabel,
  required int flexText,
  bool readOnly = false
}) {
  return Row(
    children: [
      Expanded(
        flex: flexLabel,
        child: createSimpleBodyText(title, false),
      ),
      Expanded(
        flex: flexText,
        child: TextField(
          controller: controller,
          style: textTheme.bodyMedium,
          autofocus: false,
          autocorrect: false,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 2,
          readOnly: readOnly,
        ),
      ),
    ],
  );
}


