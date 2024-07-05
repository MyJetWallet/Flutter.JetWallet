import 'package:freezed_annotation/freezed_annotation.dart';

import 'recurring_buys_model.dart';

part 'recurring_buys_response_model.freezed.dart';
part 'recurring_buys_response_model.g.dart';

@freezed
class RecurringBuysResponseModel with _$RecurringBuysResponseModel {
  const factory RecurringBuysResponseModel({
    required List<RecurringBuysModel> recurringBuys,
  }) = _RecurringBuysResponseModel;

  factory RecurringBuysResponseModel.fromJson(Map<String, dynamic> json) => _$RecurringBuysResponseModelFromJson(json);
}
