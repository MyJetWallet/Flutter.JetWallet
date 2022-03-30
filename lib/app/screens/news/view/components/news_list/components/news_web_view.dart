import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/navigator_push.dart';

class NewsWebView extends HookWidget {
  const NewsWebView({
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
      NewsWebView(
        link: link,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      header: const SPaddingH24(
        child: SSmallHeader(
          icon: SCloseIcon(),
          title: 'Simplex',
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
