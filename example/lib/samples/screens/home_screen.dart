import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('BUILDING HOME');
    final nuvigator = Nuvigator.of(context);
    final headingStle = Theme.of(context).textTheme.headline3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuvigator Example'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const Hero(
                  tag: 'HERO',
                  child: FlutterLogo(
                    size: 96,
                  ),
                ),
                Text(
                  'Nuvigator V2',
                  style: headingStle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                RaisedButton(
                  child: const Text('Review friend requests'),
                  onPressed: () {
                    nuvigator.openDeepLink<void>(Uri.parse(
                        'exapp://friend-requests?numberOfRequests=10'));
                  },
                ),
                RaisedButton(
                  child: const Text('Compose a message'),
                  onPressed: () async {
                    String text;

                    text = await nuvigator.openDeepLink<String>(Uri.parse(
                      'exapp://composer/text?initialText=Hello+deep+link%21',
                    ));

                    if (text != null) {
                      // ignore: unawaited_futures
                      showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Composed message'),
                          content: Text(text),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 48),
                const Text(
                  '"Review friend requests" navigates via a nested nuvigator to its initial route, and the routes can close their entire flow in the end.',
                ),
                const SizedBox(height: 8),
                const Text(
                  '"Compose a message" navigates via a grouped router, and all its routes can be accessed directly from here.',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
