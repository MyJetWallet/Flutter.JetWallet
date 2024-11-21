import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/features/home/store/bottom_bar_store.dart';
import 'package:jetwallet/features/wallet/helper/navigate_to_wallet.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

Future<void> showInsufficientBalanceAccountPopup({
  required BuildContext context,
}) async {
  final asset = getIt<FormatService>().findCurrency(
    assetSymbol: 'USDT',
  );

  await sShowAlertPopup(
    context,
    primaryText: intl.crypto_card_insufficient_balance_title,
    secondaryText: intl.crypto_card_insufficient_balance_description,
    primaryButtonName: intl.crypto_card_insufficient_balance_deposit,
    onPrimaryButtonTap: () async {
      sRouter.popUntilRoot();
      getIt<BottomBarStore>().setHomeTab(BottomItemType.home);
      navigateToWallet(context, asset, isSinglePage: true);
    },
    secondaryButtonName: intl.crypto_card_insufficient_balance_back,
    onSecondaryButtonTap: () {
      sRouter.popUntilRoot();
      getIt<BottomBarStore>().setHomeTab(BottomItemType.home);
    },
  );
}
