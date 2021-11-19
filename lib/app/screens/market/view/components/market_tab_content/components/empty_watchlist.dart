import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/constants.dart';

class EmptyWatchlist extends HookWidget {
  const EmptyWatchlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Column(
      children: [
        const SpaceH40(),
        SvgPicture.asset(
          watchlistImageAsset,
          width: 320.r,
          height: 320.r,
        ),
        const SpaceH51(),
        Text(
          'Create your Watchlist',
          style: sTextH4Style,
        ),
        const SpaceH5(),
        Text(
          'Star an asset to add it to your Watchlist',
          style: sBodyText1Style.copyWith(
            color: colors.grey1,
          ),
        ),
      ],
    );
  }
}
