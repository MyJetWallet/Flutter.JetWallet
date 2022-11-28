import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class EarnSubscriptionPinned extends StatelessObserverWidget {
  const EarnSubscriptionPinned({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 18,
            bottom: 20,
          ),
          child: RichText(
            text: TextSpan(
              text: '${intl.earn_select} $name ${intl.earn_subscription}',
              style: sTextH4Style.copyWith(
                color: colors.black,
              ),
            ),
          ),
        ),
        SPaddingH24(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  intl.earn_asset,
                  style: sCaptionTextStyle.copyWith(
                    color: colors.grey2,
                  ),
                ),
                Text(
                  intl.earn_apy,
                  style: sCaptionTextStyle.copyWith(
                    color: colors.grey2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
