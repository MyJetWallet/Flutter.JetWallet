import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

part 'nft_sell_input.freezed.dart';

@freezed
class NftSellInput with _$NftSellInput {
  factory NftSellInput({
    required String amount,
    required NftMarket nft,
  }) = _NftSellInput;
}
