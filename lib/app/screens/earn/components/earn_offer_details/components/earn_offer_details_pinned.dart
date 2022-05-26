import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/earn_offers_model.dart';

import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../shared/features/market_details/helper/currency_from.dart';
import '../../../../../shared/providers/currencies_pod/currencies_pod.dart';

class EarnOfferDetailsPinned extends HookWidget {
  const EarnOfferDetailsPinned({
    Key? key,
    required this.earnOffer,
  }) : super(key: key);

  final EarnOfferModel earnOffer;

  @override
  Widget build(BuildContext context) {
    final currencies = useProvider(currenciesPod);

    final currentCurrency = currencyFrom(currencies, earnOffer.asset);
    final intl = useProvider(intlPod);

    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: 26,
      ),
      child: Text(
        '${currentCurrency.description} ${earnOffer.offerTag == 'Hot'
            ? intl.earn_hot
            : intl.earn_flexible}',
        style: sTextH5Style,
      ),
    );
  }
}
