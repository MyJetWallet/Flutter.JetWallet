import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

class DPConditionMenu extends StatelessObserverWidget {
  const DPConditionMenu({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onTap,
    this.isLinkActie = false,
  });

  final String title;
  final String subTitle;
  final bool isLinkActie;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return InkWell(
      highlightColor: colors.grey5,
      onTap: isLinkActie ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 8,
          bottom: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: sSubtitle2Style.copyWith(
                    color: isLinkActie ? colors.blue : colors.black,
                  ),
                ),
                Text(
                  subTitle,
                  style: sBodyText2Style.copyWith(
                    color: colors.grey1,
                  ),
                ),
              ],
            ),
            if (isLinkActie) ...[
              const SBlueRightArrowIcon(),
            ] else ...[
              const SCompleteIcon(),
            ],
          ],
        ),
      ),
    );
  }
}
