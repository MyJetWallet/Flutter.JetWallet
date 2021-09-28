import 'package:hooks_riverpod/hooks_riverpod.dart';

final showZeroBalanceWalletsStPod = StateProvider.autoDispose<bool>(
      (ref) => false,
);
