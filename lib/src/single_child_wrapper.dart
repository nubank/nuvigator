import 'package:flutter/widgets.dart';

/// Interface for a wrapper object that, if provided, will be used to
/// wrap the [child] widget before navigating to it.  Allows for propagating
/// state forward across a navigation boundary, as the widget tree does not
/// nest when navigating.
abstract class SingleChildWrapper {
  Widget buildWithChild(BuildContext context, Widget child);
}
