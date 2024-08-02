import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_token_request_model.freezed.dart';
part 'register_token_request_model.g.dart';

@freezed
class RegisterTokenRequestModel with _$RegisterTokenRequestModel {
  const factory RegisterTokenRequestModel({
    required String token,
    @JsonKey(name: 'userLocale') required String locale,
  }) = _RegisterTokenRequestModel;

  factory RegisterTokenRequestModel.fromJson(Map<String, dynamic> json) => _$RegisterTokenRequestModelFromJson(json);
}
