import 'package:freezed_annotation/freezed_annotation.dart';

part 'two_fa_disable_request.freezed.dart';
part 'two_fa_disable_request.g.dart';

@freezed
class TwoFaDisableRequest with _$TwoFaDisableRequest {
  const factory TwoFaDisableRequest({
    required String code,
  }) = _TwoFaDisableRequest;

  factory TwoFaDisableRequest.fromJson(Map<String, dynamic> json) =>
      _$TwoFaDisableRequestFromJson(json);
}
