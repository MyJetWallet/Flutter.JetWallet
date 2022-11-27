import 'package:flutter/material.dart';

@immutable
class ChartInput {
  const ChartInput({
    this.instrumentId,
    required this.creationDate,
  });

  final String? instrumentId;
  final String creationDate;
}
