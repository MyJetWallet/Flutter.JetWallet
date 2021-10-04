import 'package:freezed_annotation/freezed_annotation.dart';

part 'authorized_union.freezed.dart';

@freezed
class AuthorizedUnion with _$AuthorizedUnion {
  const factory AuthorizedUnion.loading() = Loading;
  const factory AuthorizedUnion.emailVerification() = EmailVerification;
  const factory AuthorizedUnion.phoneVerification() = PhoneVerification;
  const factory AuthorizedUnion.twoFaVerification() = TwoFaVerification;
  const factory AuthorizedUnion.pinSetup() = PinSetup;
  const factory AuthorizedUnion.pinVerification() = PinVerification;
  const factory AuthorizedUnion.home() = Home;
}
