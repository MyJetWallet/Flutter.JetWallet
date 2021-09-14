import 'package:flutter/material.dart';

import '../../../models/currency_model.dart';
import 'withdrawal_dictionary_model.dart';

@immutable
class WithdrawalModel {
  const WithdrawalModel({
    required this.currency,
    required this.dictionary,
  });

  final CurrencyModel currency;
  final WithdrawalDictionaryModel dictionary;
}
