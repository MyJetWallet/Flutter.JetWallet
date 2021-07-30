import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/components/page_frame/components/arrow_back_button.dart';
import '../../../../market/model/market_item_model.dart';
import 'components/asset_day_change.dart';
import 'components/asset_info.dart';
import 'components/asset_price.dart';

class MarketDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MarketDetailsAppBar({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ArrowBackButton(
            onTap: () => Navigator.of(context).pop(),
          ),
          AssetInfo(
            asset: marketItem,
          ),
          AssetPrice(
            price: marketItem.lastPrice,
          ),
          AssetDayChange(
            asset: marketItem,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(150.h);
}
