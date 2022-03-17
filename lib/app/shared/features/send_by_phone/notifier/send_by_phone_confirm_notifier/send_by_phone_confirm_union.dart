import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_by_phone_confirm_union.freezed.dart';

@freezed
class SendByPhoneConfirmUnion with _$SendByPhoneConfirmUnion {
  const factory SendByPhoneConfirmUnion.input() = Input;
  const factory SendByPhoneConfirmUnion.error(Object? error) = Error;
  const factory SendByPhoneConfirmUnion.loading() = Loading;
}
