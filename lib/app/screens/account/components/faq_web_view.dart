import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/helpers/navigator_push.dart';

class FaqWebView extends StatelessWidget {
  const FaqWebView({
    Key? key,
    required this.link,
  }) : super(key: key);

  final String link;

  static void push(
      BuildContext context,
      String link,
      ) {
    navigatorPush(
      context,
      FaqWebView(link: link),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      header: const SPaddingH24(
        child: SSmallHeader(
          title: 'FAQ',
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
