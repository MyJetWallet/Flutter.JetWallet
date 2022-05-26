import 'package:freezed_annotation/freezed_annotation.dart';

part 'recurring_delete_request_model.freezed.dart';
part 'recurring_delete_request_model.g.dart';

@freezed
class RecurringDeleteRequestModel with _$RecurringDeleteRequestModel {
  const factory RecurringDeleteRequestModel({
    required String instructionId,
  }) = _RecurringDeleteRequestModel;

  factory RecurringDeleteRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RecurringDeleteRequestModelFromJson(json);
}
