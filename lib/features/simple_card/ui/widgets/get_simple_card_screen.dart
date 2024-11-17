import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:jetwallet/utils/extension/string_extension.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../../../core/l10n/i10n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../utils/constants.dart';

@RoutePage(name: 'GetSimpleCardRouter')
class GetSimpleCardScreen extends StatelessWidget {
  const GetSimpleCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: '',
      header: GlobalBasicAppBar(
        title: '',
        hasLeftIcon: false,
        onRightIconTap: () {
          sRouter.maybePop(false);
        },
      ),
      child: SPaddingH24(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 192,
              ),
              children: [
                Image.asset(
                  simpleCardRotatedAsset,
                ),
                Text(
                  intl.card_header,
                  style: STStyles.header5,
                ),
                const Gap(16),
                _StyledText(
                  text: intl.get_simple_card_provide_documents,
                ),
                const Gap(16),
                _StyledText(
                  text: intl.get_simple_card_this_can_be,
                ),
                const Gap(16),
                _StyledList(
                  firstLine: intl.get_simple_card_eu_citizen_passport,
                  firstLineIcon: Assets.svg.large.euro.simpleSvg(),
                  secondLine: intl.get_simple_card_residence_permit,
                  secondLineIcon: Assets.svg.large.home.simpleSvg(),
                ),
                const Gap(16),
                _StyledText(
                  text: intl.get_simple_card_need_confirm_residential_address,
                ),
                const Gap(16),
                _StyledList(
                  firstLine: intl.get_simple_card_bank_statement,
                  firstLineIcon: Assets.svg.large.bank.simpleSvg(),
                  secondLine: intl.get_simple_card_utility_bill,
                  secondLineIcon: Assets.svg.medium.document.simpleSvg(),
                ),
                const Gap(16),
                _StyledText(
                  text: intl.get_simple_card_provide_tin,
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                ),
                child: Column(
                  children: [
                    SButton.black(
                      text: intl.next.capitalize(),
                      callback: () {
                        sRouter.maybePop(true);
                      },
                    ),
                    const Gap(8),
                    SButton.outlined(
                      text: intl.cancel.capitalize(),
                      callback: () {
                        sRouter.maybePop(false);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StyledText extends StatelessWidget {
  const _StyledText({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: STStyles.subtitle2.copyWith(
        overflow: TextOverflow.visible,
        color: SColorsLight().gray10,
      ),
    );
  }
}

class _StyledList extends StatelessWidget {
  const _StyledList({
    required this.firstLine,
    required this.firstLineIcon,
    required this.secondLine,
    required this.secondLineIcon,
  });

  final String firstLine;
  final SvgPicture firstLineIcon;
  final String secondLine;
  final SvgPicture secondLineIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SColorsLight().gray2,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              firstLineIcon,
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  firstLine,
                  style: STStyles.subtitle2.copyWith(
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ],
          ),
          const Gap(16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              secondLineIcon,
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  secondLine,
                  style: STStyles.subtitle2.copyWith(
                    overflow: TextOverflow.visible,
                    color: SColorsLight().black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
