import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'get_crypto_sell_response_model.freezed.dart';
part 'get_crypto_sell_response_model.g.dart';

@freezed
abstract class GetCryptoSellResponseModel with _$GetCryptoSellResponseModel {
  const factory GetCryptoSellResponseModel({
    required String paymentAssetSymbol,
    @DecimalSerialiser() required Decimal paymentAmount,
    required String buyAssetSymbol,
    @DecimalSerialiser() required Decimal buyAmount,
    @DecimalSerialiser() required Decimal rate,
    @DecimalSerialiser() required Decimal tradeFeeAmount,
    required String tradeFeeAsset,
    @DecimalSerialiser() required Decimal simpleFeeAmountInPaymentAsset,
    @DecimalSerialiser() required Decimal paymentFeeInPaymentAsset,
    required String id,
    required int status,
  }) = _GetCryptoSellResponseModel;

  factory GetCryptoSellResponseModel.fromJson(Map<String, dynamic> json) => _$GetCryptoSellResponseModelFromJson(json);
}
