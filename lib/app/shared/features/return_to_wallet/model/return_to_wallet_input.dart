import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/services/signal_r/model/earn_offers_model.dart';

import '../../../models/currency_model.dart';

part 'return_to_wallet_input.freezed.dart';

@freezed
class ReturnToWalletInput with _$ReturnToWalletInput {
  const factory ReturnToWalletInput({
    required CurrencyModel currency,
    required EarnOfferModel earnOffer,
  }) = _ReturnToWalletInput;
}
