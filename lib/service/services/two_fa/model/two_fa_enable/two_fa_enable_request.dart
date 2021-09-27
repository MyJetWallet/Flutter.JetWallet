import 'package:freezed_annotation/freezed_annotation.dart';

part 'two_fa_enable_request.freezed.dart';
part 'two_fa_enable_request.g.dart';

@freezed
class TwoFaEnableRequest with _$TwoFaEnableRequest {
  const factory TwoFaEnableRequest({
    required String code,
  }) = _TwoFaEnableRequest;

  factory TwoFaEnableRequest.fromJson(Map<String, dynamic> json) =>
      _$TwoFaEnableRequestFromJson(json);
}
