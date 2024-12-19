import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'crypto_card_otps_message_model.freezed.dart';
part 'crypto_card_otps_message_model.g.dart';

@freezed
class CryptoCardOtpsModel with _$CryptoCardOtpsModel {
  const factory CryptoCardOtpsModel({
    required String code,
    required String merchant,
    required String id,
    required String cardId,
    required String asset,
    @DecimalSerialiser() required Decimal amount,
  }) = _CryptoCardOtpsModel;

  factory CryptoCardOtpsModel.fromJson(Map<String, dynamic> json) => _$CryptoCardOtpsModelFromJson(json);
}
