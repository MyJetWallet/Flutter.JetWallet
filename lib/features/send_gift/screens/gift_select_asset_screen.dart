import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/l10n/i10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../utils/models/currency_model.dart';

@RoutePage(name: 'GiftSelectAssetRouter')
class GiftSelectAssetScreen extends StatelessWidget {
  GiftSelectAssetScreen({super.key, required this.assets});

  final List<CurrencyModel> assets;

  final baseCurrency = sSignalRModules.baseCurrency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  child: SSmallHeader(
                    title: 'Sending asset',
                  ),
                ),
                //TODO check if (assets.length >7)
                if (true) ...[
                  SPaddingH24(
                    child: SStandardField(
                      controller: TextEditingController(),
                      labelText: intl.actionBottomSheetHeader_search,
                      onChanged: (String value) {},
                    ),
                  ),
                  const SDivider(),
                ],
                for (final currency in assets) ...[
                  SWalletItem(
                    decline: currency.dayPercentChange.isNegative,
                    icon: SNetworkSvg24(
                      url: currency.iconUrl,
                    ),
                    primaryText: currency.description,
                    amount: currency.volumeBaseBalance(baseCurrency),
                    secondaryText: currency.volumeAssetBalance,
                    removeDivider: currency == assets.last,
                    onTap: () {
                      sRouter.push(
                        const GiftReceiversDetailsRouter(),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
