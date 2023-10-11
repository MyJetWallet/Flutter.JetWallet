import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/convert/model/preview_convert_input.dart';
import 'package:jetwallet/features/convert/store/convert_input_store.dart';
import 'package:jetwallet/features/convert/ui/widgets/convert_row.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'ConvertRouter')
class Convert extends StatelessWidget {
  const Convert({
    super.key,
    this.fromCurrency,
  });

  final CurrencyModel? fromCurrency;

  @override
  Widget build(BuildContext context) {
    return Provider<ConvertInputStore>(
      create: (context) => ConvertInputStore(fromCurrency),
      builder: (context, child) => const ConvertBody(),
    );
  }
}

class ConvertBody extends StatelessObserverWidget {
  const ConvertBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;
    final store = ConvertInputStore.of(context);

    final fromAssetWithBalance = currenciesWithBalance(store.fromAssetList);
    final fromAssetWithoutBalance = currenciesWithoutBalance(store.fromAssetList);

    final toAssetWithBalance = currenciesWithBalance(store.toAssetList);
    final toAssetWithoutBalance = currenciesWithoutBalance(store.toAssetList);
    sortByBalanceAndWeight(fromAssetWithBalance);
    sortByBalanceAndWeight(fromAssetWithoutBalance);
    sortByBalanceAndWeight(toAssetWithBalance);
    sortByBalanceAndWeight(toAssetWithoutBalance);

    sortByWeight(fromAssetWithoutBalance);
    sortByWeight(toAssetWithoutBalance);

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.convert_exchange,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          deviceSize.when(
            small: () => const SizedBox(),
            medium: () => const SpaceH10(),
          ),
          ConvertRow(
            value: store.fromAssetAmount,
            inputError: store.inputError,
            enabled: store.fromAssetEnabled,
            currency: store.fromAsset!,
            assetWithBalance: fromAssetWithBalance,
            assetWithoutBalance: fromAssetWithoutBalance,
            onTap: () => store.enableFromAsset(),
            onDropdown: (value) {
              if (value?.symbol == store.toAsset?.symbol) {
                store.switchFromAndTo();
              } else {
                store.updateFromAsset(value!);
              }
            },
            fromAsset: true,
            limitError: store.limitError,
          ),
          deviceSize.when(
            small: () => const Spacer(),
            medium: () => const SpaceH10(),
          ),
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
                  onTap: () => store.switchFromAndTo(),
                  defaultIcon: const SConvertIcon(),
                  pressedIcon: const SConvertPressedIcon(),
                ),
              ),
            ],
          ),
          deviceSize.when(
            small: () => const Spacer(),
            medium: () => const SpaceH10(),
          ),
          ConvertRow(
            value: store.toAssetAmount,
            //inputError: store.inputError,
            enabled: store.toAssetEnabled,
            currency: store.toAsset!,
            assetWithBalance: toAssetWithBalance,
            assetWithoutBalance: toAssetWithoutBalance,
            onTap: () => store.enableToAsset(),
            onDropdown: (value) {
              if (value?.symbol == store.fromAsset?.symbol) {
                store.switchFromAndTo();
              } else {
                store.updateToAsset(value!);
              }
            },
            //limitError: store.limitError,
          ),
          deviceSize.when(
            small: () => const SizedBox(),
            medium: () => const Spacer(),
          ),
          SNumericKeyboardAmount(
            widgetSize: widgetSizeFrom(deviceSize),
            preset1Name: '25%',
            preset2Name: '50%',
            preset3Name: intl.max,
            selectedPreset: store.selectedPreset,
            onPresetChanged: (preset) {
              store.tapPreset(
                preset.index == 0
                    ? '25%'
                    : preset.index == 1
                        ? '50%'
                        : 'Max',
              );
              store.selectPercentFromBalance(preset);
            },
            onKeyPressed: (value) {
              if (store.fromAssetEnabled) {
                store.updateFromAssetAmount(value);
              } else {
                store.updateToAssetAmount(value);
              }
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: store.convertValid &&
                store.fromAssetAmount != '' &&
                store.fromAssetAmount != '0' &&
                store.toAssetAmount != '' &&
                store.toAssetAmount != '0' &&
                store.fromAsset != null &&
                store.toAsset != null,
            submitButtonName: intl.convert_previewExchange,
            onSubmitPressed: () {
              sRouter.push(
                PreviewConvertRouter(
                  input: PreviewConvertInput(
                    fromAmount: store.fromAssetAmount,
                    toAmount: store.toAssetAmount,
                    fromCurrency: store.fromAsset!,
                    toCurrency: store.toAsset!,
                    toAssetEnabled: store.toAssetEnabled,
                    price: store.converstionPrice ?? Decimal.zero,
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
