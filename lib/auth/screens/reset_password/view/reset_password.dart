import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/helpers/get_args.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../shared/components/password_validation/password_validation.dart';
import '../notifier/reset_password_notipod.dart';
import '../notifier/reset_password_state.dart';

@immutable
class ResetPasswordArgs {
  const ResetPasswordArgs({
    required this.email,
    required this.code,
  });

  final String email;
  final String code;
}

class ResetPassword extends HookWidget {
  const ResetPassword({Key? key}) : super(key: key);

  static const routeName = '/reset_password';

  static Future push({
    required BuildContext context,
    required ResetPasswordArgs args,
  }) {
    return Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: args,
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = getArgs(context) as ResetPasswordArgs;

    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final reset = useProvider(resetPasswordNotipod(args));
    final resetN = useProvider(resetPasswordNotipod(args).notifier);
    final notificationN = useProvider(sNotificationNotipod.notifier);
    final loader = useValueNotifier(StackLoaderNotifier());
    final disableContinue = useState(false);

    useListenable(loader.value);

    return ProviderListener<ResetPasswordState>(
      provider: resetPasswordNotipod(args),
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
        loaderText: intl.pleaseWait,
        loading: loader.value,
        color: colors.grey5,
        header: SPaddingH24(
          child: SBigHeader(
            title: intl.passwordReset_passwordReset,
          ),
        ),
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: colors.white,
                child: SPaddingH24(
                  child: SStandardFieldObscure(
                    autofillHints: const [AutofillHints.password],
                    onChanged: (value) {
                      resetN.updateAndValidatePassword(value);
                    },
                    labelText: intl.resetPassword_password,
                    autofocus: true,
                  ),
                ),
              ),
              SPaddingH24(
                child: PasswordValidation(
                  password: reset.password,
                ),
              ),
              const Spacer(),
              SPaddingH24(
                child: SPrimaryButton2(
                  active: reset.passwordValid &&
                      !disableContinue.value &&
                      !loader.value.value,
                  name: intl.resetPassword_continue,
                  onTap: () {
                    disableContinue.value = true;
                    loader.value.startLoading();
                    resetN.resetPassword().then((_) {
                      disableContinue.value = false;
                      loader.value.finishLoading();
                    });
                  },
                ),
              ),
              const SpaceH24(),
            ],
          ),
        ),
      ),
    );
  }
}
