import 'package:freezed_annotation/freezed_annotation.dart';

part 'recurring_manage_request_model.freezed.dart';
part 'recurring_manage_request_model.g.dart';

@freezed
class RecurringManageRequestModel with _$RecurringManageRequestModel {
  const factory RecurringManageRequestModel({
    required String instructionId,
    required bool isEnable,
  }) = _RecurringManageRequestModel;

  factory RecurringManageRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RecurringManageRequestModelFromJson(json);
}