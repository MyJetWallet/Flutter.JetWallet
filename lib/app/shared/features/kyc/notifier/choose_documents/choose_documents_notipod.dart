import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'choose_documents_notifier.dart';
import 'choose_documents_state.dart';

final chooseDocumentsNotipod = StateNotifierProvider.autoDispose<
    ChooseDocumentsNotifier, ChooseDocumentsState>((
  ref,
) {
  return ChooseDocumentsNotifier(
    read: ref.read,
  );
});
