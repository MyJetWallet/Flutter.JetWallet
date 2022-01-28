import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/kyc_verified_model.dart';

class KycNotifier extends StateNotifier<KycModel> {
  KycNotifier({
    required this.read,
    required this.kycModel,
  }) : super(
    const KycModel(),
  ) {
    state = kycModel;
  }

  final Reader read;
  final KycModel kycModel;

  void updateKycStatus() {
    state = state.copyWith(verificationInProgress: true);
  }
}
