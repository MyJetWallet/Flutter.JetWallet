import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../core/l10n/i10n.dart';

@RoutePage(name: 'InfoWebViewRouter')
class InfoWebView extends StatefulWidget {
  const InfoWebView({
    super.key,
    required this.link,
    required this.title,
  });

  final String link;
  final String title;

  @override
  State<InfoWebView> createState() => _InfoWebViewState();
}

class _InfoWebViewState extends State<InfoWebView> {
  late WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadRequest(Uri.parse(widget.link));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: widget.title,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: WebViewWidget(
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}
