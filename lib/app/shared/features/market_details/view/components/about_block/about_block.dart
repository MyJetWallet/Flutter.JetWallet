import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../service/services/market_info/model/market_info_response_model.dart';
import 'components/about_block_text.dart';

class AboutBlock extends HookWidget {
  const AboutBlock({
    Key? key,
    required this.marketInfo,
  }) : super(key: key);

  final MarketInfoResponseModel marketInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 56,
          child: Baseline(
            baseline: 49,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              'About',
              style: sTextH4Style,
            ),
          ),
        ),
        const SpaceH24(),
        AboutBlockText(
          marketInfo: marketInfo,
        ),
      ],
    );
  }
}
