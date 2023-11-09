import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/simple_card/ui/widgets/password_requirements.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/di/di.dart';
import '../store/set_up_password_store.dart';
import '../store/simple_card_store.dart';

class SetUpPasswordScreen extends StatelessWidget {
  const SetUpPasswordScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Provider<SetUpPasswordStore>(
      create: (context) => SetUpPasswordStore(),
      builder: (context, child) => const _SetUpPasswordScreenBody(),
    );
  }
}

class _SetUpPasswordScreenBody extends StatelessObserverWidget {
  const _SetUpPasswordScreenBody();

  @override
  Widget build(BuildContext context) {
    final store = SetUpPasswordStore.of(context);
    final simpleCardStore = getIt.get<SimpleCardStore>();

    final colors = sKit.colors;

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      resizeToAvoidBottomInset: false,
      color: colors.grey5,
      loading: store.loader,
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
                  const SpaceH12(),
                  SLinkButtonText(
                    mainAxisAlignment: MainAxisAlignment.start,
                    textStyle: sBodyText1Style,
                    active: true,
                    name: intl.simple_card_password_requirements,
                    onTap: () {
                      showPasswordRequirements(context);
                    },
                    activeColor: colors.black,
                    inactiveColor: colors.grey1,
                    defaultIcon: SBlueRightArrowIcon(
                      color: colors.grey3,
                    ),
                    pressedIcon: SBlueRightArrowIcon(
                      color: colors.grey3,
                    ),
                    inactiveIcon: SBlueRightArrowIcon(
                      color: colors.grey3,
                    ),
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
          const Spacer(),
          SPaddingH24(
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

                      await store.setCardPassword(simpleCardStore.cardFull?.cardId ?? simpleCardStore.card?.cardId ?? '');
                    },
                  ),
                ),
                const SpaceH10(),
                STextButton1(
                  active: true,
                  name: intl.simple_card_password_cancel,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SpaceH42(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
