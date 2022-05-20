import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/features/earn/provider/earn_offers_pod.dart';

class EarnActiveAccordion extends HookWidget {
  const EarnActiveAccordion({
    Key? key,
    required this.name,
    required this.isOpen,
    required this.onTap,
    required this.isActive,
  }) : super(key: key);

  final String name;
  final bool isOpen;
  final bool isActive;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final earnOffers = useProvider(earnOffersPod);
    final filteredActiveOffers = earnOffers.where(
      (element) => element.amount > Decimal.zero,
    ).toList();
    final filteredAvailableOffers = earnOffers.where(
      (element) => element.amount == Decimal.zero,
    ).toList();
    final listOfAssetsByEarns = <String>[];

    for (final element in filteredAvailableOffers) {
      if (!listOfAssetsByEarns.contains(element.asset)) {
        listOfAssetsByEarns.add(element.asset);
      }
    }

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
    );

    final actionIcon = isOpen
        ? const SAngleDownIcon()
        : const SAngleUpIcon();

    useListenable(animationController);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            color: colors.white,
          ),
          child: SPaddingH24(
            child: SizedBox(
              height: 64.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: sSubtitle2Style.copyWith(
                      color: colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 25,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: colors.grey4,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              bottom: 2,
                            ),
                            child: Text(
                              '${isActive
                                  ? filteredActiveOffers.length
                                  : listOfAssetsByEarns.length
                              }',
                              style: sSubtitle3Style,
                            ),
                          ),
                        ),
                      ),
                      SIconButton(
                        onTap: onTap,
                        defaultIcon: actionIcon,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
