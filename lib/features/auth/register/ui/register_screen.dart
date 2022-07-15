import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/credentials_service/credentials_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/auth/register/store/register_store.dart';
import 'package:jetwallet/features/auth/register/ui/widgets/referral_code/referral_code.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getIt.get<SimpleAnalytics>().signUpView();

    return Provider<RegisterStore>(
      create: (context) => RegisterStore(),
      builder: (context, child) => const _RegisterScreenBody(),
      dispose: (context, state) => state.dispose(),
    );
  }
}

class _RegisterScreenBody extends StatelessObserverWidget {
  const _RegisterScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sKit = getIt.get<SimpleKit>();

    return SPageFrame(
      header: SPaddingH24(
        child: SBigHeader(
          title: intl.register_enterYourEmail,
        ),
      ),
      child: CustomScrollView(
        controller: RegisterStore.of(context).customScrollController,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: sKit.colors.white,
                    child: SPaddingH24(
                      child: SStandardField(
                        controller: RegisterStore.of(context).emailController,
                        focusNode: RegisterStore.of(context).emailFocusNode,
                        labelText: intl.login_emailTextFieldLabel,
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp('[ ]')),
                        ],
                        onErrorIconTap: () =>
                            RegisterStore.of(context).showError(),
                        isError: RegisterStore.of(context).emailError,
                      ),
                    ),
                  ),
                  const SpaceH19(),
                  const ReferralCode(),
                  const Spacer(),
                  Container(
                    color: sKit.colors.grey5,
                    child: SPaddingH24(
                      child: SPolicyCheckbox(
                        firstText: '${intl.register_herebyConfirm} ',
                        userAgreementText: intl.register_TAndC,
                        betweenText: ' ${intl.register_andThe} ',
                        privacyPolicyText: intl.register_privacyPolicy,
                        isChecked:
                            getIt.get<CredentialsService>().policyChecked,
                        onCheckboxTap: () {
                          RegisterStore.of(context).scrollToBottom();
                          getIt.get<CredentialsService>().setPolicyChecked();
                        },
                        onUserAgreementTap: () {
                          launchURL(context, userAgreementLink);
                        },
                        onPrivacyPolicyTap: () {
                          launchURL(context, privacyPolicyLink);
                        },
                      ),
                    ),
                  ),
                  const SpaceH16(),
                  SPaddingH24(
                    child: SPrimaryButton2(
                      active: getIt
                          .get<CredentialsService>()
                          .emailIsNotEmptyAndPolicyChecked,
                      name: intl.register_continue,
                      onTap: () {
                        if (getIt.get<CredentialsService>().emailValid) {
                          //RegisterPasswordScreen.push(context);
                          getIt
                              .get<AppRouter>()
                              .push(const RegisterPasswordRoute());
                        } else {
                          RegisterStore.of(context).setEmailError(true);

                          RegisterStore.of(context).showError();
                        }
                      },
                    ),
                  ),
                  const SpaceH24(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
