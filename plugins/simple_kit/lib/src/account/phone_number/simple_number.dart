import 'package:flutter/material.dart';

@immutable
class SPhoneNumber {
  const SPhoneNumber({
    required this.countryName,
    required this.countryCode,
    required this.alphaCode,
    required this.numCode,
    required this.asset,
  });

  final String countryName;
  final String countryCode;
  final String alphaCode;
  final String numCode;
  final String asset;
}
