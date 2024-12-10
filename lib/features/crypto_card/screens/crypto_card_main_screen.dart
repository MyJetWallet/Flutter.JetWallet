import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/crypto_card/store/main_crypto_card_store.dart';
import 'package:jetwallet/features/crypto_card/widgets/crypto_card_action_buttons.dart';
import 'package:jetwallet/features/crypto_card/widgets/crypto_card_add_to_wallet_banner.dart';
import 'package:jetwallet/features/crypto_card/widgets/crypto_card_amount_widget.dart';
import 'package:jetwallet/features/crypto_card/widgets/crypto_card_transactions.dart';
import 'package:jetwallet/features/crypto_card/widgets/crypto_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/crypto_card_message_model.dart';

@RoutePage(name: 'CryptoCardMainRoute')
class CryptoCardMainScreen extends StatefulWidget {
  const CryptoCardMainScreen({
    required this.cryptoCard,
    super.key,
  });

  final CryptoCardModel cryptoCard;

  @override
  State<CryptoCardMainScreen> createState() => _CryptoCardMainScreenState();
}

class _CryptoCardMainScreenState extends State<CryptoCardMainScreen> {
  @override
  void initState() {
    super.initState();
    sAnalytics.viewMainCardScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => MainCryptoCardStore()..init(),
      child: const _CryptoCardMainScreenBody(),
    );
  }
}

class _CryptoCardMainScreenBody extends StatelessWidget {
  const _CryptoCardMainScreenBody();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainCryptoCardStore>(context);

    return Observer(
      builder: (context) {
        final cryptoCard = store.cryptoCard;
        final cardIsFrozen = cryptoCard.status == CryptoCardStatus.frozen;

        return SPageFrame(
          loaderText: intl.register_pleaseWait,
          header: GlobalBasicAppBar(
            title: intl.crypto_card_main_title,
            subtitle: cryptoCard.label,
            hasLeftIcon: false,
            hasRightIcon: false,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CryptoCardWidget(
                  isFrozen: cardIsFrozen,
                  last4: cryptoCard.last4,
                ),
                const CryptoCardAmountWidget(),
                CryptoCardActionButtons(
                  store: store,
                  cardIsFrozen: cardIsFrozen,
                ),
                const CryptoCardAddToWalletBanner(),
                const CryptoCardTransactions(),
              ],
            ),
          ),
        );
      },
    );
  }
}
