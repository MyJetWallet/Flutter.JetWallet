import 'package:auto_route/auto_route.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/widgets/web_view/store/web_veiw_store.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:webview_flutter/webview_flutter.dart';

@RoutePage(name: 'WebViewRouter')
class WebViewScreen extends StatelessWidget {
  const WebViewScreen({
    super.key,
    required this.link,
    this.title,
    this.navigationDelegate,
  });

  final String link;
  final String? title;
  final NavigationDelegate? navigationDelegate;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => WebViewStore(Uri.parse(link))..setNavigationDelegate(navigationDelegate),
      builder: (context, child) {
        final store = WebViewStore.of(context);

        return SPageFrame(
          loaderText: intl.register_pleaseWait,
          header: GlobalBasicAppBar(
            title: title,
            hasRightIcon: false,
            onLeftIconTap: () {
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          child: WebViewWidget(
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}..add(
                Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer(),
                ),
              ),
            controller: store.controller,
          ),
        );
      },
    );
  }
}
