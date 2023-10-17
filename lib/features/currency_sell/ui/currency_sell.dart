import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/currency_sell/model/preview_sell_input.dart';
import 'package:jetwallet/features/currency_sell/store/currency_sell_store.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

@RoutePage(name: 'CurrencySellRouter')
class CurrencySell extends StatelessWidget {
  const CurrencySell({
    super.key,
    required this.currency,
  });

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Provider<CirrencySellStore>(
      create: (context) => CirrencySellStore(currency),
      builder: (context, child) => CurrencySellBody(
        currency: currency,
      ),
    );
  }
}

class CurrencySellBody extends StatefulObserverWidget {
  const CurrencySellBody({
    super.key,
    required this.currency,
  });

  final CurrencyModel currency;

  @override
  State<CurrencySellBody> createState() => _CurrencySellBodyState();
}

class _CurrencySellBodyState extends State<CurrencySellBody> {
  @override
  void initState() {
    CirrencySellStore.of(context).setUpdateTargetConversionPrice(
      widget.currency.symbol,
      CirrencySellStore.of(context).selectedCurrencySymbol,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    final store = CirrencySellStore.of(context);

    final assetWithBalance = <CurrencyModel>[];
    final assetWithOutBalance = <CurrencyModel>[];

    for (final currency in store.currencies) {
      if (currency.baseBalance != Decimal.zero) {
        assetWithBalance.add(currency);
      } else {
        assetWithOutBalance.add(currency);
      }
    }

    void showAssetSelector(BuildContext context) {
      sShowBasicModalBottomSheet(
        scrollable: true,
        pinned: SBottomSheetHeader(
          name: intl.currencySell_forText,
        ),
        children: [
          for (final currency in assetWithBalance)
            SAssetItem(
              isSelected: currency == store.selectedCurrency,
              icon: (currency.type == AssetType.indices)
                  ? SNetworkSvg24(
                      url: currency.iconUrl,
                    )
                  : SNetworkSvg24(
                      color: currency == store.selectedCurrency ? colors.blue : colors.black,
                      url: currency.iconUrl,
                    ),
              name: currency.description,
              amount: currency.volumeBaseBalance(
                store.baseCurrency!,
              ),
              description: currency.volumeAssetBalance,
              onTap: () => Navigator.pop(context, currency),
              divider: currency != assetWithBalance.last,
            ),
          for (final currency in assetWithOutBalance)
            SAssetItem(
              isSelected: currency == store.selectedCurrency,
              icon: (currency.type == AssetType.indices)
                  ? SNetworkSvg24(
                      url: currency.iconUrl,
                    )
                  : SNetworkSvg24(
                      color: currency == store.selectedCurrency ? colors.blue : colors.black,
                      url: currency.iconUrl,
                    ),
              name: currency.description,
              amount: currency.volumeBaseBalance(
                store.baseCurrency!,
              ),
              description: currency.volumeAssetBalance,
              onTap: () => Navigator.pop(context, currency),
              divider: currency != assetWithOutBalance.last,
              removeDivider: currency == assetWithOutBalance.last,
            ),
          const SpaceH40(),
        ],
        context: context,
        then: (value) {
          if (value is CurrencyModel) {
            if (value != store.selectedCurrency) {
              if (value.symbol != store.baseCurrency!.symbol) {
                store.updateTargetConversionPrice(null);
              }
              store.updateSelectedCurrency(value);
              store.setUpdateTargetConversionPrice(
                widget.currency.symbol,
                value.symbol,
              );
            }
          }
        },
      );
    }

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: '${intl.currencySell_sell} ${widget.currency.description}',
        ),
      ),
      child: Column(
        children: [
          deviceSize.when(
            small: () => const SizedBox(),
            medium: () => const Spacer(),
          ),
          Baseline(
            baseline: deviceSize.when(
              small: () => 32,
              medium: () => 9,
            ),
            baselineType: TextBaseline.alphabetic,
            child: SActionPriceField(
              widgetSize: widgetSizeFrom(deviceSize),
              price: formatCurrencyStringAmount(
                value: store.inputValue,
                symbol: widget.currency.symbol,
              ),
              helper: store.conversionText(),
              error: store.inputError.value(),
              isErrorActive: store.inputError.isActive,
            ),
          ),
          Baseline(
            baseline: deviceSize.when(
              small: () => -36,
              medium: () => 19,
            ),
            baselineType: TextBaseline.alphabetic,
            child: Text(
              '${intl.currencySell_available}:'
              ' ${widget.currency.volumeAssetBalance}',
              style: sSubtitle3Style.copyWith(
                color: colors.grey2,
              ),
            ),
          ),
          const Spacer(),
          if (store.selectedCurrency == null)
            SPaymentSelectDefault(
              widgetSize: widgetSizeFrom(deviceSize),
              icon: const SActionWithdrawIcon(),
              name: intl.currencySell_chooseDestination,
              onTap: () {
                showAssetSelector(context);
              },
            )
          else if (store.selectedCurrency!.type == AssetType.crypto)
            SPaymentSelectAsset(
              widgetSize: widgetSizeFrom(deviceSize),
              icon: SNetworkSvg24(
                url: store.selectedCurrency!.iconUrl,
              ),
              name: store.selectedCurrency!.description,
              amount: store.selectedCurrency!.volumeBaseBalance(
                store.baseCurrency!,
              ),
              description: store.selectedCurrency!.volumeAssetBalance,
              onTap: () => showAssetSelector(context),
            )
          else
            SPaymentSelectFiat(
              widgetSize: widgetSizeFrom(deviceSize),
              icon: SNetworkSvg24(
                url: store.selectedCurrency!.iconUrl,
              ),
              name: store.selectedCurrency!.description,
              amount: store.selectedCurrency!.volumeBaseBalance(
                store.baseCurrency!,
              ),
              onTap: () => showAssetSelector(context),
            ),
          deviceSize.when(
            small: () => const Spacer(),
            medium: () => const SpaceH20(),
          ),
          SNumericKeyboardAmount(
            widgetSize: widgetSizeFrom(deviceSize),
            onKeyPressed: (value) {
              store.updateInputValue(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: store.inputValid,
            submitButtonName: intl.currencySell_previewSell,
            onSubmitPressed: () {
              sRouter.push(
                PreviewSellRouter(
                  input: PreviewSellInput(
                    amount: CirrencySellStore.of(context).inputValue,
                    fromCurrency: widget.currency,
                    toCurrency: CirrencySellStore.of(context).selectedCurrency!,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
