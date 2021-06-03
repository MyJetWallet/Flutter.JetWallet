import 'dart:developer';

import 'package:intl/intl.dart';

void signalRLog(String message) {
  log(
    '[${DateFormat('hh:mm:ss').format(DateTime.now())}] $message',
    name: 'SignalR',
  );
}
