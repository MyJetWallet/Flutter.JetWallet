import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/kyc/simple_light_document_icon.dart';

class SDocumentIcon extends ConsumerWidget {
  const SDocumentIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightDocumentIcon();
    } else {
      return const SimpleLightDocumentIcon();
    }
  }
}
