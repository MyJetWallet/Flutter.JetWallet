import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_model.freezed.dart';

@freezed
class AuthenticationModel with _$AuthenticationModel {
  const factory AuthenticationModel({
    required String token,
    required String refreshToken,
    required String tradingUrl,
    required String connectionTimeOut,
    required String reconnectTimeOut,
  }) = _AuthenticationModel;
}
