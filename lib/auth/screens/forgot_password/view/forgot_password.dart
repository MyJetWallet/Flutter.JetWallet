import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/helpers/get_args.dart';
import '../../../../shared/providers/service_providers.dart';
import '../notifier/forgot_password/forgot_password_notipod.dart';
import '../notifier/forgot_password/forgot_password_state.dart';

@immutable
class ForgotPasswordArgs {
  const ForgotPasswordArgs({
    required this.email,
  });

  final String email;
}

class ForgotPassword extends HookWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  static const routeName = '/forgot_password';

  static Future push({
    required BuildContext context,
    required ForgotPasswordArgs args,
  }) {
    return Navigator.pushNamed(context, routeName, arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    final args = getArgs(context) as ForgotPasswordArgs;

    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final forgot = useProvider(forgotPasswordNotipod(args));
    final forgotN = useProvider(forgotPasswordNotipod(args).notifier);
    final notificationN = useProvider(sNotificationNotipod.notifier);
    final emailError = useValueNotifier(StandardFieldErrorNotifier());
    final loader = useValueNotifier(StackLoaderNotifier());
    final disableContinue = useState(false);

    useListenable(loader.value);

    return ProviderListener<ForgotPasswordState>(
      provider: forgotPasswordNotipod(args),
      onChange: (context, state) {
        state.union.maybeWhen(
          error: (error) {
            disableContinue.value = false;
            loader.value.finishLoading();
            notificationN.showError('$error', id: 1);
          },
          orElse: () {},
        );
      },
      child: SPageFrame(
        loaderText: intl.forgotPassword_pleaseWait,
        loading: loader.value,
        color: colors.grey5,
        header: SPaddingH24(
          child: SBigHeader(
            title: intl.forgotPassword_forgotPassword,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: colors.white,
              child: Column(
                children: [
                  const SpaceH7(),
                  SPaddingH24(
                    child: Text(
                      intl.forgotPassword_resettingPassword,
                      style: sBodyText1Style.copyWith(
                        color: colors.grey1,
                      ),
                      maxLines: 3,
                    ),
                  ),
                  const SpaceH16(),
                ],
              ),
            ),
            Container(
              color: colors.white,
              child: SPaddingH24(
                child: SStandardField(
                  labelText: intl.login_emailTextFieldLabel,
                  autofocus: true,
                  initialValue: forgot.email,
                  autofillHints: const [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    emailError.value.disableError();
                    forgotN.updateAndValidateEmail(value);
                  },
                  onErrorIconTap: () {
                    notificationN.showError(
                      '${intl.forgotPassword_error}?',
                      id: 2,
                    );
                  },
                  errorNotifier: emailError.value,
                ),
              ),
            ),
            const Spacer(),
            SPaddingH24(
              child: SPrimaryButton2(
                active: forgot.email.isNotEmpty &&
                    !disableContinue.value &&
                    !loader.value.value,
                name: intl.forgotPassword_resetPassword,
                onTap: () {
                  if (forgot.emailValid) {
                    disableContinue.value = true;
                    loader.value.startLoading();
                    forgotN.sendRecoveryLink().then((_) {
                      disableContinue.value = false;
                      loader.value.finishLoading();
                    });
                  } else {
                    emailError.value.enableError();
                    notificationN.showError(
                      '${intl.forgotPassword_error}?',
                      id: 2,
                    );
                  }
                },
              ),
            ),
            const SpaceH24(),
          ],
        ),
      ),
    );
  }
}
