import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:io' show Platform;

Future<void> launchURL(BuildContext context, String url) async {
  final uri = Uri.parse(url);

  if (Platform.isAndroid) {
    launchUrlWevView(url);
  } else {
    if (!await launchUrl(uri, mode: Platform.isAndroid ? LaunchMode.inAppWebView : LaunchMode.platformDefault)) {
      sNotification.showError('${intl.launchUrl_couldNotLaunch} $url');
      throw Exception('Could not launch $url');
    }
  }
}

void launchUrlWevView(String url) {
  sRouter.push(
    HelpCenterWebViewRouter(link: url, title: ''),
  );
}
