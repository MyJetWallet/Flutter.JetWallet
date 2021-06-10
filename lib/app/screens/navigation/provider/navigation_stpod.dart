import 'package:hooks_riverpod/hooks_riverpod.dart';

final navigationStpod = StateProvider.autoDispose<int>((ref) {
  return 0; // default page (Wallet)
});
