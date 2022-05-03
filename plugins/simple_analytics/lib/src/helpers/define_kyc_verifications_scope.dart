import '../../simple_analytics.dart';

void defineKycVerificationsScope(
  int kycStateLength,
  Source source,
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
