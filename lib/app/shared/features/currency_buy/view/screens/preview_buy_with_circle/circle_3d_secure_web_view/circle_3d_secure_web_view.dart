import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../../screens/navigation/provider/navigation_stpod.dart';

class Circle3dSecureWebView extends HookWidget {
  const Circle3dSecureWebView(
    this.url,
    this.asset,
    this.amount,
  );

  final String url;
  final String asset;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

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
            title: intl.previewBuyWithCircle_paymentVerification,
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

                  if (uri.path == '/circle/success') {
                    sAnalytics.circleSuccess(
                      asset: asset,
                      amount: amount,
                      frequency: RecurringFrequency.oneTime,
                    );
                    SuccessScreen.push(
                      context: context,
                      secondaryText:
                          '${intl.buyWithCircle_paymentWillBeProcessed} \n'
                          ' ≈ 10-30 ${intl.buyWithCircle_minutes}',
                      then: () {
                        context.read(navigationStpod).state = 1;
                      },
                    );
                  } else if (uri.path == '/circle/failure') {
                    FailureScreen.push(
                      context: context,
                      primaryText: intl.previewBuyWithAsset_failure,
                      secondaryText: intl.something_went_wrong,
                      primaryButtonName: intl.previewBuyWithAsset_editOrder,
                      onPrimaryButtonTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      secondaryButtonName: intl.previewBuyWithAsset_close,
                      onSecondaryButtonTap: () {
                        navigateToRouter(context.read);
                      },
                    );
                  }

                  return NavigationDecision.navigate;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
