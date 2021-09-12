import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/components/header_text.dart';
import '../../../../../../shared/components/page_frame/components/arrow_back_button.dart';
import '../../../../../../shared/components/spacers.dart';
import '../../../provider/market_stpod.dart';
import '../../../provider/search_stpod.dart';
import '../market_tabs/market_tabs.dart';
import 'components/search_field.dart';

class SearchAppBar extends HookWidget implements PreferredSizeWidget {
  const SearchAppBar({Key? key}) : super(key: key);

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
          ArrowBackButton(
            onTap: () {
              state.state = MarketState.watch;
              search.state.clear();
            },
          ),
          const HeaderText(
            text: 'Search coins',
            textAlign: TextAlign.start,
          ),
          const SpaceH4(),
          const SearchField(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(
      kToolbarHeight + const MarketTabs().preferredSize.height,
    );
  }
}
