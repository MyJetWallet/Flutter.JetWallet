import 'package:freezed_annotation/freezed_annotation.dart';

part 'two_fa_phone_trigger_union.freezed.dart';

@freezed
class TwoFaPhoneTriggerUnion with _$TwoFaPhoneTriggerUnion {
  const factory TwoFaPhoneTriggerUnion.login() = Login;
  const factory TwoFaPhoneTriggerUnion.security({
    required bool fromDialog,
  }) = Security;
}
