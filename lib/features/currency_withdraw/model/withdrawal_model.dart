import 'package:flutter/material.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

import 'withdrawal_dictionary_model.dart';

@immutable
class WithdrawalModel {
  const WithdrawalModel({
    this.dictionary = const WithdrawalDictionaryModel.send(),
    this.currency,
    this.nft,
  });

  final CurrencyModel? currency;
  final NftMarket? nft;

  final WithdrawalDictionaryModel dictionary;
}
