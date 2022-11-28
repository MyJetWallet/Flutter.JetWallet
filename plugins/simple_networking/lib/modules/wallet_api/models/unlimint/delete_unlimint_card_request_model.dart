import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_unlimint_card_request_model.freezed.dart';
part 'delete_unlimint_card_request_model.g.dart';

@freezed
class DeleteUnlimintCardRequestModel with _$DeleteUnlimintCardRequestModel {
  const factory DeleteUnlimintCardRequestModel({
    required String cardId,
  }) = _DeleteUnlimintCardRequestModel;

  factory DeleteUnlimintCardRequestModel.fromJson(Map<String, dynamic> json) =>
      _$DeleteUnlimintCardRequestModelFromJson(json);
}
