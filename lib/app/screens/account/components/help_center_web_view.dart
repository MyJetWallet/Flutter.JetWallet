import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/helpers/navigator_push.dart';
import '../../../../shared/providers/service_providers.dart';

class HelpCenterWebView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final intl = context.read(intlPod);

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.help_center,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: WebView(
              initialUrl: link,
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
        ],
      ),
    );
  }
}
