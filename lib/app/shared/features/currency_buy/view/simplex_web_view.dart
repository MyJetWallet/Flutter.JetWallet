import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../screens/navigation/provider/navigation_stpod.dart';

class SimplexWebView extends StatefulHookWidget {
  const SimplexWebView(this.url);

  final String url;

  @override
  SimplexWebViewState createState() => SimplexWebViewState();
}

class SimplexWebViewState extends State<SimplexWebView> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    void _showSuccess() {
      context.read(navigationStpod).state = 1; // Portfolio
      SuccessScreen.push(
        context: context,
        secondaryText: 'Your payment has been processed',
      );
    }

    void _showFailure() {
      FailureScreen.push(
        context: context,
        primaryText: 'Failure',
        secondaryText: 'Failed to buy',
        primaryButtonName: 'Edit Order',
        onPrimaryButtonTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
        secondaryButtonName: 'Close',
        onSecondaryButtonTap: () => navigateToRouter(context.read),
      );
    }

    return Column(
      children: [
        Container(
          height: 48.0,
          color: colors.white,
        ),
        Expanded(
          child: WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (request) {
              final uri = Uri.parse(request.url);
              final success = uri.queryParameters['success'];

              if (uri.origin == simplexOrigin) {
                if (success == '1') {
                  _showSuccess();
                  return NavigationDecision.prevent;
                } else if (success == '2') {
                  _showFailure();
                  return NavigationDecision.prevent;
                } else {
                  return NavigationDecision.navigate;
                }
              } else {
                return NavigationDecision.navigate;
              }
            },
          ),
        ),
      ],
    );
  }
}
