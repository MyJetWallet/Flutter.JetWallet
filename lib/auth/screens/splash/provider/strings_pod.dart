import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/strings.dart';

final stringsPod = Provider<Strings>((ref) {
  return Strings();
});
