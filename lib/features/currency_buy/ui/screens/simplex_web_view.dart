import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'SimplexWebViewRouter')
class SimplexWebView extends StatefulWidget {
  const SimplexWebView(this.url);

  final String url;

  @override
  State<SimplexWebView> createState() => _SimplexWebViewState();
}

class _SimplexWebViewState extends State<SimplexWebView> {
  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void showSuccess() {
      sRouter
          .push(
            SuccessScreenRouter(
              secondaryText: '${intl.simplexWebView_successScreenSecondaryText1}\n≈ 10-30 '
                  '${intl.simplexWebView_minutes}',
            ),
          )
          .then(
            (value) => sRouter.push(const HomeRouter(children: [MyWalletsRouter()])),
          );
    }

    void showFailure() {
      sRouter.push(
        FailureScreenRouter(
          primaryText: intl.simplexWebView_failure,
          secondaryText: intl.simplexWebView_failedToBuy,
          primaryButtonName: intl.simplexWeb_editOrder,
          onPrimaryButtonTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          secondaryButtonName: intl.simplexWebView_close,
          onSecondaryButtonTap: () => navigateToRouter(),
        ),
      );
    }

    return PopScope(
      onPopInvoked: (_) {
        navigateToRouter();

        Future.value(true);
      },
      child: SPageFrame(
        loaderText: intl.register_pleaseWait,
        header: SPaddingH24(
          child: SSmallHeader(
            titleAlign: TextAlign.left,
            icon: const SCloseIcon(),
            title: intl.simplexWebView_simplex,
            onBackButtonTap: () {
              navigateToRouter();
            },
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: WebView(
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
                navigationDelegate: (request) {
                  final uri = Uri.parse(request.url);
                  final success = uri.queryParameters['success'];

                  if (uri.origin == simplexOrigin) {
                    if (success == '1') {
                      showSuccess();

                      return NavigationDecision.prevent;
                    } else if (success == '2') {
                      showFailure();

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
