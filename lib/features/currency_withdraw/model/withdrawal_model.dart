import 'package:flutter/material.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';

@immutable
class WithdrawalModel {
  const WithdrawalModel({
    this.currency,
    this.nft,
    this.jar,
  });

  final CurrencyModel? currency;
  final NftMarket? nft;
  final JarResponseModel? jar;
}
