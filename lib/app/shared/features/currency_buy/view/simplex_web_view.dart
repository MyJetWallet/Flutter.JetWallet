import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../screens/navigation/provider/navigation_stpod.dart';

class SimplexWebView extends HookWidget {
  const SimplexWebView(this.url);

  final String url;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    useEffect(
      () {
        if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
        sAnalytics.simplexView(url);
        return null;
      },
      [],
    );

    void _showSuccess() {
      SuccessScreen.push(
        context: context,
        secondaryText:
            '${intl.simplexWebView_successScreenSecondaryText1}\n≈ 10-30 ${intl.minutes}',
        then: () => context.read(navigationStpod).state = 1,
      );
      sAnalytics.simplexSucsessView(url);
    }

    void _showFailure() {
      FailureScreen.push(
        context: context,
        primaryText: intl.failure,
        secondaryText: intl.failedToBuy,
        primaryButtonName: intl.editOrder,
        onPrimaryButtonTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
        secondaryButtonName: intl.close,
        onSecondaryButtonTap: () => navigateToRouter(context.read),
      );
      sAnalytics.simplexFailureView(url);
    }

    return WillPopScope(
      onWillPop: () {
        navigateToRouter(context.read);
        return Future.value(true);
      },
      child: SPageFrame(
        header: SPaddingH24(
          child: SSmallHeader(
            titleAlign: TextAlign.left,
            icon: const SCloseIcon(),
            title: intl.simplex,
            onBackButtonTap: () {
              navigateToRouter(context.read);
            },
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: WebView(
                initialUrl: url,
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
        ),
      ),
    );
  }
}
