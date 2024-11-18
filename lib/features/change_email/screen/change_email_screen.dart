import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/credentials_service/credentials_service.dart';
import 'package:jetwallet/core/services/intercom/intercom_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/change_email/store/change_email_store.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'ChangeEmailRouter')
class ChangeEmailScreen extends StatelessWidget {
  const ChangeEmailScreen({
    required this.pin,
    super.key,
  });

  final String pin;

  @override
  Widget build(BuildContext context) {
    return Provider<ChangeEmailStore>(
      create: (context) => ChangeEmailStore(),
      builder: (context, child) => _ChangeEmailBody(pin),
    );
  }
}

class _ChangeEmailBody extends StatelessObserverWidget {
  _ChangeEmailBody(this.pin);

  final String pin;

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    final credentials = getIt.get<CredentialsService>();
    final changeEmailStore = ChangeEmailStore.of(context);

    final controller = ScrollController();

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      loading: changeEmailStore.loader,
      color: colors.gray2,
      header: SimpleLargeAppbar(
        title: intl.change_email_enter_new_email,
        hasRightIcon: true,
        titleMaxLines: 2,
        rightIcon: SafeGesture(
          onTap: () async {
            if (showZendesk) {
              await getIt.get<IntercomService>().login();
              await getIt.get<IntercomService>().showMessenger();
            } else {
              await sRouter.push(
                CrispRouter(
                  welcomeText: intl.crispSendMessage_hi,
                ),
              );
            }
          },
          child: Assets.svg.medium.chat.simpleSvg(),
        ),
      ),
      child: Observer(
        builder: (context) {
          return CustomScrollView(
            physics: const ClampingScrollPhysics(),
            controller: controller,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ColoredBox(
                        color: colors.white,
                        child: AutofillGroup(
                          child: SInput(
                            isDisabled: true,
                            controller:
                                TextEditingController(text: getIt.get<AppStore>().authState.email.toLowerCase()),
                            label: intl.change_email_current_email,
                          ),
                        ),
                      ),
                      ColoredBox(
                        color: colors.white,
                        child: AutofillGroup(
                          child: SInput(
                            controller: emailController,
                            label: intl.change_email_new_email,
                            autofocus: true,
                            autofillHints: const [AutofillHints.email],
                            keyboardType: TextInputType.emailAddress,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                RegExp('[ ]'),
                              ),
                            ],
                            onChanged: (value) {
                              credentials.updateAndValidateEmail(value);
                        
                              if (value.isEmpty) {
                                changeEmailStore.setIsEmailError(false);
                              }
                              if (credentials.emailValid && changeEmailStore.isEmailError) {
                                changeEmailStore.setIsEmailError(false);
                              }
                            },
                            onCloseIconTap: () {
                              changeEmailStore.setIsEmailError(false);
                            },
                            hasCloseIcon: credentials.email.isNotEmpty,
                            onErrorIconTap: () {
                              sNotification.showError(
                                intl.register_invalidEmail,
                              );
                            },
                            hasErrorIcon: changeEmailStore.isEmailError,
                          ),
                        ),
                      ),
                      const Spacer(),
                      SPaddingH24(
                        child: SButton.blue(
                          text: intl.register_continue,
                          callback: () {
                            if (credentials.emailValid) {
                              changeEmailStore.setIsEmailError(false);

                              changeEmailStore.changeEmail(emailController.text, pin);
                            } else {
                              changeEmailStore.setIsEmailError(true);

                              sNotification.showError(intl.register_invalidEmail);
                            }
                          },
                        ),
                      ),
                      const SpaceH42(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
