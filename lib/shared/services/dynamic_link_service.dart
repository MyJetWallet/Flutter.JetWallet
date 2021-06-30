import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:logging/logging.dart';

import '../logging/levels.dart';

class DynamicLinkService {
  final _logger = Logger('');
  final _firebaseDynamicLinks = FirebaseDynamicLinks.instance;

  Future<void> initDynamicLinks({
    required void Function(Uri) handler,
  }) async {
    // Get the initial dynamic link if the app is opened with a dynamic link
    final data = await _firebaseDynamicLinks.getInitialLink();

    _handleDynamicLink(data, handler);

    // Register a link callback to fire if the app is opened up
    // from the background using a dynamic link.
    _firebaseDynamicLinks.onLink(
      onSuccess: (data) async {
        _handleDynamicLink(data, handler);
      },
      onError: (error) async {
        _logger.log(dynamicLinks, 'Dynamic Link Failed', error);
      },
    );
  }

  void _handleDynamicLink(
    PendingDynamicLinkData? data,
    void Function(Uri) handler,
  ) {
    final link = data?.link;

    if (link != null) {
      _logger.log(dynamicLinks, '$link');
      handler(link);
    }
  }
}
