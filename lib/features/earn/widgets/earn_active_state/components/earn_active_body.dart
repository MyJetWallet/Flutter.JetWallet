import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/crypto_deposit/widgets/expansion_panel_without_icon.dart';
import 'package:jetwallet/features/earn/store/earn_offers_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model.dart';
import '../../earn_items/earn_items.dart';
import 'earn_active_accordion.dart';

class EarnActiveBody extends StatefulObserverWidget {
  const EarnActiveBody({
    super.key,
  });

  @override
  State<EarnActiveBody> createState() => _EarnActiveBodyState();
}

class _EarnActiveBodyState extends State<EarnActiveBody> {
  bool isActiveOpen = true;
  bool isAvailableOpen = true;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final earnOffers = EarnOffersStore.of(context).earnOffersFiltred;
    List<EarnOfferModel> filteredOffers = earnOffers;

    filteredOffers = filteredOffers
        .where(
          (element) => element.amount == Decimal.zero,
        )
        .toList();

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
                      isOpen: isActiveOpen,
                      isActive: true,
                      onTap: () {
                        setState(() {
                          isActiveOpen = !isActiveOpen;
                        });
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
                  isExpanded: isActiveOpen,
                ),
                ExpansionPanelWithoutIcon(
                  canTapOnHeader: true,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return EarnActiveAccordion(
                      name: intl.earn_available_subscription,
                      isOpen: isAvailableOpen,
                      isActive: false,
                      onTap: () {
                        setState(() {
                          isAvailableOpen = !isAvailableOpen;
                        });
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
                  isExpanded: isAvailableOpen,
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
