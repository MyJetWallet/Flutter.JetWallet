import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'get_crypto_sell_request_model.freezed.dart';
part 'get_crypto_sell_request_model.g.dart';

@freezed
abstract class GetCryptoSellRequestModel with _$GetCryptoSellRequestModel {
  const factory GetCryptoSellRequestModel({
    required String paymentAsset,
    required String buyAsset,
    @DecimalSerialiser() required Decimal buyAmount,
    required bool buyFixed,
    @DecimalSerialiser() required Decimal paymentAmount,
    @Default('IbanSell') String sellMethod,
    required String destinationAccountId,
  }) = _GetCryptoSellRequestModel;

  factory GetCryptoSellRequestModel.fromJson(Map<String, dynamic> json) => _$GetCryptoSellRequestModelFromJson(json);
}
