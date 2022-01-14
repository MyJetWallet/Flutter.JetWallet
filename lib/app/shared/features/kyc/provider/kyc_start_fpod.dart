import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../shared/providers/service_providers.dart';

final kycStartFpod = FutureProvider.autoDispose<void>((ref) async {
  final kycService = ref.read(kycServicePod);

  await kycService.kycStart();
});
