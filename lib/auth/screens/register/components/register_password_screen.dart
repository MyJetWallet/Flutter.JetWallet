import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../shared/components/loader.dart';
import '../../../../shared/components/page_frame/page_frame.dart';
import '../../../../shared/components/spacers.dart';
import '../../../../shared/components/text_fields/app_text_field_obscure.dart';
import '../../../../shared/helpers/show_plain_snackbar.dart';
import '../../../shared/components/password_validation/password_validation.dart';
import '../../../shared/notifiers/authentication_notifier/authentication_notifier.dart';
import '../../../shared/notifiers/authentication_notifier/authentication_notipod.dart';
import '../../../shared/notifiers/authentication_notifier/authentication_union.dart';
import '../../../shared/notifiers/credentials_notifier/credentials_notipod.dart';

class RegisterPasswordScreen extends HookWidget {
  const RegisterPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final credentials = useProvider(credentialsNotipod);
    final credentialsN = useProvider(credentialsNotipod.notifier);
    final authenitcation = useProvider(authenticationNotipod);
    final authenitcationN = useProvider(authenticationNotipod.notifier);

    return ProviderListener<AuthenticationUnion>(
      provider: authenticationNotipod,
      onChange: (context, union) {
        union.when(
          input: (error, st) {
            if (error != null) {
              showPlainSnackbar(context, '$error');
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
        child: PageFrame(
          header: 'Create a password',
          onBackButton: () {
            Navigator.pop(context);
            credentialsN.updateAndValidatePassword('');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpaceH40(),
              AppTextFieldObscure(
                header: 'Enter password',
                hintText: 'Enter password',
                onChanged: (value) {
                  credentialsN.updateAndValidatePassword(value);
                },
              ),
              PasswordValidation(
                password: credentials.password,
              ),
              const Spacer(),
              if (authenitcation is Input)
                AppButtonSolid(
                  active: credentialsN.readyToRegister,
                  name: 'Continue',
                  onTap: () {
                    if (credentialsN.readyToRegister) {
                      authenitcationN.authenticate(
                        email: credentials.email,
                        password: credentials.password,
                        operation: AuthOperation.register,
                      );
                    }
                  },
                )
              else ...[
                const Loader(),
                const Spacer(),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
