import 'package:hooks_riverpod/hooks_riverpod.dart';

final walletHiddenStPod = StateProvider.autoDispose<bool>(
  (ref) => false,
);
