import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class PlantLinksEditPage extends StatefulWidget {
  const PlantLinksEditPage({
    super.key, required this.links   // fields
  });

  final List<String> links;

  @override
  State<PlantLinksEditPage> createState() => _PlantLinksEditPageState();
}

class _PlantLinksEditPageState extends State<PlantLinksEditPage> {
  List<String> newLinks = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    newLinks = List<String>.from(widget.links);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text('Edit - Links',),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              Navigator.of(context).pop(newLinks);
            },
          ),
        ],
      ),
      body: CupertinoScrollbar(
        child: Column(
          children: [
            const SizedBox(height: 20),
            IconButton(
              onPressed: () async {
                addLinkDialog();
              },
              icon: const Icon(Icons.add_circle_outline),
              iconSize: 60,
              color: Colors.black45,
            ),
            const SizedBox(height: 15),
            Form(
              key: _formKey,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: newLinks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          iconSize: 16,
                          color: Colors.red[800],
                          onPressed: () {
                            removeLinkDialog(index);
                          },
                        )
                      ),
                      Expanded(
                        flex: 9,
                        child: Text(newLinks[index]),
                      ),
                    ],
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> addLinkDialog() async {
    TextEditingController controller = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Link',),
        content: Column(
          //clipBehavior: Clip.none,
          children: <Widget>[
            Form(
              //key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: controller,
                  autocorrect: true,
                  autofocus: true,
                  maxLines: 4,
                  minLines: 1,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  child: const Text('Close'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                OutlinedButton(
                  child: const Text('Save'),
                  onPressed: () {
                    setState(() {
                      newLinks.add(controller.text);
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> removeLinkDialog(int index) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Link',),
        content:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            OutlinedButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  newLinks.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
