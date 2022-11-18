import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_unlimint_card_request_model.freezed.dart';
part 'add_unlimint_card_request_model.g.dart';

@freezed
class AddUnlimintCardRequestModel with _$AddUnlimintCardRequestModel {
  const factory AddUnlimintCardRequestModel({
    required String buyPaymentId,
  }) = _AddUnlimintCardRequestModel;

  factory AddUnlimintCardRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddUnlimintCardRequestModelFromJson(json);
}
