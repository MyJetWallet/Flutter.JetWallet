import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_card_response_model.freezed.dart';
part 'add_card_response_model.g.dart';

@freezed
class AddCardResponseModel with _$AddCardResponseModel {
  const factory AddCardResponseModel({
    required String name,
  }) = _AddCardResponseModel;

  factory AddCardResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AddCardResponseModelFromJson(json);
}
