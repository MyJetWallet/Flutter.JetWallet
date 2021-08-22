import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../shared/components/spacers.dart';
import '../../header_text.dart';

class EmptyWatchlist extends StatelessWidget {
  const EmptyWatchlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.star_border,
          size: 0.3.sw,
        ),
        const SpaceH8(),
        const HeaderText(
          text: 'Create your Watchlist',
          textAlign: TextAlign.center,
        ),
        const SpaceH8(),
        const Text('Star an asset to add it to your Watchlist'),
      ],
    );
  }
}
