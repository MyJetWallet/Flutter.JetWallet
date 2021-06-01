import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_model.freezed.dart';
part 'authentication_model.g.dart';

@freezed
class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    required int result,
    @JsonKey(name: 'data') required AuthenticationModel authModel,
  }) = _AuthResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
}

@freezed
class AuthenticationModel with _$AuthenticationModel {
  const factory AuthenticationModel({
    required String token,
    required String refreshToken,
    required String tradingUrl,
    required String connectionTimeOut,
    required String reconnectTimeOut,
  }) = _AuthenticationModel;

  factory AuthenticationModel.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationModelFromJson(json);
}
