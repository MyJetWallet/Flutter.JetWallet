import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../deep_link_service_pod.dart';
import '../service_providers.dart';

final dynamicLinkPod = Provider<void>(
  (ref) {
    final service = ref.watch(dynamicLinkServicePod);
    final deepLinkService = ref.read(deepLinkServicePod);

    service.initDynamicLinks(
      handler: (link) {
        deepLinkService.handle(link);
      },
    );
  },
  name: 'dynamicLinkPod',
);
