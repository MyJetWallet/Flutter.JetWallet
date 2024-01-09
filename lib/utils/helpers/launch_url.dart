import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> launchURL(BuildContext context, String url) async {
  final uri = Uri.parse(url);

  print(uri);

  try {
    await launchUrlString(url, mode: LaunchMode.externalApplication);
  } catch (e) {
    sNotification.showError('${intl.launchUrl_couldNotLaunch} $url');
  }
}
