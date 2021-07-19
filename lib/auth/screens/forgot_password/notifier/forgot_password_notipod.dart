// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../../../../shared/providers/service_providers.dart';
// import '../../../shared/notifiers/credentials_notifier/credentials_notipod.dart';
// import 'forgot_password_notifier.dart';
// import 'forgot_password_union.dart';

// final forgotPasswordNotipod =
//     StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordUnion>(
//   (ref) {
//     final credentials = ref.watch(credentialsNotipod);
//     final credentialsN = ref.watch(credentialsNotipod.notifier);
//     final authService = ref.watch(authServicePod);

//     return ForgotPasswordNotifier(
//       credentials: credentials,
//       credentialsN: credentialsN,
//       authService: authService,
//     );
//   },
// );
