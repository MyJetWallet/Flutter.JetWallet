import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../models/currency_model.dart';
import '../../../../../providers/base_currency_pod/base_currency_pod.dart';
import 'components/convert_dropdown_button.dart';

class ConvertRow extends HookWidget {
  const ConvertRow({
    Key? key,
    this.fromAsset = false,
    required this.value,
    required this.onTap,
    required this.enabled,
    required this.currency,
    required this.currencies,
    required this.onDropdown,
  }) : super(key: key);

  final bool fromAsset;
  final String value;
  final Function() onTap;
  final bool enabled;
  final CurrencyModel currency;
  final List<CurrencyModel> currencies;
  final Function(CurrencyModel?) onDropdown;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final baseCurrency = useProvider(baseCurrencyPod);
    final cursorAnimation = useAnimationController(
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    useListenable(cursorAnimation);

    void _showDropdownSheet() {
      sShowBasicModalBottomSheet(
        context: context,
        scrollable: true,
        pinned: SBottomSheetHeader(
          name: fromAsset ? 'From' : 'To',
        ),
        children: [
          for (final item in currencies)
            SAssetItem(
              isSelected: currency == item,
              icon: SNetworkSvg24(
                url: item.iconUrl,
              ),
              name: item.description,
              description: item.symbol,
              amount: item.formatBaseBalance(baseCurrency),
              onTap: () {
                if (currency == item) {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context, item);
                }
              },
            ),
        ],
        then: (value) {
          if (value is CurrencyModel) {
            onDropdown(value);
          }
        },
      );
    }

    return SPaddingH24(
      child: Stack(
        children: [
          SizedBox(
            height: 88.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceH22(),
                Baseline(
                  baseline: 20.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Row(
                    textBaseline: TextBaseline.alphabetic,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      ConvertDropdownButton(
                        onTap: () => _showDropdownSheet(),
                        currency: currency,
                      ),
                      Expanded(
                        child: STransparentInkWell(
                          onTap: onTap,
                          child: Text(
                            value.isEmpty ? 'min 0.001' : value,
                            textAlign: TextAlign.end,
                            style: sTextH3Style.copyWith(
                              color: enabled
                                  ? value.isEmpty
                                      ? colors.grey2
                                      : colors.black
                                  : colors.grey2,
                            ),
                          ),
                        ),
                      ),
                      if (enabled) ...[
                        const SpaceW5(),
                        if (cursorAnimation.value > 0.5)
                          Container(
                            width: 4.0,
                            height: 36.0,
                            color: colors.blue,
                          )
                        else
                          const SpaceW4()
                      ] else
                        const SpaceW9()
                    ],
                  ),
                ),
                Row(
                  children: [
                    const SpaceW34(),
                    Baseline(
                      baseline: 16.0,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        'Available: ${currency.formattedAssetBalance}',
                        maxLines: 1,
                        style: sBodyText2Style.copyWith(
                          color: colors.grey2,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
