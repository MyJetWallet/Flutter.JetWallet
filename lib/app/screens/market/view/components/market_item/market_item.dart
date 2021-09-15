import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/features/market_details/view/market_details.dart';
import '../../../model/market_item_model.dart';
import 'components/market_item_card.dart';

class MarketItem extends StatelessWidget {
  const MarketItem({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigatorPush(
          context,
          MarketDetails(
            marketItem: marketItem,
          ),
        );
      },
      customBorder: Border.all(),
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        child: MarketItemCard(
          marketItem: marketItem,
        ),
      ),
    );
  }
}
