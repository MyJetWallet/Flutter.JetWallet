import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class BuyVoucherTextThirdScreen extends StatelessWidget {
  const BuyVoucherTextThirdScreen({super.key});

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
                  intl.prepaid_card_voucher_activation,
                  style: STStyles.header5,
                ),
                const SpaceH16(),
                Text(
                  intl.prepaid_card_to_activate,
                  style: STStyles.body1Medium.copyWith(
                    color: colors.gray10,
                  ),
                  maxLines: 10,
                ),
                const SpaceH16(),
                SBannerBasic(
                  text: intl.prepaid_card_a_mismatch_between,
                  icon: Assets.svg.small.warning,
                  color: colors.redExtralight,
                  corners: BannerCorners.rounded,
                ),
                const SpaceH4(),
                SBannerBasic(
                  text: intl.prepaid_card_the_issuer_may,
                  icon: Assets.svg.small.warning,
                  color: colors.yellowExtralight,
                  corners: BannerCorners.rounded,
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
