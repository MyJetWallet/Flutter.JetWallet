double setSizedBoxHeight({
  required bool kycPassed,
  required bool phoneVerified,
  required bool twoFaEnabled,
}) {
  if (!kycPassed || !phoneVerified) {
    return 171;
  } else if (!twoFaEnabled) {
    return 155;
  } else {
    return 129;
  }
}
