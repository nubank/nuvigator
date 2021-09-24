import 'package:flutter/material.dart';

class NameScreen extends StatelessWidget {
  final String name;
  final nuvigator;

  NameScreen({
    @required this.nuvigator,
    @required this.name,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController _ageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Name screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
               'Hello, $name!\nInsert your age:',
                style: TextStyle(
                  fontSize: 25
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _ageController,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text(
                'Next',
                style: TextStyle(
                    fontSize: 25
                ),
              ),
              onPressed: () async {

                /// This is an example how to call a new screen passing and receiving parameters through deeplinks
                final result = await nuvigator
                    .open('myapp://age?param=${_ageController.text}');

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Route Closed'),
                      content: Text('Value Returned: $result'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}