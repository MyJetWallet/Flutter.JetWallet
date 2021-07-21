import 'package:hooks_riverpod/hooks_riverpod.dart';

enum MarketState { watch, search }

final marketStpod = StateProvider<MarketState>((ref) {
  return MarketState.watch;
});
