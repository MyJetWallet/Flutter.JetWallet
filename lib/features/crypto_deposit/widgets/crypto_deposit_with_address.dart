import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/crypto_deposit/model/crypto_deposit_union.dart';
import 'package:jetwallet/features/crypto_deposit/store/crypto_deposit_store.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

// Header, ShareButton bar, DepositInfo, NetworkSelector
const screenWidgets = 120 + 104 + 88 + 88;
const sAddressFieldWithCopyHeight = 88;

class CryptoDepositWithAddress extends StatelessObserverWidget {
  const CryptoDepositWithAddress({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final deposit = CryptoDepositStore.of(context);

    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final qrCodeSize = screenWidth * 0.6;

    final extraScrollArea =
        screenHeight - qrCodeSize - screenWidgets - sAddressFieldWithCopyHeight;

    final widgetHeight = extraScrollArea.isNegative
        ? screenHeight - screenWidgets + extraScrollArea.abs()
        : screenHeight - screenWidgets;

    return SizedBox(
      height: widgetHeight,
      child: Column(
        children: [
          const Spacer(),
          SQrCodeBox(
            loading: deposit.union is Loading,
            data: deposit.address,
            qrBoxSize: qrCodeSize,
            logoSize: screenWidth * 0.2,
          ),
          const Spacer(),
          SAddressFieldWithCopy(
            header: '${currency.symbol}'
                ' ${intl.cryptoDepositWithAddress_walletAddress}',
            value: shortAddressForm(deposit.address),
            realValue: deposit.address,
            afterCopyText: intl.cryptoDepositWithAddress_addressCopied,
            valueLoading: deposit.union is Loading,
            then: () {
              sAnalytics.receiveCopy(asset: currency.description);
            },
          ),
        ],
      ),
    );
  }
}
