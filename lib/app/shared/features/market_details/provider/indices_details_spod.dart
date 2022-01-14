import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/service/services/signal_r/model/indices_model.dart';
import 'package:jetwallet/shared/providers/service_providers.dart';

final indicesDetailsSpod = StreamProvider.autoDispose<IndicesModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.indices();
});
