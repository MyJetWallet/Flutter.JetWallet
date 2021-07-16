// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../../../../shared/providers/other/navigator_key_pod.dart';
// import '../../../../shared/providers/service_providers.dart';
// import '../../../shared/notifiers/credentials_notifier/credentials_notipod.dart';
// import 'reset_password_notifier.dart';
// import 'reset_password_union.dart';

// final resetPasswordNotipod =
//     StateNotifierProvider<ResetPasswordNotifier, ResetPasswordUnion>(
//   (ref) {
//     final credentials = ref.watch(credentialsNotipod);
//     final credentialsN = ref.watch(credentialsNotipod.notifier);
//     final authService = ref.watch(authServicePod);
//     final navigatorKey = ref.watch(navigatorKeyPod);

//     return ResetPasswordNotifier(
//       credentials: credentials,
//       credentialsN: credentialsN,
//       authService: authService,
//       navigatorKey: navigatorKey,
//     );
//   },
// );
