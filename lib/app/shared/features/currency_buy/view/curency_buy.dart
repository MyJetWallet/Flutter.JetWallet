import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/asset_model.dart';
import 'package:simple_networking/services/signal_r/model/asset_payment_methods.dart';
import 'package:simple_networking/services/swap/model/get_quote/get_quote_request_model.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/helpers/widget_size_from.dart';
import '../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../helpers/are_balances_empty.dart';
import '../../../helpers/format_currency_string_amount.dart';
import '../../../models/currency_model.dart';
import '../../../providers/converstion_price_pod/conversion_price_input.dart';
import '../../../providers/converstion_price_pod/conversion_price_pod.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../recurring/helper/recurring_buys_operation_name.dart';
import '../model/preview_buy_with_asset_input.dart';
import '../notifier/currency_buy_notifier/currency_buy_notipod.dart';
import 'components/recurring_selector.dart';
import 'preview_buy_with_asset.dart';
import 'simplex_web_view.dart';

class CurrencyBuy extends StatefulHookWidget {
  const CurrencyBuy({
    Key? key,
    this.recurringBuysType,
    required this.currency,
    required this.fromCard,
  }) : super(key: key);

  final RecurringBuysType? recurringBuysType;
  final CurrencyModel currency;
  final bool fromCard;

  @override
  State<CurrencyBuy> createState() => _CurrencyBuyState();
}

class _CurrencyBuyState extends State<CurrencyBuy> {
  @override
  void initState() {
    super.initState();
    final notifier = context.read(currencyBuyNotipod(widget.currency).notifier);
    notifier.initDefaultPaymentMethod(fromCard: widget.fromCard);
    notifier.initRecurringBuyType(widget.recurringBuysType);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = useProvider(deviceSizePod);
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final state = useProvider(currencyBuyNotipod(widget.currency));
    final notifier = useProvider(currencyBuyNotipod(widget.currency).notifier);
    final emptyBalances = areBalancesEmpty(useProvider(currenciesPod));
    useProvider(
      conversionPriceFpod(
        ConversionPriceInput(
          baseAssetSymbol: widget.currency.symbol,
          quotedAssetSymbol: state.selectedCurrencySymbol,
          then: notifier.updateTargetConversionPrice,
        ),
      ),
    );
    final loader = useValueNotifier(StackLoaderNotifier());
    final disableSubmit = useState(false);
    useListenable(loader.value);

    void _showAssetSelector() {
      sShowBasicModalBottomSheet(
        scrollable: true,
        pinned: SBottomSheetHeader(
          name: intl.curencyBuy_payFrom,
        ),
        children: [
          for (final currency in state.currencies)
            if (currency.type == AssetType.crypto)
              SAssetItem(
                isSelected: currency == state.selectedCurrency,
                icon: SNetworkSvg24(
                  color: currency == state.selectedCurrency
                      ? colors.blue
                      : colors.black,
                  url: currency.iconUrl,
                ),
                name: currency.description,
                amount: currency.volumeBaseBalance(
                  state.baseCurrency!,
                ),
                description: currency.volumeAssetBalance,
                onTap: () => Navigator.pop(context, currency),
              )
            else
              SFiatItem(
                isSelected: currency == state.selectedCurrency,
                icon: SNetworkSvg24(
                  color: currency.type != AssetType.indices
                      ? currency == state.selectedCurrency
                          ? colors.blue
                          : colors.black
                      : null,
                  url: currency.type == AssetType.indices &&
                          currency == state.selectedCurrency
                      ? currency.selectedIndexIconUrl
                      : currency.iconUrl,
                ),
                name: currency.description,
                amount: currency.volumeBaseBalance(
                  state.baseCurrency!,
                ),
                onTap: () => Navigator.pop(context, currency),
              ),
          for (final method in widget.currency.buyMethods)
            if (method.type == PaymentMethodType.simplex) ...[
              const SpaceH20(),
              SActionItem(
                isSelected: state.selectedCurrency == null,
                icon: SActionDepositIcon(
                  color: state.selectedCurrency == null
                      ? colors.blue
                      : colors.black,
                ),
                name: intl.curencyBuy_actionItemName,
                description: intl.curencyBuy_actionItemDescription,
                onTap: () => Navigator.pop(context, method),
                helper: '≈10-30 ${intl.min}',
              ),
            ],
          const SpaceH40(),
        ],
        context: context,
        then: (value) {
          if (value is PaymentMethod) {
            if (value != state.selectedPaymentMethod) {
              notifier.updateSelectedPaymentMethod(value);
              notifier.resetValuesToZero();
            }
          } else if (value is CurrencyModel) {
            if (value != state.selectedCurrency) {
              if (value.symbol != state.baseCurrency!.symbol) {
                notifier.updateTargetConversionPrice(null);
              }
              notifier.updateSelectedCurrency(value);
              notifier.resetValuesToZero();
            }
          }
        },
      );
    }

    return SPageFrame(
      loaderText: intl.curencyBuy_pleaseWait,
      loading: loader.value,
      header: SPaddingH24(
        child: SSmallHeader(
          title: '${intl.curencyBuy_buy} ${widget.currency.description}',
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              deviceSize.when(
                small: () => const SizedBox(),
                medium: () => const Spacer(),
              ),
              Baseline(
                baseline: deviceSize.when(
                  small: () => 32,
                  medium: () => 31,
                ),
                baselineType: TextBaseline.alphabetic,
                child: SActionPriceField(
                  widgetSize: widgetSizeFrom(deviceSize),
                  price: formatCurrencyStringAmount(
                    prefix: state.selectedCurrency?.prefixSymbol,
                    value: state.inputValue,
                    symbol: state.selectedCurrencySymbol,
                  ),
                  helper: state.conversionText(widget.currency),
                  error: state.inputErrorValue,
                  isErrorActive: state.isInputErrorActive,
                ),
              ),
              const Spacer(),
              RecurringSelector(
                oneTimePurchaseOnly: state.selectedPaymentMethod?.type ==
                    PaymentMethodType.simplex,
                currentSelection: state.recurringBuyType,
                onSelect: (selection) {
                  notifier.updateRecurringBuyType(selection);
                  Navigator.pop(context);
                },
              ),
              deviceSize.when(
                small: () => const SpaceH8(),
                medium: () => const SpaceH16(),
              ),
              if (emptyBalances && !widget.currency.supportsAtLeastOneBuyMethod)
                SPaymentSelectEmptyBalance(
                  widgetSize: widgetSizeFrom(deviceSize),
                  text: intl.sPaymentSelectEmpty_buyOnlyWithCrypto,
                )
              else if (state.selectedPaymentMethod?.type ==
                  PaymentMethodType.simplex)
                SPaymentSelectAsset(
                  widgetSize: widgetSizeFrom(deviceSize),
                  isCreditCard: true,
                  icon: SActionDepositIcon(
                    color: colors.black,
                  ),
                  name: intl.curencyBuy_actionItemName,
                  helper: '≈ 10-30 ${intl.min}',
                  description: intl.curencyBuy_actionItemDescription,
                  onTap: () => _showAssetSelector(),
                )
              else if (state.selectedCurrency?.type == AssetType.crypto)
                SPaymentSelectAsset(
                  widgetSize: widgetSizeFrom(deviceSize),
                  icon: SNetworkSvg24(
                    url: state.selectedCurrency!.iconUrl,
                  ),
                  name: state.selectedCurrency!.description,
                  amount: state.selectedCurrency!.volumeBaseBalance(
                    state.baseCurrency!,
                  ),
                  description: state.selectedCurrency!.volumeAssetBalance,
                  onTap: () => _showAssetSelector(),
                )
              else
                SPaymentSelectFiat(
                  widgetSize: widgetSizeFrom(deviceSize),
                  icon: SNetworkSvg24(
                    url: state.selectedCurrency!.iconUrl,
                  ),
                  name: state.selectedCurrency!.description,
                  amount: state.selectedCurrency!.volumeBaseBalance(
                    state.baseCurrency!,
                  ),
                  onTap: () => _showAssetSelector(),
                ),
              deviceSize.when(
                small: () => const SpaceH9(),
                medium: () => const SpaceH20(),
              ),
              SNumericKeyboardAmount(
                widgetSize: widgetSizeFrom(deviceSize),
                preset1Name: state.preset1Name,
                preset2Name: state.preset2Name,
                preset3Name: state.preset3Name,
                selectedPreset: state.selectedPreset,
                onPresetChanged: (preset) {
                  if (state.selectedPaymentMethod != null) {
                    notifier.selectFixedSum(preset);
                  } else {
                    notifier.selectPercentFromBalance(preset);
                  }
                },
                onKeyPressed: (value) {
                  notifier.updateInputValue(value);
                },
                buttonType: SButtonType.primary2,
                submitButtonActive: state.inputValid &&
                    !loader.value.value &&
                    !disableSubmit.value,
                submitButtonName:
                    state.recurringBuyType != RecurringBuysType.oneTimePurchase
                        ? intl.curencyBuy_NumericKeyboardButtonName1
                        : intl.curencyBuy_NumericKeyboardButtonName2,
                onSubmitPressed: () async {
                  sAnalytics.tapPreviewBuy(
                    assetName: widget.currency.description,
                    paymentMethod: state.selectedPaymentMethod?.type.name ??
                        intl.curencyBuy_crypto,
                    amount: formatCurrencyStringAmount(
                      prefix: state.selectedCurrency?.prefixSymbol,
                      value: state.inputValue,
                      symbol: state.selectedCurrencySymbol,
                    ),
                    frequency: state.recurringBuyType.toFrequency,
                  );

                  if (state.selectedPaymentMethod != null) {
                    disableSubmit.value = true;
                    loader.value.startLoading();
                    final response = await notifier.makeSimplexRequest();
                    loader.value.finishLoading();
                    disableSubmit.value = false;

                    if (response != null) {
                      if (!mounted) return;
                      navigatorPush(
                        context,
                        SimplexWebView(response),
                      );
                    }
                  } else {
                    navigatorPush(
                      context,
                      PreviewBuyWithAsset(
                        input: PreviewBuyWithAssetInput(
                          amount: state.inputValue,
                          fromCurrency: state.selectedCurrency!,
                          toCurrency: widget.currency,
                          recurringType: state.recurringBuyType,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
