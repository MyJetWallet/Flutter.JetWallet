import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../../helpers/currencies_helpers.dart';
import '../../../models/currency_model.dart';
import '../../../providers/converstion_price_pod/conversion_price_input.dart';
import '../../../providers/converstion_price_pod/conversion_price_pod.dart';
import '../model/preview_convert_input.dart';
import '../notifier/convert_input_notifier/convert_input_notipod.dart';
import 'components/convert_row/convert_row.dart';
import 'preview_convert.dart';

class Convert extends HookWidget {
  const Convert({
    Key? key,
    this.fromCurrency,
  }) : super(key: key);

  final CurrencyModel? fromCurrency;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final state = useProvider(convertInputNotipod(fromCurrency));
    final notifier = useProvider(convertInputNotipod(fromCurrency).notifier);
    useProvider(
      conversionPriceFpod(
        ConversionPriceInput(
          baseAssetSymbol: state.fromAsset.symbol,
          quotedAssetSymbol: state.toAsset.symbol,
          then: notifier.updateConversionPrice,
        ),
      ),
    );

    final fromAssetWithBalance = _currenciesWithBalance(state.fromAssetList);
    final fromAssetWithoutBalance =
        _currenciesWithoutBalance(state.fromAssetList);

    final toAssetWithBalance = _currenciesWithBalance(state.toAssetList);
    final toAssetWithoutBalance = _currenciesWithoutBalance(state.toAssetList);

    sortCurrenciesByWeight(fromAssetWithoutBalance);
    sortCurrenciesByWeight(toAssetWithoutBalance);

    return SPageFrame(
      header: const SPaddingH24(
        child: SSmallHeader(
          title: 'Convert',
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          ConvertRow(
            value: state.fromAssetAmount,
            inputError: state.inputError,
            enabled: state.fromAssetEnabled,
            currency: state.fromAsset,
            assetWithBalance: fromAssetWithBalance,
            assetWithoutBalance: fromAssetWithoutBalance,
            onTap: () => notifier.enableFromAsset(),
            onDropdown: (value) => notifier.updateFromAsset(value!),
            fromAsset: true,
          ),
          const Spacer(),
          Stack(
            children: [
              Column(
                children: [
                  const SpaceH20(),
                  SDivider(
                    color: colors.grey3,
                  ),
                ],
              ),
              Center(
                child: SIconButton(
                  onTap: () => notifier.switchFromAndTo(),
                  defaultIcon: const SConvertIcon(),
                  pressedIcon: const SConvertPressedIcon(),
                ),
              ),
            ],
          ),
          const Spacer(),
          ConvertRow(
            value: state.toAssetAmount,
            enabled: state.toAssetEnabled,
            currency: state.toAsset,
            assetWithBalance: toAssetWithBalance,
            assetWithoutBalance: toAssetWithoutBalance,
            onTap: () => notifier.enableToAsset(),
            onDropdown: (value) => notifier.updateToAsset(value!),
          ),
          const Spacer(),
          SNumericKeyboardAmount(
            widgetSize: SWidgetSize.medium,
            preset1Name: '25%',
            preset2Name: '50%',
            preset3Name: 'MAX',
            selectedPreset: state.selectedPreset,
            onPresetChanged: (preset) {
              notifier.selectPercentFromBalance(preset);
            },
            onKeyPressed: (value) {
              if (state.fromAssetEnabled) {
                notifier.updateFromAssetAmount(value);
              } else {
                notifier.updateToAssetAmount(value);
              }
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: state.convertValid,
            submitButtonName: 'Preview Convert',
            onSubmitPressed: () {
              navigatorPush(
                context,
                PreviewConvert(
                  input: PreviewConvertInput(
                    fromAmount: state.fromAssetAmount,
                    toAmount: state.toAssetAmount,
                    fromCurrency: state.fromAsset,
                    toCurrency: state.toAsset,
                    toAssetEnabled: state.toAssetEnabled,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<CurrencyModel> _currenciesWithBalance(
      List<CurrencyModel> fromAssetList) {
    final list = <CurrencyModel>[];
    if (fromAssetList.isNotEmpty) {
      for (final element in fromAssetList) {
        if (element.baseBalance != Decimal.zero) {
          list.add(element);
        }
      }
    }

    return list;
  }

  List<CurrencyModel> _currenciesWithoutBalance(
      List<CurrencyModel> fromAssetList) {
    final list = <CurrencyModel>[];
    if (fromAssetList.isNotEmpty) {
      for (final element in fromAssetList) {
        if (element.baseBalance == Decimal.zero) {
          list.add(element);
        }
      }
    }

    return list;
  }
}
