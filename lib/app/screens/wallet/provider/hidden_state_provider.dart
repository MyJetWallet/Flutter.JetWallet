import 'package:hooks_riverpod/hooks_riverpod.dart';

final hiddenStatePod = StateProvider.autoDispose<bool>(
  (ref) => false,
);
