import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/helpers/navigate_to_router.dart';

class Circle3dSecureWebView extends StatelessWidget {
  const Circle3dSecureWebView(this.url);

  final String url;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        navigateToRouter(context.read);
        return Future.value(true);
      },
      child: SPageFrame(
        header: SPaddingH24(
          child: SSmallHeader(
            titleAlign: TextAlign.left,
            icon: const SCloseIcon(),
            title: 'Webview',
            onBackButtonTap: () {
              navigateToRouter(context.read);
            },
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: WebView(
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
                navigationDelegate: (request) {
                  final uri = Uri.parse(request.url);

                  print(uri);

                  return NavigationDecision.navigate;
                  // final success = uri.queryParameters['success'];

                  // if (uri.origin == simplexOrigin) {
                  //   if (success == '1') {
                  //     // _showSuccess();
                  //     return NavigationDecision.prevent;
                  //   } else if (success == '2') {
                  //     // _showFailure();
                  //     return NavigationDecision.prevent;
                  //   } else {
                  //     return NavigationDecision.navigate;
                  //   }
                  // } else {
                  //   return NavigationDecision.navigate;
                  // }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
