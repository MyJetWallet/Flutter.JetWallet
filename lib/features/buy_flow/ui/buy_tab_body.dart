import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/buy_flow/store/buy_amount_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/suggestion_button_widget.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/pay_with_bottom_sheet.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/24x24/public/bank_medium/bank_medium_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/crypto/simple_crypto_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'buy_choose_asset_bottom_sheet.dart';

class BuyAmountTabBody extends StatefulObserverWidget {
  const BuyAmountTabBody({
    this.asset,
    this.card,
    this.account,
  });

  final CurrencyModel? asset;

  final CircleCard? card;
  final SimpleBankingAccount? account;

  @override
  State<BuyAmountTabBody> createState() => _BuyAmountScreenBodyState();
}

class _BuyAmountScreenBodyState extends State<BuyAmountTabBody> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    return Provider<BuyAmountStore>(
      create: (context) => BuyAmountStore()
        ..init(
          inputAsset: widget.asset,
          inputCard: widget.card,
          account: widget.account,
        ),
      builder: (context, child) {
        final store = BuyAmountStore.of(context);

        return Observer(
          builder: (context) {
            return Column(
              children: [
                deviceSize.when(
                  small: () => const SpaceH40(),
                  medium: () => const Spacer(),
                ),
                VisibilityDetector(
                  key: const Key('buy-flow-widget-key'),
                  onVisibilityChanged: (visibilityInfo) {
                    if (visibilityInfo.visibleFraction != 1) return;

                    sAnalytics.buyAmountScreenView(
                      destinationWallet: store.asset?.symbol ?? '',
                      pmType: widget.card != null
                          ? PaymenthMethodType.card
                          : store.account?.isClearjuctionAccount ?? false
                              ? PaymenthMethodType.cjAccount
                              : PaymenthMethodType.unlimitAccount,
                      buyPM: store.card != null
                          ? 'Saved card ${store.card?.last4}'
                          : store.account?.isClearjuctionAccount ?? false
                              ? 'CJ  ${store.account?.last4IbanCharacters}'
                              : 'Unlimint  ${store.account?.last4IbanCharacters}',
                      sourceCurrency: 'EUR',
                    );
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
                      store.swapAssets();
                      sAnalytics.tapOnTheChangeInputBuyButton(
                        pmType: store.pmType,
                        buyPM: store.buyPM,
                        sourceCurrency: 'EUR',
                        destinationWallet: store.asset?.symbol ?? '',
                        nowInput: store.isFiatEntering ? NowInputType.fiat : NowInputType.crypro,
                      );
                    },
                    errorText: store.paymentMethodInputError,
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
                    subTitle: intl.amount_screen_buy,
                    trailing: store.asset?.volumeAssetBalance,
                    icon: SNetworkSvg24(
                      url: store.asset?.iconUrl ?? '',
                    ),
                    onTap: () {
                      sAnalytics.tapOnTheChooseAssetButton(
                        pmType: store.pmType,
                        buyPM: store.buyPM,
                        sourceCurrency: 'EUR',
                      );
                      showBuyChooseAssetBottomSheet(
                        context: context,
                        onChooseAsset: (currency) {
                          store.setNewAsset(currency);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  )
                else
                  SuggestionButtonWidget(
                    subTitle: intl.amount_screen_buy,
                    icon: const SCryptoIcon(),
                    onTap: () {
                      showBuyChooseAssetBottomSheet(
                        context: context,
                        onChooseAsset: (currency) {
                          store.setNewAsset(currency);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                const SpaceH8(),
                if (store.category == PaymentMethodCategory.account)
                  SuggestionButtonWidget(
                    title: store.account?.label,
                    subTitle: intl.amount_screen_pay_with,
                    trailing: volumeFormat(
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
                      sAnalytics.tapOnThePayWithButton(
                        pmType: store.pmType,
                        buyPM: store.buyPM,
                        sourceCurrency: 'EUR',
                        destinationWallet: store.asset?.symbol ?? '',
                      );
                      showPayWithBottomSheet(
                        context: context,
                        currency: store.asset,
                        onSelected: ({account, inputCard}) {
                          store.setNewPayWith(
                            newCard: inputCard,
                            newAccount: account,
                          );
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  )
                else if (store.category == PaymentMethodCategory.cards)
                  SuggestionButtonWidget(
                    title: store.card?.formatedCardLabel,
                    subTitle: intl.amount_screen_pay_with,
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: ShapeDecoration(
                        color: sKit.colors.white,
                        shape: OvalBorder(
                          side: BorderSide(
                            color: colors.grey4,
                          ),
                        ),
                      ),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: getNetworkIcon(store.card?.network),
                      ),
                    ),
                    onTap: () {
                      sAnalytics.tapOnThePayWithButton(
                        pmType: store.pmType,
                        buyPM: store.buyPM,
                        sourceCurrency: 'EUR',
                        destinationWallet: store.asset?.symbol ?? '',
                      );
                      showPayWithBottomSheet(
                        context: context,
                        currency: store.asset,
                        onSelected: ({account, inputCard}) {
                          store.setNewPayWith(
                            newCard: inputCard,
                            newAccount: account,
                          );
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  )
                else
                  SuggestionButtonWidget(
                    subTitle: intl.amount_screen_pay_with,
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
                      sAnalytics.tapOnThePayWithButton(
                        pmType: store.pmType,
                        buyPM: store.buyPM,
                        sourceCurrency: 'EUR',
                        destinationWallet: store.asset?.symbol ?? '',
                      );
                      showPayWithBottomSheet(
                        context: context,
                        currency: store.asset,
                        onSelected: ({account, inputCard}) {
                          store.setNewPayWith(
                            newCard: inputCard,
                            newAccount: account,
                          );
                          Navigator.of(context).pop();
                        },
                      );
                    },
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
                    sAnalytics.tapOnTheContinueWithBuyAmountButton(
                      pmType: store.pmType,
                      buyPM: store.buyPM,
                      sourceCurrency: 'EUR',
                      destinationWallet: store.asset?.symbol ?? '',
                      sourceBuyAmount: store.fiatInputValue,
                      destinationBuyAmount: store.cryptoInputValue,
                    );
                    sRouter.push(
                      BuyConfirmationRoute(
                        asset: store.asset!,
                        paymentCurrency: store.buyCurrency,
                        isFromFixed: store.isFiatEntering,
                        fromAmount: store.fiatInputValue,
                        toAmount: store.cryptoInputValue,
                        card: store.card,
                        account: store.account,
                      ),
                    );
                  },
                ),
              ],
            );
          },
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
