import 'package:flutter/widgets.dart';

abstract class SingleChildWrapper {
  Widget buildWithChild(BuildContext context, Widget? child);
}
