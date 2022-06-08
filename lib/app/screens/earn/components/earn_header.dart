import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/providers/service_providers.dart';
import '../../../shared/components/show_start_earn_options.dart';
import '../../../shared/features/earn/provider/earn_offers_pod.dart';
import '../../../shared/models/currency_model.dart';
import 'earn_page_bottom_sheet/earn_page_bottom_sheet.dart';

class EarnHeader extends HookWidget {
  const EarnHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final earnOffers = useProvider(earnOffersPod);
    final intl = useProvider(intlPod);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 60,
            bottom: 19,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                intl.earn_title,
                style: earnOffers.isNotEmpty ? sTextH5Style : sTextH2Style,
              ),
              SIconButton(
                onTap: () {
                  showStartEarnPageBottomSheet(
                    context: context,
                    onTap: (CurrencyModel currency) {
                      Navigator.pop(context);

                      showStartEarnOptions(
                        currency: currency,
                        read: context.read,
                      );
                    },
                  );
                },
                defaultIcon: const SInfoIcon(),
                pressedIcon: const SInfoPressedIcon(),
              ),
            ],
          ),
        ),
        if (earnOffers.isEmpty) const SDivider(),
      ],
    );
  }
}
