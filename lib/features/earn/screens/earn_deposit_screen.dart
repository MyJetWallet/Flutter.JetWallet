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
import 'package:jetwallet/features/earn/store/earn_deposit_store.dart';
import 'package:jetwallet/features/wallet/helper/navigate_to_wallet.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

@RoutePage(name: 'EarnDepositScreenRouter')
class EarnDepositScreen extends StatefulWidget {
  const EarnDepositScreen({
    super.key,
    required this.offer,
  });

  final EarnOfferClientModel offer;

  @override
  _EarnDepositScreenState createState() => _EarnDepositScreenState();
}

class _EarnDepositScreenState extends State<EarnDepositScreen> {
  late EarnDepositStore store;

  @override
  void initState() {
    super.initState();
    store = EarnDepositStore(offer: widget.offer);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (store.isShowTopUpModal) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        sAnalytics.earnDepositCryptoWalletPopupView(
          assetName: widget.offer.assetId,
          earnAPYrate: widget.offer.apyRate?.toStringAsFixed(2) ?? Decimal.zero.toString(),
          earnPlanName: widget.offer.description ?? '',
          earnWithdrawalType: widget.offer.withdrawType.name,
        );
        await sShowAlertPopup(
          context,
          primaryText: intl.earn_deposit_crypto_wallet,
          secondaryText: intl.earn_to_continue_you_need_to_top_up_fix(
            '${widget.offer.minAmount} ${store.cryptoSymbol}',
            store.currency.description,
          ),
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
          onWillPop: () async {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              sRouter.maybePop();
              sRouter.maybePop();
            });
          },
          onPrimaryButtonTap: () {
            sAnalytics.tapOnTheTopUpEarnWalletButton(
              assetName: widget.offer.assetId,
              earnAPYrate: widget.offer.apyRate?.toStringAsFixed(2) ?? Decimal.zero.toString(),
              earnPlanName: widget.offer.description ?? '',
              earnWithdrawalType: widget.offer.withdrawType.name,
            );

            navigateToWallet(context, store.currency);
          },
          onSecondaryButtonTap: () {
            unawaited(AnchorsHelper().addForgotEarnDepositAnchor(widget.offer.id));

            sAnalytics.tapOnTheCancelTopUpEarnWalletButton(
              assetName: widget.offer.assetId,
              earnAPYrate: widget.offer.apyRate?.toStringAsFixed(2) ?? Decimal.zero.toString(),
              earnPlanName: widget.offer.description ?? '',
              earnWithdrawalType: widget.offer.withdrawType.name,
            );

            sRouter.popUntilRoot();
          },
        );
      });
    }
  }

  void closeScreen() {
    final containsOffersRouter = sRouter.stack.any((element) => element.restorationId == OffersRouter.name);
    final containsWallerRouter = sRouter.stack.any((element) => element.restorationId == WalletRouter.name);
    final containsMarketDetailsRouter =
        sRouter.stack.any((element) => element.restorationId == MarketDetailsRouter.name);

    if (containsOffersRouter) {
      sRouter.popUntilRouteWithName(OffersRouter.name);
    } else if (containsWallerRouter) {
      sRouter.popUntilRouteWithName(WalletRouter.name);
    } else if (containsMarketDetailsRouter) {
      sRouter.popUntilRouteWithName(MarketDetailsRouter.name);
    } else {
      sRouter.popUntilRouteWithName(HomeRouter.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: '',
      header: GlobalBasicAppBar(
        title: intl.earn_deposit,
        hasRightIcon: false,
      ),
      child: Provider<EarnDepositStore>(
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
    final store = EarnDepositStore.of(context);
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
                              : Decimal.zero.toFormatCount(
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
                          assetName: store.offer.assetId,
                          earnAPYrate: store.offer.apyRate?.toString() ?? Decimal.zero.toString(),
                          earnDepositAmount: store.cryptoInputValue,
                          earnPlanName: store.offer.description ?? '',
                          earnWithdrawalType: store.offer.withdrawType.name,
                        );
                        sRouter.push(
                          OfferOrderSummaryRouter(
                            offer: store.offer,
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
