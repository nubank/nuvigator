part of 'module.dart';

extension FriendRequestParser on FriendRequestRoute {
  FriendRequestArgs _$parseParameters(Map<String, dynamic> map) {
    return FriendRequestArgs()
      ..numberOfRequests = map['numberOfRequests'] is String
          ? int.tryParse(map['numberOfRequests'])
          : map['numberOfRequests'];
  }
}
