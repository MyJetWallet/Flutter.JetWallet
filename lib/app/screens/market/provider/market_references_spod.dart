import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../service/services/signal_r/model/market_references_model.dart';
import '../../../../shared/providers/service_providers.dart';

final marketReferencesSpod =
    StreamProvider.autoDispose<MarketReferencesModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.marketReferences();
});
