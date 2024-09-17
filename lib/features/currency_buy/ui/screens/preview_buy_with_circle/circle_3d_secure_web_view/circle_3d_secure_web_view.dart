import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

@RoutePage(name: 'Circle3dSecureWebViewRouter')
class Circle3dSecureWebView extends StatefulWidget {
  const Circle3dSecureWebView(
    this.title,
    this.url,
    this.asset,
    this.amount,
    this.onSuccess,
    this.onCancel,
    this.paymentId,
    this.onFailed,
  );

  final String title;
  final String url;
  final String asset;
  final String amount;
  final String paymentId;
  final Function(String, String) onSuccess;
  final Function(String) onFailed;
  final Function(String?)? onCancel;

  @override
  State<Circle3dSecureWebView> createState() => _Circle3dSecureWebViewState();
}

class _Circle3dSecureWebViewState extends State<Circle3dSecureWebView> {
  late WebViewController controller;

  @override
  void initState() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    controller = WebViewController.fromPlatformCreationParams(
      params,
      onPermissionRequest: (request) async {
        await request.grant();
      },
    );

    if (controller.platform is AndroidWebViewController) {
      (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }

    if (Platform.isAndroid) {
      (controller.platform as AndroidWebViewController).setOnShowFileSelector((params) => _androidFilePicker(params));
    }

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            final uri = Uri.parse(request.url);

            if (uri.path == '/circle/failure' || uri.path == '/unlimint/failure') {
              widget.onFailed(intl.something_went_wrong);

              return NavigationDecision.navigate;
            } else if (uri.path == '/circle/success' || uri.path == '/unlimint/success') {
              widget.onSuccess(widget.paymentId, widget.url);

              return NavigationDecision.navigate;
            } else if (uri.path == '/unlimint/cancel') {
              widget.onCancel?.call(widget.paymentId);

              return NavigationDecision.navigate;
            } else if (uri.path == '/unlimint/inprocess' || uri.path == '/unlimint/return') {
              widget.onSuccess(widget.paymentId, widget.url);

              return NavigationDecision.navigate;
            } else if (uri.path.startsWith('text/html')) {
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    super.initState();
  }

  Future<List<String>> _androidFilePicker(
    FileSelectorParams params,
  ) async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      return [file.uri.toString()];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) {
        widget.onCancel?.call(null);

        Future.value(true);
      },
      child: SPageFrame(
        loaderText: intl.register_pleaseWait,
        header: SPaddingH24(
          child: SSmallHeader(
            titleAlign: TextAlign.left,
            icon: const SCloseIcon(),
            title: widget.title,
            onBackButtonTap: () {
              widget.onCancel?.call(null);
            },
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: WebViewWidget(
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}..add(
                    Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer(),
                    ),
                  ),
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
