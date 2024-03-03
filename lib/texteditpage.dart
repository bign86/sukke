import 'package:flutter/material.dart';


class TextEditPage extends StatefulWidget {
  const TextEditPage({
    super.key, required this.title, required this.text
  });

  final String title;
  final String text;

  @override
  State<TextEditPage> createState() => _TextEditPageState();
}

class _TextEditPageState extends State<TextEditPage> {
  TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    controller.text = widget.text;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text('Edit - ${widget.title}',),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              String? text = controller.text;
              if (text == '') {
                text = null;
              }
              Navigator.of(context).pop(text);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
            child: TextField(
              key: _formKey,
              controller: controller,
              style: const TextStyle(fontSize: 12,),
              autofocus: true,
              autocorrect: false,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
            ),
          ),
        ),
      );
  }

}