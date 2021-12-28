import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'authorization_union.dart';

final authorizationStpod = StateProvider<AuthorizationUnion>(
  (ref) {
    return const AuthorizationUnion.unauthorized();
  },
  name: 'authorizationStpod',
);
