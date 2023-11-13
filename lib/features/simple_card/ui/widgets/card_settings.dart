import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/simple_card/ui/set_up_password_screen.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../core/di/di.dart';
import '../../store/simple_card_store.dart';
import 'card_option.dart';

void showCardSettings(
  BuildContext context,
) {

  sShowBasicModalBottomSheet(
    context: context,
    then: (value) {},
    pinned: SBottomSheetHeader(
      name: intl.simple_card_settings,
    ),
    children: [
      const _CardSettings(),
    ],
  );
}

class _CardSettings extends StatelessObserverWidget {
  const _CardSettings();

  @override
  Widget build(BuildContext context) {
    final simpleCardStore = getIt.get<SimpleCardStore>();
    final colors = sKit.colors;

    return Column(
      children: [
        // CardOption(
        //   icon: SAccountIcon(color: colors.blue),
        //   name: intl.simple_card_spending_limits,
        //   onTap: () {},
        //   hideDescription: true,
        // ),
        CardOption(
          icon: SEyeOpenIcon(color: colors.blue),
          name: intl.simple_card_remind_pin,
          onTap: () {
            simpleCardStore.remindPinPhone();
          },
          hideDescription: true,
        ),
        CardOption(
          icon: SSecurityIcon(color: colors.blue),
          name: intl.simple_card_set_password,
          description: intl.simple_card_online_purchases,
          onTap: () {
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

                  final tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            ).then((value) async {});
          },
        ),
        const SpaceH40(),
      ],
    );
  }
}
