import 'package:flutter/material.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/utils/models/currency_model.dart';

void navigateToWallet(BuildContext context, CurrencyModel currency) {
  sRouter
      .push(
    WalletRouter(
      currency: currency,
    ),
  );
}
