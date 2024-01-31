import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../core/di/di.dart';
import '../../../pin_screen/model/pin_flow_union.dart';
import '../../../pin_screen/ui/pin_screen.dart';
import '../../store/simple_card_store.dart';
import 'card_option.dart';

void showCardOptions(
  BuildContext context,
) {
  sAnalytics.viewCardTypeSheet();

  sShowBasicModalBottomSheet(
    context: context,
    then: (value) {},
    pinned: SBottomSheetHeader(
      name: intl.simple_card_type,
    ),
    children: [
      const _CardOptions(),
    ],
  );
}

class _CardOptions extends StatelessObserverWidget {
  const _CardOptions();

  @override
  Widget build(BuildContext context) {
    final simpleCardStore = getIt.get<SimpleCardStore>();

    void onAddCardTap() {
      sAnalytics.tapOnVirtualCard();
      Navigator.pop(context);
      sAnalytics.confirmWithPinView();
      Navigator.push(
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
                simpleCardStore.gotToSetup();
              },
              onBackPressed: () {
                Navigator.pop(context);
              },
              onWrongPin: (String error) {},
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    }

    return Column(
      children: [
        CardOption(
          icon: const SActionDepositIcon(),
          name: intl.simple_card_type_virtual,
          onTap: onAddCardTap,
          hideDescription: true,
          isActive: true,
        ),
        CardOption(
          icon: const SActionDepositIcon(),
          name: intl.simple_card_type_physical,
          description: intl.simple_card_type_coming_soon,
          isDisabled: true,
          onTap: () {},
        ),
        const SpaceH56(),
      ],
    );
  }
}
