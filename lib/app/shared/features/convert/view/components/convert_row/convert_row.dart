import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../components/asset_tile/asset_tile.dart';
import '../../../../../components/basic_bottom_sheet/basic_bottom_sheet.dart';
import '../../../../../components/text/asset_sheet_header.dart';
import '../../../../../models/currency_model.dart';
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

    void _showDropdownSheet() {
      showBasicBottomSheet(
        context: context,
        scrollable: true,
        color: const Color(0xFF4F4F4F),
        pinned: AssetSheetHeader(
          text: fromAsset ? 'From' : 'To',
        ),
        children: [
          for (final item in currencies)
            AssetTile(
              currency: item,
              onTap: () {
                if (currency == item) {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context, item);
                }
              },
              selectedBorder: currency == item,
            ),
        ],
        then: (value) {
          if (value is CurrencyModel) {
            onDropdown(value);
          }
        },
        onDissmis: () => Navigator.pop(context),
      );
    }

    return SPaddingH24(
      child: Stack(
        children: [
          SizedBox(
            height: 88,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceH22(),
                Baseline(
                  baseline: 20.h,
                  baselineType: TextBaseline.alphabetic,
                  child: Row(
                    textBaseline: TextBaseline.alphabetic,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Expanded(
                        child: ConvertDropdownButton(
                          onTap: () => _showDropdownSheet(),
                          currency: currency,
                        ),
                      ),
                      STransparentInkWell(
                        onTap: onTap,
                        child: SizedBox(
                          width: 170.w,
                          child: Text(
                            value.isEmpty ? 'min 0.001' : value,
                            textAlign: TextAlign.end,
                            style: sTextH3Style.copyWith(
                              color: enabled ? colors.black : colors.grey2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const SpaceW34(),
                    Baseline(
                      baseline: 18.h,
                      baselineType: TextBaseline.alphabetic,
                      child: Expanded(
                        child: Text(
                          'Available: ${currency.formattedAssetBalance}',
                          maxLines: 1,
                          style: sBodyText2Style.copyWith(
                            color: colors.grey2,
                          ),
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
