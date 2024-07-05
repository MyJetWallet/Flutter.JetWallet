import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_card_response_model.freezed.dart';
part 'delete_card_response_model.g.dart';

@freezed
class DeleteCardResponseModel with _$DeleteCardResponseModel {
  const factory DeleteCardResponseModel({
    required bool deleted,
  }) = _DeleteCardResponseModel;

  factory DeleteCardResponseModel.fromJson(Map<String, dynamic> json) => _$DeleteCardResponseModelFromJson(json);
}
