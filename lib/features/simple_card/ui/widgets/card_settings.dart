import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/simple_card/ui/set_up_password_screen.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../../../core/di/di.dart';
import '../../store/simple_card_store.dart';

void showCardSettings({
  required BuildContext context,
  required void Function() onChangeLableTap,
  required void Function() onFreezeTap,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    then: (value) {},
    pinned: SBottomSheetHeader(
      name: intl.simple_card_settings,
    ),
    children: [
      _CardSettings(
        onChangeLableTap: onChangeLableTap,
        onFreezeTap: onFreezeTap,
      ),
    ],
  );
}

class _CardSettings extends StatelessObserverWidget {
  const _CardSettings({
    required this.onChangeLableTap,
    required this.onFreezeTap,
  });

  final void Function() onChangeLableTap;
  final void Function() onFreezeTap;

  @override
  Widget build(BuildContext context) {
    final simpleCardStore = getIt.get<SimpleCardStore>();
    final colors = sKit.colors;

    return Column(
      children: [
        SimpleTableAsset(
          assetIcon: Assets.svg.medium.document.simpleSvg(
            color: colors.blue,
          ),
          label: intl.simple_card_spending_limits,
          hasRightValue: false,
          onTableAssetTap: () {
            sAnalytics.tapOnTheSpendingVirtualCardLimitsButton(cardID: simpleCardStore.cardFull?.cardId ?? '');
            sRouter
                .push(
              SimpleCardLimitsRouter(
                cardId: simpleCardStore.cardFull?.cardId ?? '',
                cardLable: simpleCardStore.cardFull?.label ?? '',
              ),
            )
                .then((value) {
              sAnalytics.tapOnTheBackFromSpendingVirtualCardLimitsButton(
                cardID: simpleCardStore.cardFull?.cardId ?? '',
              );
            });
          },
        ),
        SimpleTableAsset(
          assetIcon: SEyeOpenIcon(color: colors.blue),
          label: intl.simple_card_remind_pin,
          hasRightValue: false,
          onTableAssetTap: () {
            simpleCardStore.remindPinPhone();
          },
        ),
        SimpleTableAsset(
          assetIcon: SSecurityIcon(color: colors.blue),
          label: intl.simple_card_set_password,
          supplement: intl.simple_card_online_purchases,
          hasRightValue: false,
          onTableAssetTap: () {
            sAnalytics.tapOnSetPassword(cardID: simpleCardStore.cardFull?.cardId ?? '');
            sAnalytics.viewConfirmWithPin(cardID: simpleCardStore.cardFull?.cardId ?? '');
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                barrierColor: Colors.white,
                pageBuilder: (BuildContext _, __, ___) {
                  return const SetUpPasswordScreen(
                    isCreatePassword: false,
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
            ).then((value) async {});
          },
        ),
        SimpleTableAsset(
          assetIcon: Assets.svg.medium.edit.simpleSvg(
            color: colors.blue,
          ),
          label: intl.simple_card_settings_change_label,
          hasRightValue: false,
          onTableAssetTap: onChangeLableTap,
        ),
        SimpleTableAsset(
          assetIcon: Assets.svg.medium.freeze.simpleSvg(
            color: colors.blue,
          ),
          label: intl.simple_card_settings_freeze_card,
          hasRightValue: false,
          onTableAssetTap: onFreezeTap,
        ),
        SimpleTableAsset(
          assetIcon: Assets.svg.medium.delete.simpleSvg(
            color: colors.red,
          ),
          label: intl.simple_card_terminate_card,
          hasRightValue: false,
          onTableAssetTap: () {
            sRouter.pop();
            simpleCardStore.terminateCard();
          },
        ),
        const SpaceH45(),
      ],
    );
  }
}
