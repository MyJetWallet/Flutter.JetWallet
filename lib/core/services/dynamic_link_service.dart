import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/deep_link_service.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';

class DynamicLinkService {
  //getIt.get<DeepLinkService>().handle

  final _logger = Logger('');
  final _firebaseDynamicLinks = FirebaseDynamicLinks.instance;

  Future<void> initDynamicLinks() async {
    // Get the initial dynamic link if the app is opened with a dynamic link
    final data = await _firebaseDynamicLinks.getInitialLink();

    // ignore: prefer_function_declarations_over_variables
    final Function(Uri) handler = (link) {
      getIt.get<DeepLinkService>().handle(link, fromBG: false);
    };

    // ignore: prefer_function_declarations_over_variables
    final Function(Uri) handlerWithBG = (link) {
      getIt.get<DeepLinkService>().handle(link, fromBG: true);
    };

    _handleDynamicLink(data, handlerWithBG);

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
