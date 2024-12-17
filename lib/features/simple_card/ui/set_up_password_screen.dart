import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/simple_card/ui/widgets/password_requirement.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';

import '../../../core/di/di.dart';
import '../../../core/services/local_storage_service.dart';
import '../../pin_screen/model/pin_flow_union.dart';
import '../../pin_screen/ui/pin_screen.dart';
import '../store/set_up_password_store.dart';
import '../store/simple_card_store.dart';

class SetUpPasswordScreen extends StatelessWidget {
  const SetUpPasswordScreen({
    super.key,
    required this.isCreatePassword,
  });

  final bool isCreatePassword;

  @override
  Widget build(BuildContext context) {
    return Provider<SetUpPasswordStore>(
      create: (context) => SetUpPasswordStore(),
      builder: (context, child) => _SetUpPasswordScreenBody(
        isCreatePassword: isCreatePassword,
      ),
    );
  }
}

class _SetUpPasswordScreenBody extends StatelessObserverWidget {
  const _SetUpPasswordScreenBody({
    required this.isCreatePassword,
  });

  final bool isCreatePassword;

  @override
  Widget build(BuildContext context) {
    final store = SetUpPasswordStore.of(context);
    final simpleCardStore = getIt.get<SimpleCardStore>();

    final colors = SColorsLight();

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      resizeToAvoidBottomInset: false,
      color: colors.gray2,
      loading: isCreatePassword ? simpleCardStore.loader : store.loader,
      header: GlobalBasicAppBar(
        title: intl.simple_card_password_title,
        subtitle: intl.simple_card_password_subtitle,
        hasLeftIcon: false,
        onRightIconTap: () {
          sAnalytics.tapCloseSetUpPassword(
            cardID: simpleCardStore.cardFull?.cardId ?? '',
          );
          Navigator.pop(context);
        },
      ),
      child: Column(
        children: [
          ColoredBox(
            color: colors.white,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    intl.simple_card_password_description,
                    style: STStyles.body1Medium.copyWith(
                      color: colors.gray10,
                    ),
                    maxLines: 10,
                  ),
                ],
              ),
            ),
          ),
          SInput(
            controller: store.passwordController,
            label: intl.simple_card_password_create,
            hasErrorIcon: store.passwordError,
            onChanged: store.setPassword,
            maxLength: 29,
            autofocus: true,
            obscureText: store.hidePassword,
            suffixIcon: SafeGesture(
              onTap: () {
                if (store.hidePassword) {
                  sAnalytics.tapShowSetupPassword(
                    cardID: simpleCardStore.cardFull?.cardId ?? '',
                  );
                  store.setHidePassword(false);
                } else {
                  sAnalytics.tapHideSetupPassword(
                    cardID: simpleCardStore.cardFull?.cardId ?? '',
                  );
                  store.setHidePassword(true);
                }
              },
              child: store.hidePassword ? Assets.svg.medium.show.simpleSvg() : Assets.svg.medium.hide.simpleSvg(),
            ),
          ),
          const SpaceH16(),
          PasswordRequirement(
            name: intl.simple_card_password_rule_1,
            isApproved: store.isBigSymbolsApproved,
          ),
          PasswordRequirement(
            name: intl.simple_card_password_rule_2,
            isApproved: store.isSmallSymbolsApproved,
          ),
          PasswordRequirement(
            name: intl.simple_card_password_rule_3,
            isApproved: store.isNumbersApproved,
          ),
          PasswordRequirement(
            name: intl.simple_card_password_rule_4,
            isApproved: store.isPasswordLengthApproved,
          ),
          const SpaceH16(),
          const Spacer(),
          Observer(
            builder: (BuildContext context) {
              return SPaddingH24(
                child: Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: SButton.black(
                        text: intl.simple_card_password_continue,
                        callback: store.isButtonSaveActive
                            ? () async {
                                sAnalytics.tapContinueSetupPassword(
                                  cardID: simpleCardStore.cardFull?.cardId ?? '',
                                );
                                if (store.canClick) {
                                  store.setCanClick(false);
                                  Timer(
                                    const Duration(
                                      seconds: 2,
                                    ),
                                    () => store.setCanClick(true),
                                  );
                                } else {
                                  return;
                                }

                                if (!store.preContinueCheck()) return;

                                if (isCreatePassword) {
                                  final storageService = getIt.get<LocalStorageService>();

                                  final pin = await storageService.getValue(pinStatusKey);
                                  await simpleCardStore.createCard(
                                    pin ?? '',
                                    store.password,
                                  );
                                } else {
                                  sAnalytics.viewConfirmWithPin(
                                    cardID: simpleCardStore.cardFull?.cardId ?? '',
                                  );
                                  await Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      barrierColor: Colors.white,
                                      pageBuilder: (BuildContext context, _, __) {
                                        return PinScreen(
                                          union: const Change(),
                                          isConfirmCard: true,
                                          isChangePhone: true,
                                          onChangePhone: (String newPin) {
                                            store.setCardPassword(
                                              simpleCardStore.cardFull?.cardId ?? '',
                                            );
                                          },
                                          onBackPressed: () {
                                            Navigator.pop(context);
                                          },
                                          onWrongPin: (String error) {},
                                        );
                                      },
                                      transitionsBuilder: (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        const begin = Offset(0.0, 1.0);
                                        const end = Offset.zero;
                                        const curve = Curves.ease;

                                        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                }
                              }
                            : null,
                      ),
                    ),
                    const SpaceH42(),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
