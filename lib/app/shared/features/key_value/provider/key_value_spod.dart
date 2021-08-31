import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../service/services/signal_r/model/key_value_model.dart';
import '../../../../../shared/providers/service_providers.dart';

final keyValueSpod = StreamProvider.autoDispose<KeyValueModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.keyValue();
});
