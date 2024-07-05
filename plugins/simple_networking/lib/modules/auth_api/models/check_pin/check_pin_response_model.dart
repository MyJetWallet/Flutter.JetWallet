import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_pin_response_model.freezed.dart';
part 'check_pin_response_model.g.dart';

@freezed
class CheckPinResponseModel with _$CheckPinResponseModel {
  const factory CheckPinResponseModel({
    required String result,
    RejectDetailData? rejectDetail,
  }) = _CheckPinResponseModel;

  factory CheckPinResponseModel.fromJson(Map<String, dynamic> json) => _$CheckPinResponseModelFromJson(json);
}

@freezed
class RejectDetailData with _$RejectDetailData {
  const factory RejectDetailData({
    BlockerModel? blocker,
    AttemptsModel? attempts,
    String? errorMessage,
  }) = _RejectDetailData;

  factory RejectDetailData.fromJson(Map<String, dynamic> json) => _$RejectDetailDataFromJson(json);
}

@freezed
class AttemptsModel with _$AttemptsModel {
  const factory AttemptsModel({
    int? left,
  }) = _AttemptsModel;

  factory AttemptsModel.fromJson(Map<String, dynamic> json) => _$AttemptsModelFromJson(json);
}

@freezed
class BlockerModel with _$BlockerModel {
  const factory BlockerModel({
    String? expired,
  }) = _BlockerModel;

  factory BlockerModel.fromJson(Map<String, dynamic> json) => _$BlockerModelFromJson(json);
}
