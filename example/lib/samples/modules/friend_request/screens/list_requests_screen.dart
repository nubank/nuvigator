import 'package:example/samples/modules/friend_request/bloc/friend_request_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListRequestScreen extends StatelessWidget {
  const ListRequestScreen({
    Key key,
    @required this.toSuccess,
  }) : super(key: key);

  final VoidCallback toSuccess;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<FriendRequestBloc>(context);
    final bodyStyle = Theme.of(context).textTheme.bodyText1;
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: toSuccess,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: 11,
        itemBuilder: (context, index) {
          if (index == 0) {
            return ListTile(
              title: Text(
                "Received numberOfRequests: ${args['numberOfRequests']} from deepLink",
                style: bodyStyle,
              ),
            );
          }
          return ListTile(
            title: Text('Request $index'),
            trailing: Switch(
              value: bloc.accepted[index - 1],
              onChanged: (value) => bloc.updateRequest(index - 1, value),
            ),
          );
        },
      ),
    );
  }
}
