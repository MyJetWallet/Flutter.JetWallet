import 'package:url_launcher/url_launcher.dart';

import 'encode_query_parameters.dart';

void sendLogsToSupport(String logs) {
  final _emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'illia.s@smplt.net, vladimir.m@smplt.net',
    query: encodeQueryParameters({
      'subject': 'JetWallet Logs',
      'body': logs,
    }),
  );

  launch(_emailLaunchUri.toString());
}
