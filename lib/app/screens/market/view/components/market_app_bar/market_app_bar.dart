import 'package:flutter/material.dart';

import '../../../../../../shared/components/header_text.dart';
import '../market_tabs/market_tabs.dart';
import 'components/search_button.dart';

class MarketAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MarketAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          HeaderText(
            text: 'Market',
            textAlign: TextAlign.start,
          ),
          SearchButton(),
        ],
      ),
      bottom: const MarketTabs(),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(
      kToolbarHeight + const MarketTabs().preferredSize.height,
    );
  }
}
