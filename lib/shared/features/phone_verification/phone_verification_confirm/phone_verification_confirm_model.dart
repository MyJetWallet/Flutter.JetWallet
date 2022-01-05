class PhoneVerificationConfirmModel {
  PhoneVerificationConfirmModel({
    required this.phoneNumber,
    required this.onVerified,
  });

  final String phoneNumber;
  final Function() onVerified;
}
