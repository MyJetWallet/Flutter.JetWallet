import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/earn/store/earn_offers_store.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/show_start_earn_options.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'earn_page_bottom_sheet/earn_page_bottom_sheet.dart';

class EarnHeader extends StatelessObserverWidget {
  const EarnHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = EarnOffersStore.of(context).earnOffers;

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
                style: store.isNotEmpty ? sTextH5Style : sTextH2Style,
              ),
              SIconButton(
                onTap: () {
                  showStartEarnPageBottomSheet(
                    context: context,
                    onTap: (CurrencyModel currency) {
                      sRouter.pop();

                      showStartEarnOptions(
                        currency: currency,
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
        if (store.isEmpty) const SDivider(),
      ],
    );
  }
}
