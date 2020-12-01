// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nu_module_example.dart';

// **************************************************************************
// NextGenerator
// **************************************************************************

extension FriendRequestArgsParser on FriendRequestRouteExample {
  FriendRequestArgs _$parseParameters(Map<String, dynamic> map) {
    return FriendRequestArgs()
      ..numberOfRequests = map['numberOfRequests'] is String
          ? int.tryParse(map['numberOfRequests'])
          : map['numberOfRequests']
      ..precision = map['precision'] is String
          ? double.tryParse(map['precision'])
          : map['precision']
      ..name = map['name']
      ..age = map['age'] is String ? int.tryParse(map['age']) : map['age'];
  }
}
