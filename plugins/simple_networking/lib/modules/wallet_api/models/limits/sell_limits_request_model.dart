import 'package:freezed_annotation/freezed_annotation.dart';

part 'sell_limits_request_model.freezed.dart';
part 'sell_limits_request_model.g.dart';

@freezed
class SellLimitsRequestModel with _$SellLimitsRequestModel {
  const factory SellLimitsRequestModel({
    required String paymentAsset,
    @Default('EUR') String buyAsset,
    @Default(SellMethods.ibanSell) SellMethods sellMethod,
    required String destinationAccountId,
  }) = _SellLimitsRequestModel;

  factory SellLimitsRequestModel.fromJson(Map<String, dynamic> json) => _$SellLimitsRequestModelFromJson(json);
}

enum SellMethods {
  @JsonValue('IbanSell')
  ibanSell
}
