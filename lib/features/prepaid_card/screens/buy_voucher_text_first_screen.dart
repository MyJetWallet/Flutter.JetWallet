import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

class BuyVoucherTextFirstScreen extends StatelessWidget {
  const BuyVoucherTextFirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SPaddingH24(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  intl.prepaid_card_guide_to_using,
                  style: STStyles.header5,
                ),
                const SpaceH16(),
                Text(
                  intl.prepaid_card_you_purchase,
                  style: STStyles.body1Medium.copyWith(
                    color: colors.gray10,
                  ),
                  maxLines: 10,
                ),
                const SpaceH16(),
                SBannerBasic(
                  text: intl.prepaid_card_funds_for_purchased,
                  icon: Assets.svg.small.warning,
                  color: colors.redExtralight,
                  corners: BannerCorners.rounded,
                ),
                const SpaceH4(),
                SBannerBasic(
                  text: intl.prepaid_card_the_purchased,
                  icon: Assets.svg.small.warning,
                  color: colors.yellowExtralight,
                  corners: BannerCorners.rounded,
                ),
                const SpaceH24(),
                Text(
                  intl.prepaid_card_ApplePay_and_GooglePay,
                  style: STStyles.body1Semibold,
                  maxLines: 2,
                ),
                const SpaceH4(),
                Text(
                  intl.prepaid_card_cards_marked,
                  style: STStyles.body1Medium.copyWith(
                    color: colors.gray10,
                  ),
                  maxLines: 10,
                ),
                const SpaceH16(),
                Text(
                  intl.prepaid_card_please_note,
                  style: STStyles.body1Semibold,
                  maxLines: 2,
                ),
                const SpaceH4(),
                Text(
                  intl.prepaid_card_that_cards,
                  style: STStyles.body1Medium.copyWith(
                    color: colors.gray10,
                  ),
                  maxLines: 10,
                ),
                const SafeArea(
                  child: SpaceH120(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
