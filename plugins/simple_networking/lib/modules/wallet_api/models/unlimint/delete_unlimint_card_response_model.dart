import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_unlimint_card_response_model.freezed.dart';
part 'delete_unlimint_card_response_model.g.dart';

@freezed
class DeleteUnlimintCardResponseModel with _$DeleteUnlimintCardResponseModel {
  const factory DeleteUnlimintCardResponseModel({
    required String cardId,
  }) = _DeleteUnlimintCardResponseModel;

  factory DeleteUnlimintCardResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DeleteUnlimintCardResponseModelFromJson(json);
}
