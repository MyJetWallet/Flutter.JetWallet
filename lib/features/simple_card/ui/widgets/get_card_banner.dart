import 'package:flutter/material.dart';
import 'package:jetwallet/features/simple_card/ui/widgets/card_options.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/buttons/simple_icon_button.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';

import '../../../../core/di/di.dart';
import '../../../../core/l10n/i10n.dart';
import '../../store/simple_card_store.dart';

class GetCardBanner extends StatelessWidget {
  const GetCardBanner({
    super.key,
    required this.loaderPage,
  });

  final StackLoaderStore loaderPage;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final simpleCardStore = getIt.get<SimpleCardStore>();

    return SPaddingH24(
      child: InkWell(
        onTap: () {
          simpleCardStore.setLoaderPage(loaderPage);
          showCardOptions(context);
        },
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 40,
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
            Positioned(
              top: 8,
              right: 8,
              child: SIconButton(
                onTap: () {
                  simpleCardStore.closeBanner();
                },
                defaultIcon: Assets.svg.medium.closeAlt.simpleSvg(
                  width: 20,
                  color: colors.black,
                ),
                pressedIcon: Assets.svg.medium.closeAlt.simpleSvg(
                  width: 20,
                  color: colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
