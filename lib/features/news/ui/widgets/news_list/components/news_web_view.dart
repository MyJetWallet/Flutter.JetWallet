import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:simple_kit/simple_kit.dart';

class NewsWebView extends StatelessWidget {
  const NewsWebView({
    Key? key,
    required this.link,
    required this.topic,
  }) : super(key: key);

  final String link;
  final String topic;

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
