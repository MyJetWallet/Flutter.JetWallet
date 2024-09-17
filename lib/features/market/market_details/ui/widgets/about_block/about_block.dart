import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/market_info/market_info_response_model.dart';
import 'components/about_block_text.dart';

class AboutBlock extends StatelessWidget {
  const AboutBlock({
    super.key,
    required this.marketInfo,
    required this.isCpower,
  });

  final MarketInfoResponseModel marketInfo;
  final bool isCpower;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpaceH16(),
        STableHeader(
          title: intl.aboutBlock_about,
          size: SHeaderSize.m,
          needHorizontalPadding: false,
        ),
        AboutBlockText(
          marketInfo: marketInfo,
          isCpower: isCpower,
        ),
      ],
    );
  }
}
