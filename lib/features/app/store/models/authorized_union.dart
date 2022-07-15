import 'package:freezed_annotation/freezed_annotation.dart';

part 'authorized_union.freezed.dart';

@freezed
class AuthorizedUnion with _$AuthorizedUnion {
  // Loading only appears at the initialization of the app (at the boot). \
  // After that, usual Loader takes place (the loader that is in the square)
  const factory AuthorizedUnion.loading() = Loading;
  const factory AuthorizedUnion.emailVerification() = EmailVerification;
  const factory AuthorizedUnion.twoFaVerification() = TwoFaVerification;
  const factory AuthorizedUnion.pinSetup() = PinSetup;
  const factory AuthorizedUnion.pinVerification() = PinVerification;
  const factory AuthorizedUnion.home() = Home;
}
