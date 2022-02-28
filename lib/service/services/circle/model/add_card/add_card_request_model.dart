import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_card_request_model.freezed.dart';
part 'add_card_request_model.g.dart';

@freezed
class AddCardRequestModel with _$AddCardRequestModel {
  const factory AddCardRequestModel({
    required String name,
  }) = _AddCardRequestModel;

  factory AddCardRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddCardRequestModelFromJson(json);
}
