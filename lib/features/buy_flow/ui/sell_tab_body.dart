import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/buy_flow/store/sell_amount_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/buy_option_widget.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/sell_with_bottom_sheet.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/icons/24x24/public/bank_medium/bank_medium_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/crypto/simple_crypto_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

import '../../currency_buy/ui/widgets/choose_asset_bottom_sheet.dart';

class SellAmountTabBody extends StatefulObserverWidget {
  const SellAmountTabBody({
    this.asset,
  });

  final CurrencyModel? asset;

  @override
  State<SellAmountTabBody> createState() => _BuyAmountScreenBodyState();
}

class _BuyAmountScreenBodyState extends State<SellAmountTabBody> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final deviceSize = sDeviceSize;

    return Provider<SellAmountStore>(
      create: (context) => SellAmountStore()
        ..init(
          inputAsset: widget.asset,
        ),
      builder: (context, child) {
        final store = SellAmountStore.of(context);

        return Observer(
          builder: (context) {
            return Column(
              children: [
                deviceSize.when(
                  small: () => const SpaceH40(),
                  medium: () => const Spacer(),
                ),
                SNewActionPriceField(
                  widgetSize: widgetSizeFrom(deviceSize),
                  primaryAmount: formatCurrencyStringAmount(
                    value: store.isFiatEntering ? store.fiatInputValue : store.cryptoInputValue,
                  ),
                  primarySymbol: store.isFiatEntering ? store.fiatSymbol : store.cryptoSymbol,
                  secondaryAmount: store.asset != null
                      ? formatCurrencyStringAmount(
                          value: store.isFiatEntering ? store.cryptoInputValue : store.fiatInputValue,
                        )
                      : null,
                  secondarySymbol: store.asset != null
                      ? store.isFiatEntering
                          ? store.cryptoSymbol
                          : store.fiatSymbol
                      : null,
                  onSwap: () {
                    store.isFiatEntering = !store.isFiatEntering;
                  },
                  errorText: store.paymentMethodInputError,
                ),
                const Spacer(),
                if (store.asset != null)
                  BuyOptionWidget(
                    title: store.asset?.description,
                    subTitle: intl.amount_screen_sell,
                    trailing: store.asset?.volumeAssetBalance,
                    icon: SNetworkSvg24(
                      url: store.asset?.iconUrl ?? '',
                    ),
                    onTap: () {
                      showChooseAssetBottomSheet(
                        context: context,
                        onChooseAsset: (currency) {
                          store.setNewAsset(currency);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  )
                else
                  BuyOptionWidget(
                    subTitle: intl.amount_screen_sell,
                    icon: const SCryptoIcon(),
                    onTap: () {
                      showChooseAssetBottomSheet(
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
                  BuyOptionWidget(
                    title: store.account?.label,
                    subTitle: intl.amount_screen_sell_to,
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
                      showSellPayWithBottomSheet(
                        context: context,
                        currency: store.asset,
                        hideCards: true,
                        onSelected: ({account, inputCard}) {
                          store.setNewPayWith(
                            newAccount: account,
                          );
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  )
                else
                  BuyOptionWidget(
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
                      showSellPayWithBottomSheet(
                        context: context,
                        currency: store.asset,
                        hideCards: true,
                        onSelected: ({account, inputCard}) {
                          store.setNewPayWith(
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
                  submitButtonActive:
                      store.inputValid && !store.disableSubmit && !(double.parse(store.primaryAmount) == 0.0),
                  submitButtonName: intl.addCircleCard_continue,
                  onSubmitPressed: () {
                    sRouter.push(
                      SellConfirmationRoute(
                        asset: store.asset!,
                        isFromFixed: !store.isFiatEntering,
                        paymentCurrency: store.buyCurrency,
                        account: store.account!,
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
