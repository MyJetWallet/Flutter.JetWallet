import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'delete_profile_state.dart';

class DPNotifier extends StateNotifier<DPState> {
  DPNotifier({
    required this.read,
  }) : super(
          const DPState(),
        );

  final Reader read;
}
