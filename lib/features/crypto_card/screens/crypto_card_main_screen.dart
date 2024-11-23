import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/features/crypto_card/store/main_crypto_card_store.dart';
import 'package:jetwallet/features/crypto_card/widgets/crypto_card_action_buttons.dart';
import 'package:jetwallet/features/crypto_card/widgets/crypto_card_add_to_wallet_banner.dart';
import 'package:jetwallet/features/crypto_card/widgets/crypto_card_amount_widget.dart';
import 'package:jetwallet/features/crypto_card/widgets/crypto_card_transactions.dart';
import 'package:jetwallet/features/crypto_card/widgets/crypto_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/crypto_card_message_model.dart';

@RoutePage(name: 'CryptoCardMainRoute')
class CryptoCardMainScreen extends StatelessWidget {
  const CryptoCardMainScreen({
    required this.cryptoCard,
    super.key,
  });

  final CryptoCardModel cryptoCard;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => MainCryptoCardStore()..init(),
      child: _CryptoCardMainScreenBody(
        cryptoCard: cryptoCard,
      ),
    );
  }
}

class _CryptoCardMainScreenBody extends StatelessWidget {
  const _CryptoCardMainScreenBody({
    required this.cryptoCard,
  });

  final CryptoCardModel cryptoCard;

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: '',
      header: GlobalBasicAppBar(
        title: 'Simple virtual card',
        subtitle: cryptoCard.label,
        hasLeftIcon: false,
        hasRightIcon: false,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CryptoCardWidget(
              last4: cryptoCard.last4,
              sensitiveInfo: Provider.of<MainCryptoCardStore>(context).sensitiveInfo,
            ),
            const CryptoCardAmountWidget(),
            const CryptoCardActionButtons(),
            const CryptoCardAddToWalletBanner(),
            const CryptoCardTransactions(),
          ],
        ),
      ),
    );
  }
}
