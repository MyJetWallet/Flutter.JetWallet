import '../../simple_analytics.dart';

void defineKycVerificationsScope(
  int kycStateLength,
  ScreenSource source,
) {
  if (kycStateLength == 2) {
    sAnalytics.kycVerifyProfile(
      source,
      KycScope.phoneIdentity,
    );
  } else {
    sAnalytics.kycVerifyProfile(
      source,
      KycScope.identity,
    );
  }
}
