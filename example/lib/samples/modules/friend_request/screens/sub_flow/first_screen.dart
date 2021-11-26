import 'package:flutter/material.dart';
import 'package:nuvigator/next.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          child: Column(
            children: [
              const Center(child: Text('Some random Screen here')),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => Nuvigator.of(context).pushNamed('sub_flow/second_screen'),
                      child: const Text('Next screen'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
