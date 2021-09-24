import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final onNext;

  HomeScreen({
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Nuvigator router example"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'What\'s your name?',
                style: TextStyle(
                    fontSize: 25
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: _nameController,
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                child: Text(
                 'Next',
                  style: TextStyle(
                    fontSize: 25
                  ),
                ),
                onPressed: () => onNext(_nameController.value.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}