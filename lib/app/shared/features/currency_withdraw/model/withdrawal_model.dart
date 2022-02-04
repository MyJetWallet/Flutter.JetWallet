import 'package:flutter/material.dart';

import '../../../models/currency_model.dart';
import 'withdrawal_dictionary_model.dart';

@immutable
class WithdrawalModel {
  const WithdrawalModel({
    this.dictionary = const WithdrawalDictionaryModel.send(),
    required this.currency,
  });

  final CurrencyModel currency;
  final WithdrawalDictionaryModel dictionary;
}
