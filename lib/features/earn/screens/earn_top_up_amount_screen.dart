import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/anchors/anchors_helper.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/suggestion_button_widget.dart';
import 'package:jetwallet/features/earn/store/earn_top_up_amount_store.dart';
import 'package:jetwallet/features/wallet/helper/navigate_to_wallet.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';

@RoutePage(name: 'EarnTopUpAmountRouter')
class EarnTopUpAmountScreen extends StatefulWidget {
  const EarnTopUpAmountScreen({
    super.key,
    required this.earnPosition,
  });

  final EarnPositionClientModel earnPosition;

  @override
  _EarnTopUpAmountScreenState createState() => _EarnTopUpAmountScreenState();
}

class _EarnTopUpAmountScreenState extends State<EarnTopUpAmountScreen> {
  late EarnTopUpAmountStore store;

  @override
  void initState() {
    super.initState();
    store = EarnTopUpAmountStore(earnPosition: widget.earnPosition);

    if (store.isShowTopUpModal) {
      sAnalytics.earnDepositCryptoWalletPopupView(
        assetName: widget.earnPosition.offers.first.assetId,
        earnAPYrate: widget.earnPosition.offers.first.apyRate?.toStringAsFixed(2) ?? Decimal.zero.toString(),
        earnPlanName: widget.earnPosition.offers.first.description ?? '',
        earnWithdrawalType: widget.earnPosition.offers.first.withdrawType.name,
      );

      Future.delayed(const Duration(milliseconds: 250)).then((_) {
        sShowAlertPopup(
          context,
          primaryText: intl.earn_deposit_crypto_wallet,
          secondaryText: intl.tost_convert_message_1,
          primaryButtonName: intl.earn_top_up_value(store.cryptoSymbol),
          secondaryButtonName: intl.earn_cancel,
          image: Image.asset(
            blockedAsset,
            width: 80,
            height: 80,
            package: 'simple_kit',
          ),
          barrierDismissible: false,
          willPopScope: false,
          onPrimaryButtonTap: () {
            sAnalytics.tapOnTheTopUpEarnWalletButton(
              assetName: widget.earnPosition.offers.first.assetId,
              earnAPYrate: widget.earnPosition.offers.first.apyRate?.toStringAsFixed(2) ?? Decimal.zero.toString(),
              earnPlanName: widget.earnPosition.offers.first.description ?? '',
              earnWithdrawalType: widget.earnPosition.offers.first.withdrawType.name,
            );
            navigateToWallet(context, store.currency);
          },
          onSecondaryButtonTap: () {
            unawaited(
              AnchorsHelper().addTopUpEarnDepositAnchor(
                offerId: widget.earnPosition.offerId,
                positionId: widget.earnPosition.id,
              ),
            );

            sAnalytics.tapOnTheCancelTopUpEarnWalletButton(
              assetName: widget.earnPosition.offers.first.assetId,
              earnAPYrate: widget.earnPosition.offers.first.apyRate?.toStringAsFixed(2) ?? Decimal.zero.toString(),
              earnPlanName: widget.earnPosition.offers.first.description ?? '',
              earnWithdrawalType: widget.earnPosition.offers.first.withdrawType.name,
            );

            context.router.popUntilRouteWithName(EarnPositionActiveRouter.name);
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: '',
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.earn_deposit,
        ),
      ),
      child: Provider<EarnTopUpAmountStore>(
        create: (_) => store,
        child: const _EarnWithdrawalAmountBody(),
      ),
    );
  }
}

class _EarnWithdrawalAmountBody extends StatelessWidget {
  const _EarnWithdrawalAmountBody();

  @override
  Widget build(BuildContext context) {
    final store = EarnTopUpAmountStore.of(context);
    final deviceSize = sDeviceSize;

    return Observer(
      builder: (context) {
        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        deviceSize.when(
                          small: () => const SpaceH40(),
                          medium: () => const Spacer(),
                        ),
                        SNumericLargeInput(
                          primaryAmount: formatCurrencyStringAmount(
                            value: store.cryptoInputValue,
                          ),
                          primarySymbol: store.cryptoSymbol,
                          onSwap: null,
                          showSwopButton: false,
                          errorText: store.errorText,
                          showMaxButton: true,
                          onMaxTap: () {
                            store.onSellAll();
                          },
                          pasteLabel: intl.paste,
                          onPaste: () async {
                            final data = await Clipboard.getData('text/plain');
                            if (data?.text != null) {
                              final n = double.tryParse(data!.text!);
                              if (n != null) {
                                store.pasteValue(n.toString().trim());
                              }
                            }
                          },
                        ),
                        const Spacer(),
                        SuggestionButtonWidget(
                          title: store.currency.description,
                          subTitle: intl.earn_from_crypto_wallet,
                          trailing: getIt<AppStore>().isBalanceHide
                              ? '**** ${store.currency.symbol}'
                              : store.currency.volumeAssetBalance,
                          icon: NetworkIconWidget(
                            store.currency.iconUrl,
                          ),
                          onTap: () {},
                          showArrow: false,
                        ),
                        const SpaceH4(),
                        SuggestionButtonWidget(
                          title: store.offer.name,
                          subTitle: intl.earn_to_earn,
                          trailing: getIt<AppStore>().isBalanceHide
                              ? '**** ${store.currency.symbol}'
                              : store.earnPosition.baseAmount.toFormatCount(
                                  accuracy: store.currency.accuracy,
                                  symbol: store.cryptoSymbol,
                                ),
                          icon: NetworkIconWidget(
                            store.currency.iconUrl,
                          ),
                          onTap: () {},
                          showArrow: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SNumericKeyboard(
              onKeyPressed: (value) {
                store.updateInputValue(value);
              },
              button: SButton.black(
                text: intl.addCircleCard_continue,
                callback: store.isContinueAvaible
                    ? () {
                        sAnalytics.tapOnTheContinueEarnAmountDepositButton(
                          assetName: store.earnPosition.offers.first.assetId,
                          earnAPYrate:
                              store.earnPosition.offers.first.apyRate?.toStringAsFixed(2) ?? Decimal.zero.toString(),
                          earnPlanName: store.earnPosition.offers.first.description ?? '',
                          earnWithdrawalType: store.earnPosition.offers.first.withdrawType.name,
                          earnDepositAmount: store.cryptoInputValue,
                        );
                        sRouter.push(
                          EarnTopUpOrderSummaryRouter(
                            earnPosition: store.earnPosition,
                            amount: Decimal.parse(store.cryptoInputValue),
                          ),
                        );
                      }
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}
