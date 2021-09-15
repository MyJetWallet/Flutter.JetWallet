import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../shared/components/header_text.dart';
import '../../../../../../../shared/components/page_frame/components/frame_action_button.dart';
import '../../../../../../../shared/components/spacers.dart';
import '../../../../../../../shared/helpers/contains_single_element.dart';
import '../../../../../../screens/market/provider/market_items_pod.dart';
import '../../../helper/assets_with_balance_from.dart';

class WalletAppBar extends HookWidget implements PreferredSizeWidget {
  const WalletAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemsWithBalance = assetsWithBalanceFrom(useProvider(marketItemsPod));

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: Row(
        children: [
          FrameActionButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: HeaderText(
              text: containsSingleElement(itemsWithBalance)
                  ? 'Wallet'
                  : 'Wallets',
              textAlign: TextAlign.center,
            ),
          ),
          const SpaceW32(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
