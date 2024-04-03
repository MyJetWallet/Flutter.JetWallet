import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/prepaid_card/store/prepaid_card_promo_banner_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class PrepaidCardPromoBanner extends StatelessWidget {
  const PrepaidCardPromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => PrepaidCardPromoBannerStore(),
      child: const _PrepaidCardPromoBannerBody(),
    );
  }
}

class _PrepaidCardPromoBannerBody extends StatelessWidget {
  const _PrepaidCardPromoBannerBody();

  @override
  Widget build(BuildContext context) {
    final store = PrepaidCardPromoBannerStore.of(context);

    return Observer(
      builder: (context) {
        return store.isShowBanner
            ? SPromoBanner(
                onBannerTap: store.onBannerTap,
                onCloseBannerTap: store.onCloseBannerTap,
                title: intl.prepaid_card_prepaid_card,
                description: intl.prepaid_card_in_your_profile,
                promoImage: Image.asset(
                  prepaidCardBanner,
                  height: 68,
                ),
              )
            : const Offstage();
      },
    );
  }
}
