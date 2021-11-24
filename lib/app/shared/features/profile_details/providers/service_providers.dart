import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/change_password/service/change_password_service.dart';
import '../../../../../shared/providers/service_providers.dart';

final changePasswordPod = Provider<ChangePasswordService>((ref) {
  final dio = ref.watch(dioPod);

  return ChangePasswordService(dio);
});
