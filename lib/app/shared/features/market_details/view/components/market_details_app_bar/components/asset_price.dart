import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../../../screens/market/provider/market_items_pod.dart';
import '../../../../../wallet/helper/market_item_from.dart';

class AssetPrice extends HookWidget {
  const AssetPrice({
    Key? key,
    required this.assetId,
  }) : super(key: key);

  final String assetId;

  @override
  Widget build(BuildContext context) {
    final marketItem = marketItemFrom(
      useProvider(marketItemsPod),
      assetId,
    );

    return Text(
      '\$${marketItem.lastPrice}',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 35.sp,
        color: Colors.grey[800],
      ),
    );
  }
}
