import 'package:freezed_annotation/freezed_annotation.dart';

part 'router_union.freezed.dart';

@freezed
class RouterUnion with _$RouterUnion {
  const factory RouterUnion.loading() = Loading;
  const factory RouterUnion.singleIn() = SingleSingIn;
  const factory RouterUnion.emailVerification() = EmailVerification;
  const factory RouterUnion.userDataVerification() = UserDataVerification;
  const factory RouterUnion.askBioUsing() = AskBioUsing;
  const factory RouterUnion.twoFaVerification() = TwoFaVerification;
  const factory RouterUnion.pinSetup() = PinSetup;
  const factory RouterUnion.pinVerification() = PinVerification;
  const factory RouterUnion.home() = Home;
  const factory RouterUnion.unauthorized() = Unauthorized;
}
