import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/credentials_service/credentials_service.dart';
import 'package:jetwallet/features/auth/register/store/register_password_store.dart';
import 'package:jetwallet/features/auth/register/ui/widgets/password_validation/password_validation.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

class RegisterPasswordScreen extends StatelessWidget {
  const RegisterPasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<RegisterPasswordStore>(
      create: (context) => RegisterPasswordStore(),
      builder: (context, child) => const _RegisterPasswordScreenBody(),
      dispose: (context, state) => state.dispose(),
    );
  }
}

class _RegisterPasswordScreenBody extends StatelessObserverWidget {
  const _RegisterPasswordScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = getIt.get<SimpleKit>().colors;

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        getIt.get<CredentialsService>().updateAndValidatePassword('');

        return Future.value(true);
      },
      child: SPageFrame(
        loaderText: intl.register_pleaseWait,
        loading: RegisterPasswordStore.of(context).loader,
        color: colors.grey5,
        header: SPaddingH24(
          child: SBigHeader(
            title: intl.register_createPassword,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: colors.white,
              child: SPaddingH24(
                child: SStandardFieldObscure(
                  controller:
                      RegisterPasswordStore.of(context).passwordController,
                  onChanged: (value) {
                    RegisterPasswordStore.of(context).setPasswordError(false);
                  },
                  labelText: intl.register_password,
                  autofocus: true,
                ),
              ),
            ),
            const SPaddingH24(
              child: PasswordValidation(),
            ),
            const Spacer(),
            SPaddingH24(
              child: SPrimaryButton2(
                active: RegisterPasswordStore.of(context).isButtonActive,
                name: intl.registerPassword_continue,
                onTap: () {
                  RegisterPasswordStore.of(context)
                      .loader
                      .startLoadingImmediately();
                  RegisterPasswordStore.of(context).setDisableContinue(true);

                  getIt
                      .get<CredentialsService>()
                      .authenticate(
                        operation: AuthOperation.register,
                        showError: (error) {
                          RegisterPasswordStore.of(context).showError(error);
                        },
                      )
                      .then(
                    (value) {
                      RegisterPasswordStore.of(context).loader.finishLoading();
                      RegisterPasswordStore.of(context)
                          .setDisableContinue(false);
                    },
                  );
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
