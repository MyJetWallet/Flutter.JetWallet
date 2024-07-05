import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdrawal_info_request_model.freezed.dart';
part 'withdrawal_info_request_model.g.dart';

@freezed
class WithdrawalInfoRequestModel with _$WithdrawalInfoRequestModel {
  const factory WithdrawalInfoRequestModel({
    @JsonKey(name: 'id') required String operationId,
  }) = _WithdrawalInfoRequestModel;

  factory WithdrawalInfoRequestModel.fromJson(Map<String, dynamic> json) => _$WithdrawalInfoRequestModelFromJson(json);
}
