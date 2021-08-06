import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../shared/components/spacers.dart';
import '../../../../../../screens/market/model/currency_model.dart';
import 'components/asset_tile_column.dart';

class AssetTile extends StatelessWidget {
  const AssetTile({
    Key? key,
    this.leadingAssetBalance = false,
    this.selectedBorder = false,
    this.headerColor = Colors.white,
    this.subheaderColor = Colors.grey,
    required this.onTap,
    required this.currency,
  }) : super(key: key);

  final bool leadingAssetBalance;
  final bool selectedBorder;
  final Color headerColor;
  final Color subheaderColor;
  final Function() onTap;
  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4.h,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: selectedBorder ? Colors.white : Colors.grey[600]!,
            ),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Row(
            children: [
              Image.network(
                currency.iconUrl,
                width: 30.w,
                height: 30.w,
              ),
              const SpaceW10(),
              AssetTileColumn(
                header: currency.description,
                subheader: currency.symbol,
                headerColor: headerColor,
                subheaderColor: subheaderColor,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              const Spacer(),
              AssetTileColumn(
                header: leadingAssetBalance ? _assetBalance : _baseBalance,
                subheader: leadingAssetBalance ? _baseBalance : _assetBalance,
                headerColor: headerColor,
                subheaderColor: subheaderColor,
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _baseBalance => '\$${currency.baseBalance}';
  String get _assetBalance => '${currency.assetBalance} ${currency.symbol}';
}
