import 'package:freezed_annotation/freezed_annotation.dart';

part 'swap_limits_request_model.freezed.dart';
part 'swap_limits_request_model.g.dart';

@freezed
class SwapLimitsRequestModel with _$SwapLimitsRequestModel {
  const factory SwapLimitsRequestModel({
    required String fromAsset,
    required String toAsset,
  }) = _SwapLimitsRequestModel;

  factory SwapLimitsRequestModel.fromJson(Map<String, dynamic> json) => _$SwapLimitsRequestModelFromJson(json);
}
