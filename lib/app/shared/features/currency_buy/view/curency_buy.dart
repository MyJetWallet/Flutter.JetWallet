import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../../../service/services/signal_r/model/asset_payment_methods.dart';
import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../helpers/format_currency_string_amount.dart';
import '../../../helpers/input_helpers.dart';
import '../../../models/currency_model.dart';
import '../../../providers/converstion_price_pod/conversion_price_input.dart';
import '../../../providers/converstion_price_pod/conversion_price_pod.dart';
import '../notifier/currency_buy_notifier/currency_buy_notipod.dart';
import 'simplex_web_view.dart';

class CurrencyBuy extends StatefulHookWidget {
  const CurrencyBuy({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  State<CurrencyBuy> createState() => _CurrencyBuyState();
}

class _CurrencyBuyState extends State<CurrencyBuy> {
  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final state = useProvider(currencyBuyNotipod(widget.currency));
    final notifier = useProvider(currencyBuyNotipod(widget.currency).notifier);
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
          SActionItem(
            icon: const SActionBuyIcon(),
            name: 'Bank Card - Simplex',
            description: 'Visa, Mastercard, Apple Pay',
            helper: 'Fee 6%',
            onTap: () => Navigator.pop(context),
          ),
          // TODO when support for crypto will be avavilable
          // for (final currency in state.currencies)
          //   if (currency.type == AssetType.crypto)
          //     SAssetItem(
          //       isSelected: currency == state.selectedCurrency,
          //       icon: SNetworkSvg24(
          //         color: currency == state.selectedCurrency
          //             ? colors.blue
          //             : colors.black,
          //         url: currency.iconUrl,
          //       ),
          //       name: currency.description,
          //       amount: currency.volumeBaseBalance(
          //         state.baseCurrency!,
          //       ),
          //       description: currency.volumeAssetBalance,
          //       onTap: () => Navigator.pop(context, currency),
          //     )
          //   else
          //     SFiatItem(
          //       isSelected: currency == state.selectedCurrency,
          //       icon: SNetworkSvg24(
          //         color: currency == state.selectedCurrency
          //             ? colors.blue
          //             : colors.black,
          //         url: currency.iconUrl,
          //       ),
          //       name: currency.description,
          //       amount: currency.volumeBaseBalance(
          //         state.baseCurrency!,
          //       ),
          //       onTap: () => Navigator.pop(context, currency),
          //     ),
          const SpaceH40(),
        ],
        context: context,
        then: (value) {
          if (value is CurrencyModel) {
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
              SActionPriceField(
                price: formatCurrencyStringAmount(
                  prefix: state.selectedCurrency?.prefixSymbol,
                  value: state.inputValue,
                  symbol: state.selectedCurrencySymbol,
                ),
                helper: state.conversionText(widget.currency),
                error: state.inputError.value,
                isErrorActive: state.inputError.isActive,
              ),
              const Spacer(),
              if (state.selectedCurrency == null &&
                  state.selectedPaymentMethod == null)
                SPaymentSelectDefault(
                  icon: const SActionBuyIcon(),
                  name: 'Choose payment method',
                  onTap: () => _showAssetSelector(),
                )
              else if (state.selectedPaymentMethod!.type ==
                  PaymentMethodType.simplex)
                SPaymentSelectAsset(
                  icon: SActionDepositIcon(
                    color: colors.black,
                  ),
                  name: 'Bank Card - Simplex',
                  description: 'Visa, Mastercard, Apple Pay',
                  helper: 'Fee 3.5%',
                  onTap: () => _showAssetSelector(),
                )
              else if (state.selectedCurrency!.type == AssetType.crypto)
                SPaymentSelectAsset(
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
                  icon: SNetworkSvg24(
                    url: state.selectedCurrency!.iconUrl,
                  ),
                  name: state.selectedCurrency!.description,
                  amount: state.selectedCurrency!.volumeBaseBalance(
                    state.baseCurrency!,
                  ),
                  onTap: () => _showAssetSelector(),
                ),
              const SpaceH20(),
              SNumericKeyboardAmount(
                preset1Name: '25%',
                preset2Name: '50%',
                preset3Name: 'MAX',
                selectedPreset: state.selectedPreset,
                onPresetChanged: (preset) {
                  notifier.selectPercentFromBalance(preset);
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
                  disableSubmit.value = true;
                  loader.value.startLoading();
                  final response = await notifier.makeSimplexRequest();
                  loader.value.finishLoading();
                  disableSubmit.value = false;

                  if (response != null) {
                    if (!mounted) return;
                    navigatorPushReplacement(context, SimplexWebView(response));
                  }

                  // TODO when support for crypto will be avavilable
                  // navigatorPush(
                  //   context,
                  //   PreviewBuyWithAsset(
                  //     input: PreviewBuyWithAssetInput(
                  //       amount: state.inputValue,
                  //       fromCurrency: state.selectedCurrency!,
                  //       toCurrency: currency,
                  //     ),
                  //   ),
                  // );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
