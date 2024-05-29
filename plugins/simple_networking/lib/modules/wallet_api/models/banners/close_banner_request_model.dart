import 'package:freezed_annotation/freezed_annotation.dart';

part 'close_banner_request_model.freezed.dart';
part 'close_banner_request_model.g.dart';

@freezed
class CloseBannerRequestModel with _$CloseBannerRequestModel {
  const factory CloseBannerRequestModel({
    required String bannerId,
  }) = _CloseBannerRequestModel;

  factory CloseBannerRequestModel.fromJson(Map<String, dynamic> json) => _$CloseBannerRequestModelFromJson(json);
}
