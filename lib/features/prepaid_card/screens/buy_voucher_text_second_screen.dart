import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class BuyVoucherTextSecondScreen extends StatelessWidget {
  const BuyVoucherTextSecondScreen({super.key});

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
                  intl.prepaid_card_privacy,
                  style: STStyles.header5,
                ),
                const SpaceH16(),
                Text(
                  intl.prepaid_card_simple_does_not,
                  style: STStyles.body1Medium.copyWith(
                    color: colors.gray10,
                  ),
                  maxLines: 10,
                ),
                const SpaceH16(),
                Text(
                  intl.prepaid_card_the_full_name,
                  style: STStyles.body1Medium.copyWith(
                    color: colors.gray10,
                  ),
                  maxLines: 10,
                ),
                const SpaceH16(),
                Text(
                  intl.prepaid_card_it_is_necessary,
                  style: STStyles.body1Medium.copyWith(
                    color: colors.gray10,
                  ),
                  maxLines: 10,
                ),
                const SpaceH16(),
                SBannerBasic(
                  text: intl.prepaid_card_in_some_instances,
                  icon: Assets.svg.small.warning,
                  color: colors.yellowExtralight,
                  corners: BannerCorners.rounded,
                ),
                const SpaceH24(),
                Text(
                  intl.prepaid_card_only_the_individual,
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
