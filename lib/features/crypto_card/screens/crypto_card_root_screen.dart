import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/crypto_card/screens/creating_crypto_card_screen.dart';
import 'package:jetwallet/features/crypto_card/screens/crypto_card_main_screen.dart';
import 'package:jetwallet/features/crypto_card/screens/get_crypto_card_screen.dart';
import 'package:simple_networking/modules/signal_r/models/crypto_card_message_model.dart';

@RoutePage(name: 'CryptoCardRootRoute')
class CryptoCardRootScreen extends StatelessWidget {
  const CryptoCardRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final cryptoCardProfile = sSignalRModules.cryptoCardProfile;
        final cryptoCard = cryptoCardProfile.cards.firstOrNull;

        return cryptoCardProfile.cards.isEmpty
            ? const GetCryptoCardScreen()
            : cryptoCard?.status == CryptoCardStatus.inCreation
                ? const CreatingCryptoCardScreen()
                : CryptoCardMainScreen(cryptoCard: cryptoCard!);
      },
    );
  }
}
