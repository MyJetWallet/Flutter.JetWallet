import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'education_news_notifier.dart';
import 'education_news_state.dart';

final educationNewsNotipod =
StateNotifierProvider.autoDispose<EducationNewsNotifier, EducationNewsState>(
      (ref) {
    return EducationNewsNotifier(
      read: ref.read,
    );
  },
);
