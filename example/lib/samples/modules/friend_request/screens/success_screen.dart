import 'package:example/samples/modules/friend_request/bloc/friend_request_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    Key key,
    @required this.closeFlow,
    @required this.toComposeText,
  }) : super(key: key);

  final VoidCallback closeFlow;
  final VoidCallback toComposeText;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<FriendRequestBloc>(context);
    final headingStle = Theme.of(context).textTheme.headline4;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Success'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Hero(
                  tag: 'HERO',
                  child: FlutterLogo(
                    size: 96,
                  ),
                ),
                Text(
                  'Accepted ${bloc.numberOfAcceptedRequests} requests',
                  style: headingStle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                RaisedButton(
                  onPressed: closeFlow,
                  child: const Text('Close flow'),
                ),
                RaisedButton(
                  onPressed: toComposeText,
                  child: const Text('Compose a message'),
                ),
                const SizedBox(height: 48),
                const Text(
                  '"Close flow" will dismiss this entire flow, which will take you back to where you were before opening this flow.',
                ),
                const SizedBox(height: 8),
                const Text(
                  '"Compose a message" will call a route from the parent router, via the context, using pushReplacement. Because of this, when you dismiss it, it will go back to the Home screen instead of this screen.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
