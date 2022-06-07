import 'package:freezed_annotation/freezed_annotation.dart';

part 'recurring_manage_response_model.freezed.dart';
part 'recurring_manage_response_model.g.dart';

@freezed
class RecurringManageResponseModel with _$RecurringManageResponseModel {
  const factory RecurringManageResponseModel({
    required String key,
    required String value,
  }) = _RecurringManageResponseModel;

  factory RecurringManageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RecurringManageResponseModelFromJson(json);
}
