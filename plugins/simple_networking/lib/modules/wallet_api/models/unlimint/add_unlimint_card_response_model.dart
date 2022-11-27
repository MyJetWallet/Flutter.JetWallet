import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_unlimint_card_response_model.freezed.dart';
part 'add_unlimint_card_response_model.g.dart';

@freezed
class AddUnlimintCardResponseModel with _$AddUnlimintCardResponseModel {
  const factory AddUnlimintCardResponseModel({
    required String cardId,
  }) = _AddUnlimintCardResponseModel;

  factory AddUnlimintCardResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AddUnlimintCardResponseModelFromJson(json);
}
