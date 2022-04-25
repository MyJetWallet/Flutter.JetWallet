import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'show_plain_snackbar.dart';

Future<void> launchURL(BuildContext context, String url) async {
  final uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    showPlainSnackbar(context, 'Could not launch $url');
  }
}
