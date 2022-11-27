import 'package:flutter/material.dart';

@immutable
class SimpleTierModel {
  const SimpleTierModel({
    this.fromUsd,
    this.toUsd,
    required this.from,
    required this.to,
    required this.apy,
    required this.active,
  });

  final String? fromUsd;
  final String? toUsd;
  final String from;
  final String to;
  final String apy;
  final bool active;
}
