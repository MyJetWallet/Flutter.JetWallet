import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';

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
    _firebaseDynamicLinks.onLink.listen(
      (data) async {
        _handleDynamicLink(data, handler);
      },
    ).onError(
      (error) {
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
