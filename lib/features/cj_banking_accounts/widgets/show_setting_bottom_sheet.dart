import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/cj_banking_accounts/screens/show_account_details_screen.dart';
import 'package:jetwallet/features/simple_card/ui/widgets/card_option.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

void showAccountSettings({
  required BuildContext context,
  required void Function() onChangeLableTap,
  required SimpleBankingAccount bankingAccount,
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
        bankingAccount: bankingAccount,
      ),
    ],
  );
}

class _CardSettings extends StatelessObserverWidget {
  const _CardSettings({
    required this.onChangeLableTap,
    required this.bankingAccount,
  });

  final void Function() onChangeLableTap;
  final SimpleBankingAccount bankingAccount;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Column(
      children: [
        CardOption(
          icon: Assets.svg.medium.document.simpleSvg(
            color: colors.blue,
          ),
          name: intl.account_settings_account_requisites,
          onTap: () {
            sRouter.pop();
            showAccountDetails(
              context: context,
              onClose: () {},
              bankingAccount: bankingAccount,
            );
          },
          hideDescription: true,
        ),
        CardOption(
          icon: Assets.svg.medium.edit.simpleSvg(
            color: colors.blue,
          ),
          name: intl.account_settings_change_label,
          onTap: onChangeLableTap,
          hideDescription: true,
        ),
        const SpaceH60(),
      ],
    );
  }
}
