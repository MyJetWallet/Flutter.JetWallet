//import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'dart:async';

import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/deep_link_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:logger/logger.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

class DynamicLinkService {
  //getIt.get<DeepLinkService>().handle
  //final _firebaseDynamicLinks = FirebaseDynamicLinks.instance;

  Future<void> initDynamicLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final initialLink = await getInitialUri();

      getIt.get<SimpleLoggerService>().log(
        level: Level.warning,
        place: 'DynamicLinkService',
        message: '_handleDynamicLink: $initialLink',
      );


      getIt.get<DeepLinkService>().handle(initialLink!, fromBG: true);
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }

    StreamSubscription _sub;

    _sub = uriLinkStream.listen((Uri? uri) {
      getIt.get<SimpleLoggerService>().log(
        level: Level.warning,
        place: 'DynamicLinkService listen',
        message: '_handleDynamicLink: $uri',
      );

      getIt.get<DeepLinkService>().handle(uri!, fromBG: true);

    }, onError: (err) {
      getIt.get<SimpleLoggerService>().log(
        level: Level.error,
        place: 'DynamicLinkService listen',
        message: '_handleDynamicLink: $err',
      );

      // Handle exception by warning the user their action did not succeed
    });


    /*
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
        getIt.get<SimpleLoggerService>().log(
              level: Level.error,
              place: 'DynamicLinkService',
              message: 'Dynamic Link Failed $error',
            );
      },
    );
    */
  }

  /*
  void _handleDynamicLink(
    PendingDynamicLinkData? data,
    void Function(Uri) handler,
  ) {
    final link = data?.link;

    if (link != null) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'DynamicLinkService',
            message: '_handleDynamicLink: $link',
          );

      handler(link);
    }
  }
  */
}