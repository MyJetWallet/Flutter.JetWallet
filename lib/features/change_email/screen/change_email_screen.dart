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
import 'package:simple_kit/simple_kit.dart';
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

class _ChangeEmailBody extends StatelessWidget {
  _ChangeEmailBody(this.pin);

  final String pin;

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final credentials = getIt.get<CredentialsService>();
    final changeEmailStore = ChangeEmailStore.of(context);

    final controller = ScrollController();

    return SPageFrame(
      loaderText: '',
      color: colors.grey5,
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
          final loading = ChangeEmailStore.of(context).isLoading;

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
                        child: SPaddingH24(
                          child: AutofillGroup(
                            child: SStandardField(
                              grayLabel: true,
                              readOnly: true,
                              enabled: false,
                              controller:
                                  TextEditingController(text: getIt.get<AppStore>().authState.email.toLowerCase()),
                              labelText: intl.change_email_current_email,
                              hideClearButton: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                      ColoredBox(
                        color: colors.white,
                        child: SPaddingH24(
                          child: AutofillGroup(
                            child: SStandardField(
                              controller: emailController,
                              labelText: intl.change_email_new_email,
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
                                  ChangeEmailStore.of(context).setIsEmailError(false);
                                }
                              },
                              onErase: () {
                                ChangeEmailStore.of(context).setIsEmailError(false);
                              },
                              hideClearButton: credentials.email.isEmpty,
                              onErrorIconTap: () {
                                sNotification.showError(
                                  intl.register_invalidEmail,
                                );
                              },
                              isError: ChangeEmailStore.of(context).isEmailError,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      SPaddingH24(
                        child: SButton.blue(
                          isLoading: loading,
                          text: intl.register_continue,
                          callback: () {
                            if (credentials.emailValid) {
                              ChangeEmailStore.of(context).setIsEmailError(false);

                              changeEmailStore.changeEmail(emailController.text, pin);
                            } else {
                              ChangeEmailStore.of(context).setIsEmailError(true);

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
