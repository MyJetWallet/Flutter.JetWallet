import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../components/asset_tile/asset_tile.dart';
import '../../../../../components/basic_bottom_sheet/basic_bottom_sheet.dart';
import '../../../../../components/text/asset_sheet_header.dart';
import '../../../../../helpers/format_asset_price_value.dart';
import '../../../../../models/currency_model.dart';
import 'components/convert_asset_input.dart';
import 'components/convert_dropdown_button.dart';

class ConvertRow extends StatelessWidget {
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 0.45.sw,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConvertDropdownButton(
                onTap: () => _showDropdownSheet(),
                currency: currency,
              ),
              if (fromAsset)
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'Available: ${formatPriceValue(
                      symbol: currency.symbol,
                      value: currency.assetBalance,
                      accuracy: currency.accuracy,
                    )}',
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                )
              else
                const SizedBox(),
            ],
          ),
        ),
        ConvertAssetInput(
          onTap: onTap,
          value: value,
          enabled: enabled,
        ),
      ],
    );
  }
}
