import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../shared/features/crypto_deposit/view/components/crypto_deposit_with_address_and_tag/components/expansion_panel_without_icon.dart';
import '../../../../../shared/features/earn/provider/earn_offers_pod.dart';
import '../../earn_items/earn_items.dart';
import 'earn_active_accordion.dart';

class EarnActiveBody extends HookWidget {
  const EarnActiveBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final intl = useProvider(intlPod);
    final earnOffers = useProvider(earnOffersPod);
    var filteredOffers = earnOffers;


    filteredOffers = filteredOffers.where(
          (element) => element.amount == Decimal.zero,
    ).toList();

    final isActiveOpen = useState(true);
    final isAvailableOpen = useState(true);

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
      child: Theme(
        data: Theme.of(context).copyWith(cardColor: Colors.transparent),
        child: Column(
          children: [
            ExpansionPanelListWithoutIcon(
              elevation: 0,
              expandedHeaderPadding: EdgeInsets.zero,
              children: [
                ExpansionPanelWithoutIcon(
                  canTapOnHeader: true,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return EarnActiveAccordion(
                      name: intl.earn_active_subscription,
                      isOpen: isActiveOpen.value,
                      isActive: true,
                      onTap: () {
                        isActiveOpen.value = !isActiveOpen.value;
                      },
                    );
                  },
                  body: Column(
                    children: const [
                      EarnItems(
                        isActiveEarn: true,
                        emptyBalance: false,
                      ),
                      SpaceH10(),
                    ],
                  ),
                  isExpanded: isActiveOpen.value,
                ),
                ExpansionPanelWithoutIcon(
                  canTapOnHeader: true,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return EarnActiveAccordion(
                      name: intl.earn_available_subscription,
                      isOpen: isAvailableOpen.value,
                      isActive: false,
                      onTap: () {
                        isAvailableOpen.value = !isAvailableOpen.value;
                      },
                    );
                  },
                  body: Column(
                    children: [
                      if (filteredOffers.isNotEmpty) ...[
                        const SPaddingH24(child: SDivider()),
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
                  isExpanded: isAvailableOpen.value,
                ),
              ],
            ),
            const SDivider(),
            const SpaceH40(),
          ],
        ),
      ),
    );
  }
}
