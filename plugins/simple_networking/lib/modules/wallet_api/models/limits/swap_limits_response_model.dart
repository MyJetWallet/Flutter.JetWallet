import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'swap_limits_response_model.freezed.dart';
part 'swap_limits_response_model.g.dart';

@freezed
class SwapLimitsResponseModel with _$SwapLimitsResponseModel {
  const factory SwapLimitsResponseModel({
    required String fromAsset,
    @DecimalSerialiser() required Decimal maxFromAssetVolume,
    @DecimalSerialiser() required Decimal minFromAssetVolume,
    required String toAsset,
    @DecimalSerialiser() required Decimal maxToAssetVolume,
    @DecimalSerialiser() required Decimal minToAssetVolume,
  }) = _SwapLimitsResponseModel;

  factory SwapLimitsResponseModel.fromJson(Map<String, dynamic> json) => _$SwapLimitsResponseModelFromJson(json);
}
