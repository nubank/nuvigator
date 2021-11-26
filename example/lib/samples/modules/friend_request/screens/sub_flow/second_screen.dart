import 'package:flutter/material.dart';
import 'package:nuvigator/next.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({
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
              const Center(child: Text('Another random screen')),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => Nuvigator.of(context).open(
                        'exapp://sub_flow/third_screen',
                      ),
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
