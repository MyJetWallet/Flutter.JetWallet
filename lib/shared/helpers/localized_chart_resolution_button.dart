import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/service_providers.dart';

List<String> localizedChartResolutionButton(
    BuildContext context,
    ) {
  final intl = context.read(intlPod);

  final array = [intl.d, intl.w, intl.m, intl.y, intl.all];

  return array;
}
