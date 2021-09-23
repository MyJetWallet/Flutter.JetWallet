import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../shared/components/spacers.dart';
import '../../helpers/format_asset_price_value.dart';
import '../../models/currency_model.dart';
import '../../providers/base_currency_pod/base_currency_model.dart';
import '../../providers/base_currency_pod/base_currency_pod.dart';
import 'components/asset_tile_column.dart';

class AssetTile extends HookWidget {
  const AssetTile({
    Key? key,
    this.onTap,
    this.firstColumnHeader,
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

  /// First text displayed in the first column
  final String? firstColumnHeader;

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
    final baseCurrency = useProvider(baseCurrencyPod);

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
                header: firstColumnHeader ?? currency.description,
                subheader: firstColumnSubheader ?? currency.symbol,
                headerColor: headerColor,
                subheaderColor: subheaderColor,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              const Spacer(),
              if (enableBalanceColumn)
                AssetTileColumn(
                  header: leadingAssetBalance
                      ? _assetBalance(baseCurrency)
                      : _baseBalance(baseCurrency),
                  subheader: leadingAssetBalance
                      ? _baseBalance(baseCurrency)
                      : _assetBalance(baseCurrency),
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

  String _baseBalance(BaseCurrencyModel baseCurrency) => formatPriceValue(
        prefix: baseCurrency.prefix,
        value: currency.baseBalance,
        accuracy: baseCurrency.accuracy,
      );

  String _assetBalance(BaseCurrencyModel baseCurrency) => formatPriceValue(
        value: currency.assetBalance,
        symbol: currency.symbol,
        accuracy: baseCurrency.accuracy,
      );
}
