import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../shared/providers/service_providers.dart';
import '../../shared/components/password_validation/password_validation.dart';
import '../../shared/notifiers/authentication_notifier/authentication_notifier.dart';
import '../../shared/notifiers/authentication_notifier/authentication_notipod.dart';
import '../../shared/notifiers/authentication_notifier/authentication_union.dart';
import '../../shared/notifiers/credentials_notifier/credentials_notipod.dart';

class RegisterPasswordScreen extends HookWidget {
  const RegisterPasswordScreen({Key? key}) : super(key: key);

  static const routeName = '/register_password_screen';

  static Future push(BuildContext context) {
    return Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final credentials = useProvider(credentialsNotipod);
    final credentialsN = useProvider(credentialsNotipod.notifier);
    final authenticationN = useProvider(authenticationNotipod.notifier);
    final notificationN = useProvider(sNotificationNotipod.notifier);
    final loader = useValueNotifier(StackLoaderNotifier());
    final disableContinue = useState(false);

    return ProviderListener<AuthenticationUnion>(
      provider: authenticationNotipod,
      onChange: (context, union) {
        union.when(
          input: (error, st) {
            if (error != null) {
              disableContinue.value = false;
              loader.value.finishLoading();
              notificationN.showError(
                '$error',
                id: 1,
              );
            }
          },
          loading: () {},
        );
      },
      child: WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          credentialsN.updateAndValidatePassword('');
          return Future.value(true);
        },
        child: SPageFrame(
          loaderText: intl.register_pleaseWait,
          loading: loader.value,
          color: colors.grey5,
          header: SPaddingH24(
            child: SBigHeader(
              title: intl.register_createPassword,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ColoredBox(
                color: colors.white,
                child: SPaddingH24(
                  child: SStandardFieldObscure(
                    onChanged: (value) {
                      credentialsN.updateAndValidatePassword(value);
                    },
                    labelText: intl.register_password,
                    autofocus: true,
                  ),
                ),
              ),
              SPaddingH24(
                child: PasswordValidation(
                  password: credentials.password,
                ),
              ),
              const Spacer(),
              SPaddingH24(
                child: SPrimaryButton2(
                  active: credentials.readyToRegister &&
                      !disableContinue.value &&
                      !loader.value.value,
                  name: intl.registerPassword_continue,
                  onTap: () {
                    disableContinue.value = true;
                    loader.value.startLoading();
                    authenticationN.authenticate(
                      email: credentials.email,
                      password: credentials.password,
                      operation: AuthOperation.register,
                      marketingEmailsAllowed: credentials.mailingChecked,
                    );
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
