import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import '../service/kyc_operation_service.dart';

// Todo: move provider to all providers
final kycAlertHandlerPod =
    Provider.family<KycAlertHandler, BuildContext>(
  (ref, context) {
    final colors = ref.read(sColorPod);

    return KycAlertHandler(context, colors);
  },
  name: 'kycAlertHandlerPod',
);
