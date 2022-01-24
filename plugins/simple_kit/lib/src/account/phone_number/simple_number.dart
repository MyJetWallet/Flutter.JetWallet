import 'package:flutter/material.dart';

@immutable
class SPhoneNumber {
  const SPhoneNumber({
    required this.countryName,
    required this.countryCode,
    required this.isoCode,
    required this.numCode,
    required this.alphaCode,
  });

  final String countryName;
  final String countryCode;
  final String isoCode;
  final String numCode;
  final String alphaCode;
}
