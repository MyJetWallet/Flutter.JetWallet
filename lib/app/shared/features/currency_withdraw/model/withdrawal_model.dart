import 'package:flutter/material.dart';

import '../../../models/currency_model.dart';
import 'withdrawal_dictionary_model.dart';

@immutable
class WithdrawalModel {
  const WithdrawalModel({
    this.currency = const CurrencyModel(),
    this.dictionary = const WithdrawalDictionaryModel.send(),
  });

  final CurrencyModel currency;
  final WithdrawalDictionaryModel dictionary;
}
