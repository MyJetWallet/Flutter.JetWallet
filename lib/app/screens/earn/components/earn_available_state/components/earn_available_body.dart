import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../shared/features/earn/provider/earn_offers_pod.dart';
import '../../earn_items/earn_items.dart';

class EarnAvailableBody extends HookWidget {
  const EarnAvailableBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final intl = useProvider(intlPod);
    final earnOffers = useProvider(earnOffersPod);

    return Container(
      width: MediaQuery.of(context).size.width,
      transform: Matrix4.translationValues(0.0, -20.0, 0.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        color: colors.white,
      ),
      child: Column(
        children: [
          if (earnOffers.isNotEmpty) ...[
            SPaddingH24(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 11,
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
            const SDivider(),
            const EarnItems(
              isActiveEarn: false,
              emptyBalance: false,
            ),
            const SpaceH10(),
          ],
        ],
      ),
    );
  }
}
