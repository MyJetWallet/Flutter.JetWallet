import 'package:freezed_annotation/freezed_annotation.dart';

part 'kyc_plan_request_model.freezed.dart';
part 'kyc_plan_request_model.g.dart';

@freezed
class KycPlanRequesModel with _$KycPlanRequesModel {
  const factory KycPlanRequesModel({
    required bool isCardFlow,
  }) = _KycPlanRequesModel;

  factory KycPlanRequesModel.fromJson(Map<String, dynamic> json) => _$KycPlanRequesModelFromJson(json);
}
