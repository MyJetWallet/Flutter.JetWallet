import 'package:hooks_riverpod/hooks_riverpod.dart';

final isPermissionDenyStPod = StateProvider.autoDispose<bool>(
      (ref) => false,
);
