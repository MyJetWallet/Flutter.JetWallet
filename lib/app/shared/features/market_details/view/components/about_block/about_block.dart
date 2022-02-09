import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../service/services/market_info/model/market_info_response_model.dart';
import 'components/about_block_text.dart';

class AboutBlock extends HookWidget {
  const AboutBlock({
    Key? key,
    required this.marketInfo,
    required this.showDivider,
  }) : super(key: key);

  final MarketInfoResponseModel marketInfo;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpaceH6(),
        Text(
          'About',
          style: sTextH4Style,
        ),
        const SpaceH20(),
        AboutBlockText(
          marketInfo: marketInfo,
          showDivider: showDivider,
        ),
      ],
    );
  }
}
