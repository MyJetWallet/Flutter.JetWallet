import 'package:flutter/material.dart';

@immutable
class SimpleTierModel {
  const SimpleTierModel({
    required this.fromUsd,
    required this.toUsd,
    required this.apy,
    required this.active,
  });

  final String fromUsd;
  final String toUsd;
  final String apy;
  final bool active;
}
