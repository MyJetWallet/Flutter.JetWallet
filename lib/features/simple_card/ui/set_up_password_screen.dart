import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/simple_card/ui/widgets/password_requirement.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/di/di.dart';
import '../../../core/services/local_storage_service.dart';
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

    final colors = sKit.colors;

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      resizeToAvoidBottomInset: false,
      color: colors.grey5,
      loading: isCreatePassword ? simpleCardStore.loader : store.loader,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.simple_card_password_title,
          subTitle: intl.simple_card_password_subtitle,
          subTitleStyle: sBodyText2Style.copyWith(
            color: colors.grey1,
          ),
          showBackButton: false,
          onCLoseButton: () => Navigator.pop(context),
          showCloseButton: true,
        ),
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
                    style: sBodyText1Style.copyWith(
                      color: colors.grey1,
                    ),
                    maxLines: 10,
                  ),
                ],
              ),
            ),
          ),
          SFieldDividerFrame(
            child: SStandardFieldObscure(
              controller: store.passwordController,
              labelText: intl.simple_card_password_create,
              isError: store.passwordError,
              onChanged: store.setPassword,
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
                      child: SPrimaryButton1(
                        active: store.isButtonSaveActive,
                        name: intl.simple_card_password_continue,
                        onTap: () async {
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

                          if (isCreatePassword) {
                            final storageService = getIt.get<LocalStorageService>();

                            final pin = await storageService.getValue(pinStatusKey);
                            await simpleCardStore.createCard(pin ?? '', store.password);
                          } else {
                            await store.setCardPassword(simpleCardStore.cardFull?.cardId ?? '');
                          }
                        },
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
