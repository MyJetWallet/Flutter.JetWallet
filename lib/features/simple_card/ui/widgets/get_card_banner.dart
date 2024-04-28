import 'package:flutter/material.dart';
import 'package:jetwallet/features/simple_card/ui/widgets/card_options.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../../../core/di/di.dart';
import '../../../../core/l10n/i10n.dart';
import '../../store/simple_card_store.dart';

class GetCardBanner extends StatelessWidget {
  const GetCardBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final simpleCardStore = getIt.get<SimpleCardStore>();

    return SPromoBanner(
      onBannerTap: () {
        sAnalytics.tapOnGetSimpleCard(source: 'main screen');
        showCardOptions(context);
      },
      onCloseBannerTap: () {
        simpleCardStore.closeBanner();
      },
      title: intl.simple_card_get_card_now,
      promoImage: Image.asset(
        simpleCardBannerAsset,
        height: 68,
      ),
    );
  }
}
