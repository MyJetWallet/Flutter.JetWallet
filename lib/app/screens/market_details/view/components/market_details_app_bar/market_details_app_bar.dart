import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/components/page_frame/components/arrow_back_button.dart';
import '../../../../market/model/market_item_model.dart';
import 'components/asset_day_change.dart';
import 'components/asset_info.dart';
import 'components/asset_price.dart';

class MarketDetailsAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const MarketDetailsAppBar({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  _MarketDetailsAppBarState createState() => _MarketDetailsAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(0.2.sh);
}

class _MarketDetailsAppBarState extends State<MarketDetailsAppBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ArrowBackButton(
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          AssetInfo(
            asset: widget.marketItem,
          ),
          AssetPrice(
            price: widget.marketItem.lastPrice,
          ),
          AssetDayChange(
            asset: widget.marketItem,
          ),
        ],
      ),
    );
  }
}
