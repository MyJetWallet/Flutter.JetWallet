import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/earn/store/earn_offers_store.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../earn_items/earn_items.dart';

class EarnAvailableBody extends StatelessObserverWidget {
  const EarnAvailableBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final earnOffers = EarnOffersStore.of(context).earnOffers;

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
