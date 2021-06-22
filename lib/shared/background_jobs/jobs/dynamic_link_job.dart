import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../main.dart';
import '../../../service_providers.dart';

final dynamicLinkPod = Provider<void>((ref) {
  final service = ref.watch(dynamicLinkServicePod);
  final navigatorKey = ref.watch(navigatorKeyPod);

  service.initDynamicLinks(
    handler: (link) {
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) {
            return const EmailVerification();
          },
        ),
      );
    },
  );
}, name: 'dynamicLinkPod');

class EmailVerification extends StatelessWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Email Verification',
        ),
      ),
      body: const Center(
        child: Text('data'),
      ),
    );
  }
}
