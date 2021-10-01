import 'package:hooks_riverpod/hooks_riverpod.dart';

final showZeroBalanceWalletsStpod = StateProvider.autoDispose<bool>(
      (ref) => false,
);
