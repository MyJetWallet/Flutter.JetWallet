import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:simple_kit/simple_kit.dart';

class InfoWebView extends StatelessWidget {
  const InfoWebView({
    Key? key,
    required this.link,
    required this.title,
  }) : super(key: key);

  final String link;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: title,
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
