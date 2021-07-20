import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../auth/shared/components/auth_frame/components/arrow_back_button.dart';
import '../../../../../shared/components/spacers.dart';
import '../../provider/market_stpod.dart';
import '../../provider/search_stpod.dart';
import 'header_text.dart';
import 'market_serach_text_field.dart';
import 'market_tabs.dart';

class MarketSearchAppBar extends HookWidget implements PreferredSizeWidget {
  const MarketSearchAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(marketStpod);
    final search = useProvider(searchStpod);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ArrowBackButton(onTap: () {
            state.state = MarketState.watch;
            search.state.clear();
          }),
          const HeaderText(
            text: 'Search coins',
            textAlign: TextAlign.start,
          ),
          const SpaceH4(),
          const MarketSearchTextField(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + const MarketTabs().preferredSize.height);
}
