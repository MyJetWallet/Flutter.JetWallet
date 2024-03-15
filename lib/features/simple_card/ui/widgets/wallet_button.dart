import 'dart:convert';
import 'dart:io';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/simple_show_alert_popup.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class WalletsButton extends StatefulWidget {
  const WalletsButton({
    required this.cardNumber,
    required this.cardId,
    super.key,
  });
  final String cardNumber;
  final String cardId;

  @override
  State<WalletsButton> createState() => _WalletsButtonState();
}

class _WalletsButtonState extends State<WalletsButton> {
  late List<String> walletIdsButtonsChecked;

  @override
  void initState() {
    super.initState();
    _getStoredCardIds();
  }

  Future<void> _getStoredCardIds() async {
    final storedIds = await sLocalStorageService.getValue(walletIdsButtonsCheckedKey);
    if (storedIds != null) {
      final decodedIds = jsonDecode(storedIds);
      setState(() {
        walletIdsButtonsChecked = List<String>.from(decodedIds);
      });
    } else {
      walletIdsButtonsChecked = [];
    }
  }

  Future<void> _storeCardId(String cardId) async {
    walletIdsButtonsChecked.add(cardId);
    final encodedIds = jsonEncode(walletIdsButtonsChecked);
    await sLocalStorageService.setString(walletIdsButtonsCheckedKey, encodedIds);
  }

  @override
  Widget build(BuildContext context) {
    final isCardIdStored = walletIdsButtonsChecked.contains(widget.cardId);
    if (isCardIdStored) {
      return const SizedBox.shrink();
    }

    final isIos = Platform.isIOS;

    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: 32,
      ),
      child: SButton.black(
        icon: Image.asset(isIos ? 'assets/images/wallet_apple.png' : 'assets/images/wallet_google.png'),
        callback: () {
          // Store the cardId and update the list
          _storeCardId(widget.cardId);
          // Rest of your button callback logic...
        },
        text: intl.wallets_add_to_wallet(
          isIos ? intl.wallets_add_to_apple_wallet : intl.wallets_add_to_google_wallet,
        ),
      ),
    );
  }
}

void onCopyAction(String value) {
  Clipboard.setData(
    ClipboardData(
      text: value.replaceAll(' ', ''),
    ),
  );
}
