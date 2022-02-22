import '../../simple_analytics.dart';

void defineKycVerificationsScope(
  int kycStateLength,
  KycSource source,
) {
  print('SEND ANALYTICS SOURCE ${source.name}');

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
