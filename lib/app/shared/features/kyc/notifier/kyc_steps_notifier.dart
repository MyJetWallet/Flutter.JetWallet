import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/kyc_operation_status_model.dart';
import 'kyc_steps_state.dart';

class KycStepsNotifier extends StateNotifier<KycStepsState> {
  KycStepsNotifier({
    required this.read,
    required this.requiredVerifications,
  }) : super(
          const KycStepsState(),
        ) {
    _init(requiredVerifications);
  }

  final Reader read;
  final List<ModifyRequiredVerified> requiredVerifications;

  void _init(List<ModifyRequiredVerified> requiredVerifications) {
    state = state.copyWith(requiredVerifications: requiredVerifications);
  }

  int getVerifyComplete() {
    if (state.requiredVerifications.isNotEmpty) {
      return state.requiredVerifications
          .where((element) => element.verifiedDone)
          .length;
    } else {
      return 0;
    }
  }

  String chooseDocumentsHeaderTitle() {
    final element = state.requiredVerifications
        .firstWhere((element) => !element.verifiedDone);

    return stringRequiredVerified(element.requiredVerified!);
  }
}
