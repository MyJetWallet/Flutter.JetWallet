import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(
  BuildContext context,
  String url, {
  LaunchMode? launchMode,
}) async {
  final uri = Uri.parse(url);

  if (Platform.isAndroid && launchMode == null) {
    launchUrlWevView(url);
  } else {
    if (!await launchUrl(
      uri,
      mode: launchMode ?? (Platform.isAndroid ? LaunchMode.inAppWebView : LaunchMode.platformDefault),
    )) {
      sNotification.showError('${intl.launchUrl_couldNotLaunch} $url');
      throw Exception('Could not launch $url');
    }
  }
}

void launchUrlWevView(String url) {
  sRouter.push(
    WebViewRouter(link: url, title: ''),
  );
}
