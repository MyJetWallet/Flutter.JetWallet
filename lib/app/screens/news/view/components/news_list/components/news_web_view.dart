import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/navigator_push.dart';

class NewsWebView extends HookWidget {
  const NewsWebView({
    Key? key,
    required this.link,
    required this.topic,
  }) : super(key: key);

  final String link;
  final String topic;

  static void push(
    BuildContext context,
    String link,
    String topic,
  ) {
    navigatorPush(
      context,
      NewsWebView(
        link: link,
        topic: topic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          icon: const SCloseIcon(),
          title: topic,
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
