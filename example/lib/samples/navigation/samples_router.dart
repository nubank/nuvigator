import 'package:routing/routing.dart';

import '../../main.dart';
import '../modules/sample_one/navigation/sample_one_router.dart';

class _SamplesRouter extends GroupRouter {
  @override
  String get deepLinkPrefix => 'deepprefix';

  @override
  Map<String, Screen> get screensMap => {
    'home': Screen<void>.page((screenContext) => HomeScreen(screenContext)),
  };

  @override
  List<Router> get routers => [
    sampleOneRouter,
  ];
}

final samplesRouter = _SamplesRouter();