import 'package:flutter/material.dart';

Object getArgs(BuildContext context) {
  final settings = ModalRoute.of(context)!.settings;
  return settings.arguments!;
}
