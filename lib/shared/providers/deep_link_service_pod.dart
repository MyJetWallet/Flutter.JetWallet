import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/deep_link_service.dart';

final deepLinkServicePod = Provider<DeepLinkService>(
      (ref) {
    return DeepLinkService(ref.read);
  },
  name: 'deepLinkServicePod',
);
