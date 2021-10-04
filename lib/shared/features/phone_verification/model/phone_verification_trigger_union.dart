import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_verification_trigger_union.freezed.dart';

@freezed
class PhoneVerificationTriggerUnion with _$PhoneVerificationTriggerUnion {
  const factory PhoneVerificationTriggerUnion.startup() = Startup;
  const factory PhoneVerificationTriggerUnion.security() = Security;
}
