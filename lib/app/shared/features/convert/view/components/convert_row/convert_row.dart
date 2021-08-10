import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../../shared/components/spacers.dart';
import '../../../../../../screens/market/model/currency_model.dart';
import 'components/convert_asset_input.dart';
import 'components/convert_dropdown.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                  currency.iconUrl,
                  width: 35.w,
                  height: 35.w,
                ),
                const SpaceW10(),
                ConvertDropdown(
                  value: currency,
                  currencies: currencies,
                  onChanged: onDropdown,
                ),
              ],
            ),
            if (fromAsset)
              Text(
                'Available: ${currency.assetBalance} ${currency.symbol}',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              )
            else
              const SizedBox(),
          ],
        ),
        ConvertAssetInput(
          onTap: onTap,
          value: value,
          enabled: enabled,
        )
      ],
    );
  }
}
