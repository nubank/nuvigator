/// Annotation used to define a module parser
///
/// This annotation is used by the code generator to identify a class that
/// represents the arguments for the NuRoute and start the analysis of code generation.
///
/// By default, the [NuRouteParser] generates an extension function that
/// allow translating a map into a class that represents the argument for the module:
///
/// {@tool sample}
/// This sample shows how to create a parser using [NuRouteParser] annotation.
///
/// ```dart
/// class FriendRequestArgs {
///  int numberOfRequests;
///  double precision;
///  String name;
///  int age;
///}
///
/// @NuRouteParser()
/// class FriendRequestRoute extends NuRoute<NuModule, FriendRequestArgs, void> {
///   @override
///   FriendRequestArgs parseParameters(Map<String, dynamic> map) =>  _$parseParameters(map);
/// }
/// ```
/// {@end-tool}
///
/// The generated code will be:
///
/// ```dart
///extension FriendRequestArgsParser on FriendRequestRoute {
///FriendRequestArgs _$parseParameters(Map<String, dynamic> map) {
///    return FriendRequestArgs()
///         ..numberOfRequests = map['numberOfRequests'] is String
///         ? int.tryParse(map['numberOfRequests'])
///         : map['numberOfRequests']
///         ..precision = map['precision'] is String
///         ? double.tryParse(map['precision'])
///         : map['precision']
///         .name = map['name']
///         ..age = map['age'] is String ? int.tryParse(map['age']) : map['age'];
/// }
///}
/// ```
/// Obs: The annotation generates an extension function only for the second type parameter
/// of the NuRoute class.
class NuRouteParser {
  const NuRouteParser();
}
