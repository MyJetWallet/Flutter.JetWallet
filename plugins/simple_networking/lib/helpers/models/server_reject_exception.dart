import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_reject_exception.freezed.dart';

/// Can happen when request was 200 but Server rejected our request
/// because of something. This cause can be found in [result] key of
/// the [Map] response. If [result != OK] then we throw [ServerRejectException]
@freezed
class ServerRejectException with _$ServerRejectException {
  const factory ServerRejectException(String cause, String errorCode) = _ServerRejectException;
}
