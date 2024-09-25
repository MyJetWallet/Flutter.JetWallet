import 'package:freezed_annotation/freezed_annotation.dart';

part 'fee_preview_request_model.freezed.dart';
part 'fee_preview_request_model.g.dart';

@freezed
class FeePreviewRequestModel with _$FeePreviewRequestModel {
  const factory FeePreviewRequestModel({
    required String assetSymbol,
  }) = _FeePreviewRequestModel;

  factory FeePreviewRequestModel.fromJson(Map<String, dynamic> json) => _$FeePreviewRequestModelFromJson(json);
}
