import 'package:flutter/material.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

@immutable
class WithdrawalModel {
  const WithdrawalModel({
    this.currency,
    this.nft,
  });

  final CurrencyModel? currency;
  final NftMarket? nft;
}
