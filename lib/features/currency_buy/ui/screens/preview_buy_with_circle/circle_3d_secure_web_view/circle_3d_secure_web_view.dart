// ignore_for_file: missing_whitespace_between_adjacent_strings, lines_longer_than_80_chars

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'Circle3dSecureWebViewRouter')
class Circle3dSecureWebView extends StatelessWidget {
  const Circle3dSecureWebView(
    this.title,
    this.url,
    this.asset,
    this.amount,
    this.onSuccess,
    this.onCancel,
    this.paymentId,
    this.onFailed,
  );

  final String title;
  final String url;
  final String asset;
  final String amount;
  final String paymentId;
  final Function(String, String) onSuccess;
  final Function(String) onFailed;
  final Function(String?)? onCancel;

  @override
  Widget build(BuildContext context) {
    late WebViewController controllerWeb;

    return PopScope(
      onPopInvoked: (_) {
        onCancel?.call(null);

        Future.value(true);
      },
      child: SPageFrame(
        loaderText: intl.register_pleaseWait,
        header: SPaddingH24(
          child: SSmallHeader(
            titleAlign: TextAlign.left,
            icon: const SCloseIcon(),
            title: title,
            onBackButtonTap: () {
              onCancel?.call(null);
              navigateToRouter();
            },
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: WebView(
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

                  if (uri.path == '/circle/failure' || uri.path == '/unlimint/failure') {
                    onFailed(intl.something_went_wrong);

                    return NavigationDecision.navigate;
                  } else if (uri.path == '/circle/success' || uri.path == '/unlimint/success') {
                    onSuccess(paymentId, url);

                    return NavigationDecision.navigate;
                  } else if (uri.path == '/unlimint/cancel') {
                    onCancel?.call(paymentId);

                    return NavigationDecision.navigate;
                  } else if (uri.path == '/unlimint/inprocess' || uri.path == '/unlimint/return') {
                    onSuccess(paymentId, url);

                    return NavigationDecision.navigate;
                  } else if (uri.path.startsWith('text/html')) {
                    return NavigationDecision.prevent;
                  }

                  return NavigationDecision.navigate;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
