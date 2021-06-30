import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'authorized_union.dart';

final authorizedStpod = StateProvider<AuthorizedUnion>((ref) {
  return const AuthorizedUnion.initial();
});
