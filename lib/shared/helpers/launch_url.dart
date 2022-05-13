import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/service_providers.dart';
import 'show_plain_snackbar.dart';

Future<void> launchURL(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  final intl = context.read(intlPod);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    showPlainSnackbar(context, '${intl.could_not_launch} $url');
  }
}
