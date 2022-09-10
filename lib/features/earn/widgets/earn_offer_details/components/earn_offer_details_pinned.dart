import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model.dart';

class EarnOfferDetailsPinned extends StatelessObserverWidget {
  const EarnOfferDetailsPinned({
    Key? key,
    required this.earnOffer,
  }) : super(key: key);

  final EarnOfferModel earnOffer;

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.getCurrencies;

    final currentCurrency = currencyFrom(currencies, earnOffer.asset);

    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: 26,
      ),
      child: Text(
        '${currentCurrency.description} ${earnOffer.offerTag == 'Hot' ? intl.earn_hot : intl.earn_flexible}',
        style: sTextH5Style,
      ),
    );
  }
}
