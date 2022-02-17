import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_analytics/simple_analytics.dart';

/// Works like an initState inside a build method of the widget
void analytics(Function() function) {
  useEffect(
    () {
      function();
      return null;
    },
    [sAnalytics],
  );
}
