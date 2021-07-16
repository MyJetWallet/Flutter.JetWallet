// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../../../../../shared/components/spacers.dart';
// import '../../../../shared/components/loader.dart';
// import '../../../shared/components/auth_button_solid.dart';
// import '../../../shared/components/auth_frame/components/auth_header_text.dart';
// import '../../../shared/helpers/open_email_app.dart';
// import '../../../shared/notifiers/credentials_notifier/credentials_notipod.dart';
// import '../notifier/forgot_password_notipod.dart';
// import '../notifier/forgot_password_union.dart';

// class ForgotPassword extends HookWidget {
//   const ForgotPassword({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // final credentials = useProvider(credentialsNotipod);
//     final forgotPassword = useProvider(forgotPasswordNotipod);
//     final notifier = useProvider(forgotPasswordNotipod.notifier);

//     return Scaffold(
//       body: ProviderListener<ForgotPasswordUnion>(
//         provider: forgotPasswordNotipod,
//         onChange: (context, union) {
//           union.when(
//             input: (e, st) {
//               if (e != null) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text(e.toString())),
//                 );
//               }
//             },
//             loading: () {},
//           );
//         },
//         child: forgotPassword.when(
//           input: (_, __) {
//             return SafeArea(
//               child: Form(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 20.w,
//                     vertical: 20.h,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       const AuthHeaderText(
//                         text: 'Forgot Password',
//                       ),
//                       const SpaceH15(),
//                       const Text(
//                         'Enter your email. '
//                         'We will send recovery link to your email.',
//                         textAlign: TextAlign.start,
//                       ),
//                       // EmailTextField(
//                       //   controller: credentials.emailController,
//                       // ),
//                       EmailTextField(
//                         controller: TextEditingController(),
//                       ),
//                       const Spacer(),
//                       AuthButtonGrey(
//                         text: 'Confirm',
//                         onTap: () => notifier.sendRecoveryLink(),
//                       ),
//                       const SpaceH15(),
//                       AuthButtonGrey(
//                         text: 'Open My Email',
//                         onTap: () => openEmailApp(context),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//           loading: () => const Loader(),
//         ),
//       ),
//     );
//   }
// }
