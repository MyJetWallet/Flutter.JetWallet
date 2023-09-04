import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'HelpCenterWebViewRouter')
class HelpCenterWebView extends StatefulWidget {
  const HelpCenterWebView({
    super.key,
    required this.link,
  });

  final String link;

  @override
  State<HelpCenterWebView> createState() => _HelpCenterWebViewState();
}

class _HelpCenterWebViewState extends State<HelpCenterWebView> {
  late WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: SPageFrame(
        loaderText: intl.register_pleaseWait,
        header: SPaddingH24(
          child: SSmallHeader(
            title: intl.helpCenterWebView,
            onBackButtonTap: () => _onWillPop(),
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
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (await controller.canGoBack()) {
      await controller.goBack();
    } else {
      if (context.mounted) {
        Navigator.pop(context);
      }
    }

    return Future.value(false);
  }
}
