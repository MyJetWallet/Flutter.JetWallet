import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../shared/components/header_text.dart';
import '../../../../../../../shared/components/spacers.dart';
import '../../../../../shared/features/wallet/provider/wallet_hidden_stpod.dart';

class PortfolioWithBalanceAppBar extends HookWidget
    implements PreferredSizeWidget {
  const PortfolioWithBalanceAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hidden = useProvider(walletHiddenStPod);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const SpaceR20(),
              const Expanded(
                child: HeaderText(
                  text: 'Balance',
                  textAlign: TextAlign.center,
                ),
              ),
              InkWell(
                onTap: () => hidden.state = !hidden.state,
                child: Icon(
                  hidden.state ? Icons.visibility_off : Icons.visibility,
                  size: 20.r,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
