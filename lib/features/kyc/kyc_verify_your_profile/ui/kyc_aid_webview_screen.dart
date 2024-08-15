// ignore_for_file: missing_whitespace_between_adjacent_strings

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/intercom/intercom_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'KycAidWebViewRouter')
class KycAidWebViewScreen extends StatelessWidget {
  const KycAidWebViewScreen({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    late WebViewController controllerWeb;

    return SPageFrame(
      loaderText: '',
      header: SimpleLargeAppbar(
        title: intl.kyc_identity_verification,
        hasRightIcon: true,
        rightIcon: SafeGesture(
          onTap: () async {
            if (showZendesk) {
              await getIt.get<IntercomService>().showMessenger();
            } else {
              await sRouter.push(
                CrispRouter(
                  welcomeText: intl.crispSendMessage_hi,
                ),
              );
            }
          },
          child: Assets.svg.medium.chat.simpleSvg(),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: WebView(
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}..add(
                  Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer(),
                  ),
                ),
              gestureNavigationEnabled: true,
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                controllerWeb = controller;
              },
              onPageFinished: (url) {
                controllerWeb.runJavascript('function toMobile(){'
                    "var meta = document.createElement('meta'); "
                    "meta.setAttribute('name', 'viewport');"
                    " meta.setAttribute('content', 'width=device-width, initial-scale=1'); "
                    "var head= document.getElementsByTagName('head')[0];"
                    'head.appendChild(meta); '
                    '}'
                    'toMobile()');
              },
              navigationDelegate: (request) {
                final uri = Uri.parse(request.url);
                if (uri.path == '/success' || uri.path == '/blog/') {
                  sRouter.push(
                    SuccessScreenRouter(),
                  );
                  return NavigationDecision.navigate;
                }

                return NavigationDecision.navigate;
              },
            ),
          ),
        ],
      ),
    );
  }
}
