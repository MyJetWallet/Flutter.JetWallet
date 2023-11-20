import 'package:flutter/material.dart';
import 'package:jetwallet/features/simple_card/ui/widgets/card_options.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

import '../../../../core/l10n/i10n.dart';

class GetCardBanner extends StatelessWidget {
  const GetCardBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SPaddingH24(
      child: InkWell(
        onTap: () {
          showCardOptions(context);
        },
        child: Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: colors.blueLight,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                child: Column(
                  children: [
                    Text(
                      intl.simple_card_get_card_now,
                      style: sBodyText1Style.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.black,
                      ),
                      maxLines: 2,
                    ),
                    const SpaceH20(),
                  ],
                ),
              ),
              const Spacer(),
              Image.asset(
                simpleCardBannerAsset,
                height: 68,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
