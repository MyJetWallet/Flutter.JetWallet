import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../shared/components/spacers.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../components/balance_selector/view/percent_selector.dart';
import '../../../components/number_keyboard/number_keyboard.dart';
import '../notifier/convert_input_notifier/convert_input_notipod.dart';
import '../notifier/convert_notifier/convert_notipod.dart';
import '../provider/conversion_price_input.dart';
import '../provider/conversion_price_pod.dart';
import 'components/convert_preview/convert_preview.dart';
import 'components/convert_row/convert_row.dart';
import 'components/swap_button.dart';

class Convert extends HookWidget {
  const Convert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final input = useProvider(convertInputNotipod(null));
    final inputN = useProvider(convertInputNotipod(null).notifier);
    final convertN = useProvider(convertNotipod.notifier);
    useProvider(
      conversionPriceFpod(
        ConversionPriceInput(
          baseAssetSymbol: input.fromAsset.symbol,
          quotedAssetSymbol: input.toAsset.symbol,
          convertInputN: inputN,
        ),
      ),
    );

    return PageFrame(
      header: 'Convert',
      onBackButton: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConvertRow(
            value: input.fromAssetAmount,
            enabled: input.fromAssetEnabled,
            currency: input.fromAsset,
            currencies: input.fromAssetList,
            onTap: () => inputN.enableFromAsset(),
            onDropdown: (value) => inputN.updateFromAsset(value!),
            fromAsset: true,
          ),
          const SpaceH10(),
          SwapButton(
            onPressed: () => inputN.switchFromAndTo(),
          ),
          const SpaceH10(),
          ConvertRow(
            value: input.toAssetAmount,
            enabled: input.toAssetEnabled,
            currency: input.toAsset,
            currencies: input.toAssetList,
            onTap: () => inputN.enableToAsset(),
            onDropdown: (value) => inputN.updateToAsset(value!),
          ),
          const Spacer(),
          PercentSelector(
            disabled: input.toAssetEnabled,
            onSelection: (value) {
              inputN.selectPercentFromBalance(value);
            },
          ),
          const SpaceH10(),
          NumberKeyboard(
            onKeyPressed: (value) {
              if (input.fromAssetEnabled) {
                inputN.updateFromAssetAmount(value);
              } else {
                inputN.updateToAssetAmount(value);
              }
            },
          ),
          const SpaceH20(),
          AppButtonSolid(
            active: input.convertValid,
            name: 'Preview Convert',
            onTap: () {
              if (input.convertValid) {
                navigatorPush(context, const ConvertPreview());
                convertN.requestQuote(input, init: true);
              }
            },
          ),
        ],
      ),
    );
  }
}
