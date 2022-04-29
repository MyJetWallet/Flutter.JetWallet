import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/question/simple_light_question_icon.dart';

class SQuestionIcon extends ConsumerWidget {
  const SQuestionIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightQuestionIcon();
    } else {
      return const SimpleLightQuestionIcon();
    }
  }
}
