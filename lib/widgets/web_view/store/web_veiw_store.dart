import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

part 'web_veiw_store.g.dart';

class WebViewStore extends _WebViewStoreBase with _$WebViewStore {
  WebViewStore(super.initialUri) : super();

  static _WebViewStoreBase of(BuildContext context) => Provider.of<WebViewStore>(context, listen: false);
}

abstract class _WebViewStoreBase with Store {
  _WebViewStoreBase(Uri initialUri) {
    final params = _getControlletPlatformParametrs();

    controller = WebViewController.fromPlatformCreationParams(
      params,
      onPermissionRequest: (request) async {
        await request.grant();
      },
    );

    _addSettingsForController();

    controller.loadRequest(initialUri);
  }
  @observable
  WebViewController controller = WebViewController();

  PlatformWebViewControllerCreationParams _getControlletPlatformParametrs() {
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      return WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
      );
    } else {
      return const PlatformWebViewControllerCreationParams();
    }
  }

  void _addSettingsForController() {
    if (controller.platform is AndroidWebViewController) {
      (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
      (controller.platform as AndroidWebViewController).setOnShowFileSelector(_androidFilePicker);
    }

    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setBackgroundColor(Colors.white);
    controller.enableZoom(false);
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
}
