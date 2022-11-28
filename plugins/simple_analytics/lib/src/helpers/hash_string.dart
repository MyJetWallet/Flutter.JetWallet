import 'dart:convert';

import 'package:crypto/crypto.dart';

String hashString(String string) {
  final bytes = utf8.encode(string);
  return sha256.convert(bytes).toString();
}
