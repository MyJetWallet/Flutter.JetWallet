import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/suggestion_button_widget.dart';
import 'package:jetwallet/features/sell_flow/store/sell_amount_store.dart';
import 'package:jetwallet/features/sell_flow/widgets/sell_choose_asset_bottom_sheet.dart';
import 'package:jetwallet/features/sell_flow/widgets/sell_with_bottom_sheet.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/24x24/public/bank_medium/bank_medium_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/crypto/simple_crypto_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/global_basic_appbar.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:visibility_detector/visibility_detector.dart';

@RoutePage(name: 'EarnDepositScreenRouter')
class EarnDepositScreenScreen extends StatefulWidget {
  const EarnDepositScreenScreen({
    super.key,
  });

  @override
  State<EarnDepositScreenScreen> createState() => _EarnDepositScreenScreenState();
}

class _EarnDepositScreenScreenState extends State<EarnDepositScreenScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    return Scaffold(
      backgroundColor: colors.white,
      body: Provider<SellAmountStore>(
        create: (context) => SellAmountStore()..init(),
        builder: (context, child) {
          final store = SellAmountStore.of(context);

          return Observer(
            builder: (context) {
              return Column(
                children: [
                  GlobalBasicAppBar(
                    hasRightIcon: false,
                    title: intl.earn_deposit,
                  ),
                  VisibilityDetector(
                    key: const Key('sell-flow-widget-key'),
                    onVisibilityChanged: (visibilityInfo) {
                      if (visibilityInfo.visibleFraction != 1) return;

                      sAnalytics.sellAmountScreenView();
                    },
                    child: SNewActionPriceField(
                      widgetSize: widgetSizeFrom(deviceSize),
                      primaryAmount: formatCurrencyStringAmount(
                        value: store.primaryAmount,
                      ),
                      primarySymbol: store.primarySymbol,
                      secondaryAmount: store.asset != null
                          ? volumeFormat(
                              decimal: Decimal.parse(store.secondaryAmount),
                              symbol: '',
                              accuracy: store.secondaryAccuracy,
                            )
                          : null,
                      secondarySymbol: store.asset != null ? store.secondarySymbol : null,
                      onSwap: () {
                        sAnalytics.tapOnTheChangeCurrencySell();
                        store.onSwap();
                      },
                      errorText: store.paymentMethodInputError,
                      optionText: store.cryptoInputValue == '0' &&
                              (store.account != null || store.card != null) &&
                              store.asset != null
                          ? '''${intl.sell_amount_sell_all} ${getIt<AppStore>().isBalanceHide ? '**** ${store.cryptoSymbol}' : volumeFormat(decimal: store.sellAllValue, accuracy: store.asset?.accuracy ?? 1, symbol: store.cryptoSymbol)}'''
                          : null,
                      optionOnTap: () {
                        sAnalytics.tapOnTheSellAll();
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
                  ),
                  const Spacer(),
                  if (store.asset != null)
                    SuggestionButtonWidget(
                      title: store.asset?.description,
                      subTitle: intl.amount_screen_sell,
                      trailing: getIt<AppStore>().isBalanceHide
                          ? '**** ${store.asset?.symbol}'
                          : store.asset?.volumeAssetBalance,
                      icon: SNetworkSvg24(
                        url: store.asset?.iconUrl ?? '',
                      ),
                      onTap: () {
                        sAnalytics.tapOnTheSellFromButton(
                          currentFromValueForSell: store.asset?.symbol ?? '',
                        );
                        sAnalytics.sellFromSheetView();
                        showSellChooseAssetBottomSheet(
                          context: context,
                          onChooseAsset: (currency) {
                            store.setNewAsset(currency);
                            Navigator.of(context).pop(true);
                            sAnalytics.tapOnSelectedNewSellFromAssetButton(
                              newSellFromAsset: currency.symbol,
                            );
                          },
                          then: (value) {
                            if (value != true) {
                              sAnalytics.tapOnCloseSheetFromSellButton();
                            }
                          },
                        );
                      },
                      isDisabled: store.isNoCurrencies,
                    )
                  else
                    SuggestionButtonWidget(
                      subTitle: intl.amount_screen_sell,
                      icon: const SCryptoIcon(),
                      onTap: () {
                        sAnalytics.tapOnTheSellFromButton(
                          currentFromValueForSell: store.asset?.symbol ?? '',
                        );
                        sAnalytics.sellFromSheetView();
                        showSellChooseAssetBottomSheet(
                          context: context,
                          onChooseAsset: (currency) {
                            store.setNewAsset(currency);
                            Navigator.of(context).pop(true);
                          },
                          then: (value) {
                            if (value != true) {
                              sAnalytics.tapOnCloseSheetFromSellButton();
                            }
                          },
                        );
                      },
                      isDisabled: store.isNoCurrencies,
                    ),
                  const SpaceH8(),
                  if (store.category == PaymentMethodCategory.account)
                    SuggestionButtonWidget(
                      title: store.account?.label,
                      subTitle: intl.amount_screen_sell_to,
                      trailing: getIt<AppStore>().isBalanceHide
                          ? '**** ${store.account?.currency}'
                          : volumeFormat(
                              decimal: store.account?.balance ?? Decimal.zero,
                              accuracy: store.asset?.accuracy ?? 1,
                              symbol: store.account?.currency ?? '',
                            ),
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: sKit.colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: SBankMediumIcon(color: sKit.colors.white),
                        ),
                      ),
                      onTap: () {
                        sAnalytics.tapOnTheSellToButton(
                          currentToValueForSell:
                              store.account?.isClearjuctionAccount ?? false ? 'CJ account' : 'Unlimit account',
                        );
                        sAnalytics.sellToSheetView();

                        showSellPayWithBottomSheet(
                          context: context,
                          currency: store.asset,
                          onSelected: ({account, card}) {
                            store.setNewPayWith(
                              newAccount: account,
                              newCard: card,
                            );
                            sAnalytics.tapOnSelectedNewSellToButton(
                              newSellToMethod:
                                  account?.isClearjuctionAccount ?? false ? 'CJ account' : 'Unlimit account',
                            );
                            Navigator.of(context).pop(true);
                          },
                          then: (value) {
                            if (value != true) {
                              sAnalytics.tapOnCloseSheetSellToButton();
                            }
                          },
                        );
                      },
                      isDisabled: store.isNoAccounts,
                    )
                  else if (store.category == PaymentMethodCategory.simpleCard)
                    SuggestionButtonWidget(
                      title: store.card?.label ?? 'Simple card',
                      subTitle: intl.amount_screen_sell_to,
                      trailing: getIt<AppStore>().isBalanceHide
                          ? '**** ${store.card?.currency}'
                          : volumeFormat(
                              decimal: store.card?.balance ?? Decimal.zero,
                              accuracy: store.asset?.accuracy ?? 1,
                              symbol: store.card?.currency ?? '',
                            ),
                      icon: Assets.svg.assets.fiat.cardAlt.simpleSvg(
                        width: 24,
                      ),
                      onTap: () {
                        sAnalytics.tapOnTheSellToButton(
                          currentToValueForSell:
                              store.account?.isClearjuctionAccount ?? false ? 'CJ account' : 'Unlimit account',
                        );
                        sAnalytics.sellToSheetView();

                        showSellPayWithBottomSheet(
                          context: context,
                          currency: store.asset,
                          onSelected: ({account, card}) {
                            store.setNewPayWith(
                              newAccount: account,
                              newCard: card,
                            );
                            sAnalytics.tapOnSelectedNewSellToButton(
                              newSellToMethod:
                                  account?.isClearjuctionAccount ?? false ? 'CJ account' : 'Unlimit account',
                            );
                            Navigator.of(context).pop(true);
                          },
                          then: (value) {
                            if (value != true) {
                              sAnalytics.tapOnCloseSheetSellToButton();
                            }
                          },
                        );
                      },
                      isDisabled: store.isNoAccounts,
                    )
                  else
                    SuggestionButtonWidget(
                      subTitle: intl.amount_screen_sell_to,
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: sKit.colors.grey1,
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: SBankMediumIcon(color: sKit.colors.white),
                        ),
                      ),
                      onTap: () {
                        sAnalytics.tapOnTheSellToButton(
                          currentToValueForSell:
                              store.account?.isClearjuctionAccount ?? false ? 'CJ account' : 'Unlimit account',
                        );

                        sAnalytics.sellToSheetView();

                        showSellPayWithBottomSheet(
                          context: context,
                          currency: store.asset,
                          onSelected: ({account, card}) {
                            store.setNewPayWith(
                              newAccount: account,
                              newCard: card,
                            );
                            sAnalytics.tapOnSelectedNewSellToButton(
                              newSellToMethod:
                                  account?.isClearjuctionAccount ?? false ? 'CJ account' : 'Unlimit account',
                            );
                            Navigator.of(context).pop(true);
                          },
                          then: (value) {
                            if (value != true) {
                              sAnalytics.tapOnCloseSheetSellToButton();
                            }
                          },
                        );
                      },
                      isDisabled: store.isNoAccounts,
                    ),
                  const SpaceH20(),
                  SNumericKeyboardAmount(
                    widgetSize: widgetSizeFrom(deviceSize),
                    onKeyPressed: (value) {
                      store.updateInputValue(value);
                    },
                    buttonType: SButtonType.primary2,
                    submitButtonActive: store.isContinueAvaible,
                    submitButtonName: intl.addCircleCard_continue,
                    onSubmitPressed: () {
                      sAnalytics.tapOnTheContinueWithSellAmountButton(
                        destinationWallet: 'EUR',
                        nowInput: store.isFiatEntering ? 'Fiat' : 'Crypro',
                        sellFromWallet: store.cryptoSymbol,
                        enteredAmount: store.primaryAmount,
                        sellToPMType: store.account?.isClearjuctionAccount ?? false
                            ? PaymenthMethodType.cjAccount
                            : PaymenthMethodType.unlimitAccount,
                      );
                      sRouter.push(
                        SellConfirmationRoute(
                          asset: store.asset!,
                          isFromFixed: !store.isFiatEntering,
                          paymentCurrency: store.buyCurrency,
                          account: store.account,
                          simpleCard: store.card,
                          fromAmount: Decimal.parse(store.cryptoInputValue),
                          toAmount: Decimal.parse(store.fiatInputValue),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
