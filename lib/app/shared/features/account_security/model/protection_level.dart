import 'package:flutter/material.dart';

@immutable
class ProtectionLevel {
  const ProtectionLevel({
    required this.name,
    required this.color,
  });

  final String name;
  final Color color;
}
