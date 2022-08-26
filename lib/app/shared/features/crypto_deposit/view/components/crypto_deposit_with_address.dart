import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/device_size/media_query_pod.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../helpers/short_address_form.dart';
import '../../../../models/currency_model.dart';
import '../../notifier/crypto_deposit_notipod.dart';
import '../../notifier/crypto_deposit_union.dart';

// Header, ShareButton bar, DepositInfo, NetworkSelector
const screenWidgets = 120 + 104 + 88 + 88;
const sAddressFieldWithCopyHeight = 88;

class CryptoDepositWithAddress extends HookWidget {
  const CryptoDepositWithAddress({
    Key? key,
    required this.currency,
    this.showAlert = false,
    this.alert,
  }) : super(key: key);

  final CurrencyModel currency;
  final bool showAlert;
  final Widget? alert;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final deposit = useProvider(cryptoDepositNotipod(currency));
    final mediaQuery = useProvider(mediaQueryPod);
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
            showAlert: showAlert,
            alert: alert,
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
