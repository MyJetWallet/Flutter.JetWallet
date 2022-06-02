import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/decimal_serialiser.dart';

part 'payment_preview_response_model.freezed.dart';
part 'payment_preview_response_model.g.dart';

@freezed
class PaymentPreviewResponseModel with _$PaymentPreviewResponseModel {
  const factory PaymentPreviewResponseModel({
    required String cardId,
    @JsonKey(name: 'calculatedAmount')
    @DecimalSerialiser()
        required Decimal amount,
    @DecimalSerialiser() required Decimal feeAmount,
    @DecimalSerialiser() required Decimal feePercentage,
    @JsonKey(name: 'currency') required String currencySymbol,
  }) = _PaymentPreviewResponseModel;

  factory PaymentPreviewResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentPreviewResponseModelFromJson(json);
}
