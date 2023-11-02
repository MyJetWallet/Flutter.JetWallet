import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/buy_flow/store/convert_amount_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/buy_option_widget.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/icons/24x24/public/crypto/simple_crypto_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

import 'buy_choose_asset_bottom_sheet.dart';

class ConvertAmountTabBody extends StatefulObserverWidget {
  const ConvertAmountTabBody({
    this.asset,
  });

  final CurrencyModel? asset;

  @override
  State<ConvertAmountTabBody> createState() => _BuyAmountScreenBodyState();
}

class _BuyAmountScreenBodyState extends State<ConvertAmountTabBody> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final deviceSize = sDeviceSize;

    return Provider<ConvertAmountStore>(
      create: (context) => ConvertAmountStore()
        ..init(
          inputAsset: widget.asset,
        ),
      builder: (context, child) {
        final store = ConvertAmountStore.of(context);

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
                    value: store.isFromEntering ? store.fromInputValue : store.toInputValue,
                  ),
                  primarySymbol: store.isFromEntering ? store.fromAsset?.symbol ?? '' : store.toAsset?.symbol ?? '',
                  secondaryAmount: store.toAsset != null
                      ? formatCurrencyStringAmount(
                          value: store.isFromEntering ? store.toInputValue : store.fromInputValue,
                        )
                      : null,
                  secondarySymbol: store.toAsset != null
                      ? store.isFromEntering
                          ? store.toAsset?.symbol
                          : store.fromAsset?.symbol
                      : null,
                  onSwap: () {
                    store.swapAssets();
                  },
                  errorText: store.paymentMethodInputError,
                  optionText: store.fromInputValue == '0'
                      ? '''${intl.sell_amount_sell_all} ${volumeFormat(decimal: store.maxLimit, accuracy: store.fromAsset?.accuracy ?? 1, symbol: store.fromAsset?.symbol ?? '')}'''
                      : null,
                  optionOnTap: () {
                    store.onConvetrAll();
                  },
                ),
                const Spacer(),
                if (store.fromAsset != null)
                  BuyOptionWidget(
                    title: store.fromAsset?.description,
                    subTitle: intl.amount_screen_convert,
                    trailing: store.fromAsset?.volumeAssetBalance,
                    icon: SNetworkSvg24(
                      url: store.fromAsset?.iconUrl ?? '',
                    ),
                    onTap: () {
                      showBuyChooseAssetBottomSheet(
                        context: context,
                        onChooseAsset: (currency) {
                          store.setNewFromAsset(currency);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  )
                else
                  BuyOptionWidget(
                    subTitle: intl.amount_screen_convert,
                    icon: const SCryptoIcon(),
                    onTap: () {
                      showBuyChooseAssetBottomSheet(
                        context: context,
                        onChooseAsset: (currency) {
                          store.setNewFromAsset(currency);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                const SpaceH8(),
                if (store.toAsset != null)
                  BuyOptionWidget(
                    title: store.toAsset?.description,
                    subTitle: intl.amount_screen_convert,
                    trailing: store.toAsset?.volumeAssetBalance,
                    icon: SNetworkSvg24(
                      url: store.toAsset?.iconUrl ?? '',
                    ),
                    onTap: () {
                      showBuyChooseAssetBottomSheet(
                        context: context,
                        onChooseAsset: (currency) {
                          store.setNewToAsset(currency);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  )
                else
                  BuyOptionWidget(
                    subTitle: intl.amount_screen_convert,
                    icon: const SCryptoIcon(),
                    onTap: () {
                      showBuyChooseAssetBottomSheet(
                        context: context,
                        onChooseAsset: (currency) {
                          store.setNewToAsset(currency);
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
                      ConvetrConfirmationRoute(
                        fromAsset: store.fromAsset!,
                        toAsset: store.toAsset!,
                        fromAmount: Decimal.parse(store.fromInputValue),
                        toAmount: Decimal.parse(store.toInputValue),
                        isFromFixed: store.isFromEntering,
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
