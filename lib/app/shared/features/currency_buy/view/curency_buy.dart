import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../../../service/services/signal_r/model/asset_payment_methods.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../shared/helpers/widget_size_from.dart';
import '../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../helpers/are_balances_empty.dart';
import '../../../helpers/format_currency_string_amount.dart';
import '../../../models/currency_model.dart';
import '../../../providers/converstion_price_pod/conversion_price_input.dart';
import '../../../providers/converstion_price_pod/conversion_price_pod.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../model/preview_buy_with_asset_input.dart';
import '../notifier/currency_buy_notifier/currency_buy_notipod.dart';
import 'preview_buy_with_asset.dart';
import 'simplex_web_view.dart';

// TODO make isBuyFromCard not optional
class CurrencyBuy extends StatefulHookWidget {
  const CurrencyBuy({
    Key? key,
    this.isFromBuyFromCard = false,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;
  final bool isFromBuyFromCard;

  @override
  State<CurrencyBuy> createState() => _CurrencyBuyState();
}

class _CurrencyBuyState extends State<CurrencyBuy> {
  @override
  void initState() {
    final notifier = context.read(currencyBuyNotipod(widget.currency).notifier);
    notifier.initDefaultPaymentMethod(
      isFromBuyFromCard: widget.isFromBuyFromCard,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = useProvider(deviceSizePod);
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
        pinned: const SBottomSheetHeader(
          name: 'Pay from',
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
                  color: currency == state.selectedCurrency
                      ? colors.blue
                      : colors.black,
                  url: currency.iconUrl,
                ),
                name: currency.description,
                amount: currency.volumeBaseBalance(
                  state.baseCurrency!,
                ),
                onTap: () => Navigator.pop(context, currency),
              ),
          for (final method in widget.currency.buyMethods)
            if (method.type == PaymentMethodType.simplex)
              SActionItem(
                isSelected: state.selectedCurrency == null,
                icon: SActionDepositIcon(
                  color: state.selectedCurrency == null
                      ? colors.blue
                      : colors.black,
                ),
                name: 'Bank Card - Simplex',
                description: 'Visa, Mastercard, Apple Pay',
                onTap: () => Navigator.pop(context, method),
              ),
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
      loading: loader.value,
      header: SPaddingH24(
        child: SSmallHeader(
          title: 'Buy ${widget.currency.description}',
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
                  medium: () => -4,
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
              if (emptyBalances && !widget.currency.supportsAtLeastOneBuyMethod)
                SPaymentSelectEmptyBalance(
                  widgetSize: widgetSizeFrom(deviceSize),
                )
              else if (state.selectedPaymentMethod?.type ==
                  PaymentMethodType.simplex)
                SPaymentSelectAsset(
                  widgetSize: widgetSizeFrom(deviceSize),
                  isCreditCard: true,
                  icon: SActionDepositIcon(
                    color: colors.black,
                  ),
                  name: 'Bank Card - Simplex',
                  helper: '≈ 10-30 min',
                  description: 'Visa, Mastercard, Apple Pay',
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
                small: () => const Spacer(),
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
                submitButtonName: 'Preview Buy',
                onSubmitPressed: () async {
                  if (state.selectedPaymentMethod != null) {
                    disableSubmit.value = true;
                    loader.value.startLoading();
                    final response = await notifier.makeSimplexRequest();
                    loader.value.finishLoading();
                    disableSubmit.value = false;

                    if (response != null) {
                      if (!mounted) return;
                      navigatorPushReplacement(
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
