import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_verification_confirm_union.freezed.dart';

@freezed
class PhoneVerificationConfirmUnion with _$PhoneVerificationConfirmUnion {
  const factory PhoneVerificationConfirmUnion.input() = Input;
  const factory PhoneVerificationConfirmUnion.error(Object? error) = Error;
  const factory PhoneVerificationConfirmUnion.loading() = Loading;
}
