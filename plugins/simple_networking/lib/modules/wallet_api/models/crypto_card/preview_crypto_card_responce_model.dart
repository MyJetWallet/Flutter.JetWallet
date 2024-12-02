import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'preview_crypto_card_responce_model.freezed.dart';
part 'preview_crypto_card_responce_model.g.dart';

@freezed
class PreviewCryptoCardResponceModel with _$PreviewCryptoCardResponceModel {
  const factory PreviewCryptoCardResponceModel({
    required String operationId,
    @DecimalSerialiser() required Decimal price,
    required String fromAsset,
    @DecimalSerialiser() required Decimal fromAssetVolume,
    required String toAsset,
    @DecimalSerialiser() required Decimal toAssetVolume,
  }) = _PreviewCryptoCardResponceModel;

  factory PreviewCryptoCardResponceModel.fromJson(Map<String, dynamic> json) =>
      _$PreviewCryptoCardResponceModelFromJson(json);
}
