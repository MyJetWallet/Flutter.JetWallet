import 'package:freezed_annotation/freezed_annotation.dart';

part 'two_fa_change_request.freezed.dart';
part 'two_fa_change_request.g.dart';

@freezed
class TwoFaChangeRequest with _$TwoFaChangeRequest {
  const factory TwoFaChangeRequest({
    required String language,
    required String deviceType,
  }) = _TwoFaChangeRequest;

  factory TwoFaChangeRequest.fromJson(Map<String, dynamic> json) =>
      _$TwoFaChangeRequestFromJson(json);
}
