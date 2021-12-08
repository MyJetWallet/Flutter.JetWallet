import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../../components/convert_preview/model/convert_preview_input.dart';
import '../../../components/convert_preview/view/convert_preview.dart';
import '../../../providers/converstion_price_pod/conversion_price_input.dart';
import '../../../providers/converstion_price_pod/conversion_price_pod.dart';
import '../notifier/convert_input_notipod.dart';
import 'components/convert_row/convert_row.dart';

class Convert extends HookWidget {
  const Convert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final state = useProvider(convertInputNotipod(null));
    final notifier = useProvider(convertInputNotipod(null).notifier);
    useProvider(
      conversionPriceFpod(
        ConversionPriceInput(
          baseAssetSymbol: state.fromAsset.symbol,
          quotedAssetSymbol: state.toAsset.symbol,
          then: notifier.updateConversionPrice,
        ),
      ),
    );

    return SPageFrame(
      header: const SPaddingH24(
        child: SSmallHeader(
          title: 'Convert',
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH10(),
          // TODO (inputError.value)
          ConvertRow(
            value: state.fromAssetAmount,
            enabled: state.fromAssetEnabled,
            currency: state.fromAsset,
            currencies: state.fromAssetList,
            onTap: () => notifier.enableFromAsset(),
            onDropdown: (value) => notifier.updateFromAsset(value!),
            fromAsset: true,
          ),
          const SpaceH10(),
          Stack(
            children: [
              Column(
                children: const [
                  SpaceH20(),
                  SDivider(),
                ],
              ),
              Center(
                child: STransparentInkWell(
                  onTap: () => notifier.switchFromAndTo(),
                  child: Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SpaceH10(),
          ConvertRow(
            value: state.toAssetAmount,
            enabled: state.toAssetEnabled,
            currency: state.toAsset,
            currencies: state.toAssetList,
            onTap: () => notifier.enableToAsset(),
            onDropdown: (value) => notifier.updateToAsset(value!),
          ),
          const Spacer(),
          SNumericKeyboardAmount(
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
                ConvertPreview(
                  ConvertPreviewInput(
                    fromAssetAmount: state.fromAssetAmount,
                    fromAssetSymbol: state.fromAsset.symbol,
                    toAssetSymbol: state.toAsset.symbol,
                    action: TriggerAction.convert,
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
