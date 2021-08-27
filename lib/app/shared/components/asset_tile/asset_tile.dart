import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../shared/components/spacers.dart';
import '../../models/currency_model.dart';
import 'components/asset_tile_column.dart';

class AssetTile extends StatelessWidget {
  const AssetTile({
    Key? key,
    this.onTap,
    this.firstColumnSubheader,
    this.enableBorder = true,
    this.enableBalanceColumn = true,
    this.leadingAssetBalance = false,
    this.selectedBorder = false,
    this.headerColor = Colors.white,
    this.subheaderColor = Colors.grey,
    required this.currency,
  }) : super(key: key);

  final Function()? onTap;

  /// Second text displayed in the first column
  final String? firstColumnSubheader;

  /// Enables border of the Tile
  final bool enableBorder;

  /// Enables the column at the end of the tile with asset and base balance
  final bool enableBalanceColumn;

  /// Wether to show assetBlance first or second in the priceColumn
  final bool leadingAssetBalance;

  /// There are 2 themes of the border: selected(1) and not(2). \
  /// Selected theme is needed inside assetSheet
  final bool selectedBorder;

  /// Color of the first item in the AssetTileColumn
  final Color headerColor;

  /// Color of the second item in the AssetTileColumn
  final Color subheaderColor;
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
            border: enableBorder
                ? Border.all(
                    color: selectedBorder ? Colors.white : Colors.grey[600]!,
                  )
                : null,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                currency.iconUrl,
                width: 24.w,
                height: 24.w,
              ),
              const SpaceW10(),
              AssetTileColumn(
                header: currency.description,
                subheader: firstColumnSubheader ?? currency.symbol,
                headerColor: headerColor,
                subheaderColor: subheaderColor,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              const Spacer(),
              if (enableBalanceColumn)
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
