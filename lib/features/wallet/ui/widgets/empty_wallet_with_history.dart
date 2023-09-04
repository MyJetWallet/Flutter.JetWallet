import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/wallet_body.dart';
import 'package:jetwallet/utils/models/currency_model.dart';

class EmptyWalletWithHistory extends StatelessObserverWidget {
  const EmptyWalletWithHistory({
    super.key,
    required this.currency,
  });

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return WalletBody(
          key: Key(currency.symbol),
          currency: currency,
        );
      },
    );
  }
}
