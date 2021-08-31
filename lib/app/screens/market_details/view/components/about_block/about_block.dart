import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../../service/services/market_info/model/market_info_response_model.dart';
import '../../../../../../shared/components/spacers.dart';
import '../../../../market/view/components/header_text.dart';
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
        const HeaderText(
          text: 'About',
          textAlign: TextAlign.start,
        ),
        const SpaceH8(),
        AboutBlockText(
          marketInfo: marketInfo,
        ),
      ],
    );
  }
}
