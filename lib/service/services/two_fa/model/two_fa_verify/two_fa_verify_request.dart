import 'package:freezed_annotation/freezed_annotation.dart';

part 'two_fa_verify_request.freezed.dart';
part 'two_fa_verify_request.g.dart';

@freezed
class TwoFaVerifyRequest with _$TwoFaVerifyRequest {
  const factory TwoFaVerifyRequest({
    required String code,
  }) = _TwoFaVerifyRequest;

  factory TwoFaVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$TwoFaVerifyRequestFromJson(json);
}
