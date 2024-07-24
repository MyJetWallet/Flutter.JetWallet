import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'HelpCenterWebViewRouter')
class HelpCenterWebView extends StatefulWidget {
  const HelpCenterWebView({
    super.key,
    required this.link,
    this.title,
  });

  final String link;
  final String? title;

  @override
  State<HelpCenterWebView> createState() => _HelpCenterWebViewState();
}

class _HelpCenterWebViewState extends State<HelpCenterWebView> {
  late WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: widget.title ?? intl.helpCenterWebView,
          onBackButtonTap: () {
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      child: WebView(
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}..add(
            Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer(),
            ),
          ),
        initialUrl: widget.link,
        gestureNavigationEnabled: true,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          this.controller = controller;
        },
      ),
    );
  }
}
