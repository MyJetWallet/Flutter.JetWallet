import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/helpers/navigator_push.dart';
import '../../../../shared/providers/service_providers.dart';

class HelpCenterWebView extends StatefulWidget {
  const HelpCenterWebView({
    Key? key,
    required this.link,
  }) : super(key: key);

  final String link;

  static void push({
    required BuildContext context,
    required String link,
  }) {
    navigatorPush(
      context,
      HelpCenterWebView(link: link),
    );
  }

  @override
  State<HelpCenterWebView> createState() => _HelpCenterWebViewState();
}

class _HelpCenterWebViewState extends State<HelpCenterWebView> {
  late WebViewController controller;

  @override
  Widget build(BuildContext context) {
    final intl = context.read(intlPod);

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.helpCenterWebView,
          onBackButtonTap: () async {
            if (await controller.canGoBack()) {
              await controller.goBack();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: WebView(
              initialUrl: widget.link,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                this.controller = controller;
              },
            ),
          ),
        ],
      ),
    );
  }
}
