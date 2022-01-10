import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../model/kyc_operation_status_model.dart';
import 'kyc_step_state.dart';
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
  final List<RequiredVerified> requiredVerifications;

  static final _logger = Logger('KycStepsNotifier');

  void _init(List<RequiredVerified> requiredVerifications) {
    state = state.copyWith(requiredVerifications: requiredVerifications);
  }
}
