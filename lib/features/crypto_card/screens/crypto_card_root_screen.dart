import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/features/crypto_card/screens/crypto_card_main_screen.dart';
import 'package:jetwallet/features/crypto_card/screens/get_crypto_card_screen.dart';

// TODO (Yaroslav): replase this to real value
bool isCryptoCardCreated = false;

@RoutePage(name: 'CryptoCardRootRoute')
class CryptoCardRootScreen extends StatelessWidget {
  const CryptoCardRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return isCryptoCardCreated ? const CryptoCardMainScreen() : const GetCryptoCardScreen();
  }
}
