import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/anchors/anchors_helper.dart';
import 'package:jetwallet/features/crypto_deposit/model/crypto_deposit_union.dart';
import 'package:jetwallet/features/crypto_deposit/store/crypto_deposit_store.dart';
import 'package:jetwallet/features/crypto_deposit/widgets/simple_qr_code_box.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';

import '../../../core/services/notification_service.dart';

// Header, ShareButton bar, DepositInfo, NetworkSelector
const screenWidgets = 120 + 122 + 88 + 68;
const sAddressFieldWithCopyHeight = 146;

class CryptoDepositWithAddress extends StatelessObserverWidget {
  const CryptoDepositWithAddress({
    super.key,
    required this.currency,
  });

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final deposit = CryptoDepositStore.of(context);

    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final qrCodeSize = screenWidth * 0.6;

    final extraScrollArea = screenHeight - qrCodeSize - screenWidgets - sAddressFieldWithCopyHeight;

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
          SCopyable(
            label: '${currency.symbol}'
                ' ${intl.cryptoDepositWithAddress_walletAddress}',
            value: deposit.address,
            onIconTap: () {
              Clipboard.setData(
                ClipboardData(
                  text: deposit.address,
                ),
              );
              sAnalytics.tapOnTheButtonCopyOnReceiveAssetScreen(
                asset: deposit.currency.symbol,
                network: deposit.network.description,
              );

              unawaited(AnchorsHelper().addCryptoDepositAnchor(deposit.currency.symbol));

              sNotification.showError(intl.copy_message, id: 1, isError: false);
            },
          ),
        ],
      ),
    );
  }
}
