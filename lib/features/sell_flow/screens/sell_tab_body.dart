import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/suggestion_button_widget.dart';
import 'package:jetwallet/features/sell_flow/store/sell_amount_store.dart';
import 'package:jetwallet/features/sell_flow/widgets/sell_choose_asset_bottom_sheet.dart';
import 'package:jetwallet/features/sell_flow/widgets/sell_with_bottom_sheet.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/24x24/public/bank_medium/bank_medium_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/crypto/simple_crypto_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/di/di.dart';
import '../../app/store/app_store.dart';

class SellAmountTabBody extends StatefulObserverWidget {
  const SellAmountTabBody({
    this.asset,
    this.account,
    this.simpleCard,
    required this.navigateToConvert,
  });

  final CurrencyModel? asset;
  final SimpleBankingAccount? account;
  final CardDataModel? simpleCard;
  final void Function({
    required CurrencyModel fromAsset,
    required CurrencyModel toAsset,
  }) navigateToConvert;

  @override
  State<SellAmountTabBody> createState() => _SellAmountScreenBodyState();
}

class _SellAmountScreenBodyState extends State<SellAmountTabBody> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final deviceSize = sDeviceSize;

    return Provider<SellAmountStore>(
      create: (context) => SellAmountStore()
        ..init(
          inputAsset: widget.asset,
          newAccount: widget.account,
          newCard: widget.simpleCard,
        ),
      builder: (context, child) {
        final store = SellAmountStore.of(context);

        return VisibilityDetector(
          key: const Key('sell-flow-widget-key'),
          onVisibilityChanged: (visibilityInfo) {
            if (visibilityInfo.visibleFraction != 1) return;

            sAnalytics.sellAmountScreenView();
          },
          child: Observer(
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
                                  value: store.primaryAmount,
                                ),
                                primarySymbol: store.primarySymbol,
                                onSwap: () {
                                  sAnalytics.tapOnTheChangeCurrencySell();
                                  store.onSwap();
                                },
                                errorText: store.paymentMethodInputError,
                                showMaxButton: true,
                                loadingMaxButton: store.onMaxPressed && store.loadingMaxButton,
                                onMaxTap: () {
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
                              const Spacer(),
                              if (store.asset != null)
                                SuggestionButtonWidget(
                                  title: store.asset?.description,
                                  subTitle: intl.amount_screen_sell,
                                  trailing: getIt<AppStore>().isBalanceHide
                                      ? '**** ${store.asset?.symbol}'
                                      : store.asset?.volumeAssetBalance,
                                  icon: NetworkIconWidget(
                                    store.asset?.iconUrl ?? '',
                                  ),
                                  onTap: () {
                                    sAnalytics.tapOnTheSellFromButton(
                                      currentFromValueForSell: store.asset?.symbol ?? '',
                                    );

                                    showSellChooseAssetBottomSheet(
                                      context: context,
                                      onChooseAsset: (currency) {
                                        store.setNewAsset(currency);
                                        Navigator.of(context).pop(true);
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

                                    showSellChooseAssetBottomSheet(
                                      context: context,
                                      onChooseAsset: (currency) {
                                        store.setNewAsset(currency);
                                        Navigator.of(context).pop(true);
                                      },
                                    );
                                  },
                                  isDisabled: store.isNoCurrencies,
                                ),
                              const SpaceH4(),
                              if (store.category == PaymentMethodCategory.account)
                                SuggestionButtonWidget(
                                  title: store.account?.label,
                                  subTitle: intl.amount_screen_sell_to,
                                  trailing: getIt<AppStore>().isBalanceHide
                                      ? '**** ${store.account?.currency}'
                                      : (store.account?.balance ?? Decimal.zero).toFormatSum(
                                          accuracy: store.fiatAccuracy,
                                          symbol: store.account?.currency ?? '',
                                        ),
                                  icon: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: SColorsLight().blue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: SBankMediumIcon(
                                        color: SColorsLight().white,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    sAnalytics.tapOnTheSellToButton(
                                      currentToValueForSell: store.account?.isClearjuctionAccount ?? false,
                                    );

                                    showSellPayWithBottomSheet(
                                      context: context,
                                      currency: store.asset,
                                      onSelected: ({account, card}) {
                                        store.setNewPayWith(
                                          newAccount: account,
                                          newCard: card,
                                        );

                                        Navigator.of(context).pop(true);
                                      },
                                      onSelectedCryptoAsset: ({newCurrency}) {
                                        widget.navigateToConvert(
                                          fromAsset: store.asset!,
                                          toAsset: newCurrency!,
                                        );
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
                                      : (store.card?.balance ?? Decimal.zero).toFormatSum(
                                          accuracy: store.fiatAccuracy,
                                          symbol: store.card?.currency ?? '',
                                        ),
                                  icon: Assets.svg.assets.fiat.cardAlt.simpleSvg(
                                    width: 24,
                                  ),
                                  onTap: () {
                                    sAnalytics.tapOnTheSellToButton(
                                      currentToValueForSell: store.account?.isClearjuctionAccount ?? false,
                                    );

                                    showSellPayWithBottomSheet(
                                      context: context,
                                      currency: store.asset,
                                      onSelected: ({account, card}) {
                                        store.setNewPayWith(
                                          newAccount: account,
                                          newCard: card,
                                        );

                                        Navigator.of(context).pop(true);
                                      },
                                      onSelectedCryptoAsset: ({newCurrency}) {
                                        widget.navigateToConvert(
                                          fromAsset: store.asset!,
                                          toAsset: newCurrency!,
                                        );
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
                                      color: SColorsLight().gray10,
                                      shape: BoxShape.circle,
                                    ),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: SBankMediumIcon(
                                        color: SColorsLight().white,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    sAnalytics.tapOnTheSellToButton(
                                      currentToValueForSell: store.account?.isClearjuctionAccount ?? false,
                                    );

                                    showSellPayWithBottomSheet(
                                      context: context,
                                      currency: store.asset,
                                      onSelected: ({account, card}) {
                                        store.setNewPayWith(
                                          newAccount: account,
                                          newCard: card,
                                        );

                                        Navigator.of(context).pop(true);
                                      },
                                      onSelectedCryptoAsset: ({newCurrency}) {
                                        widget.navigateToConvert(
                                          fromAsset: store.asset!,
                                          toAsset: newCurrency!,
                                        );
                                      },
                                    );
                                  },
                                  isDisabled: store.isNoAccounts,
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
                            }
                          : null,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget getNetworkIcon(CircleCardNetwork? network) {
  switch (network) {
    case CircleCardNetwork.VISA:
      return const SVisaCardIcon(
        width: 40,
        height: 25,
      );
    case CircleCardNetwork.MASTERCARD:
      return const SMasterCardIcon(
        width: 40,
        height: 25,
      );
    default:
      return const SActionDepositIcon();
  }
}

Widget getSimpleNetworkIcon(SimpleCardNetwork? network) {
  switch (network) {
    case SimpleCardNetwork.visa:
      return const SVisaCardBigIcon(
        width: 15,
        height: 9,
      );
    case SimpleCardNetwork.mastercard:
      return const SMasterCardBigIcon(
        width: 15,
        height: 9,
      );
    default:
      return const SActionDepositIcon();
  }
}
