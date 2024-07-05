import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_refresh_response_model.freezed.dart';
part 'auth_refresh_response_model.g.dart';

@freezed
class AuthRefreshResponseModel with _$AuthRefreshResponseModel {
  const factory AuthRefreshResponseModel({
    required String token,
    required String refreshToken,
  }) = _AuthRefreshResponseModel;

  factory AuthRefreshResponseModel.fromJson(Map<String, dynamic> json) => _$AuthRefreshResponseModelFromJson(json);
}
