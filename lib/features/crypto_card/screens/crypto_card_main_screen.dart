import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/crypto_card/screens/widgets/crypto_card_action_buttons.dart';
import 'package:jetwallet/features/crypto_card/screens/widgets/crypto_card_amount_widget.dart';
import 'package:jetwallet/features/crypto_card/screens/widgets/crypto_card_transactions.dart';
import 'package:jetwallet/features/crypto_card/screens/widgets/crypto_card_widget.dart';
import 'package:jetwallet/features/crypto_card/store/main_crypto_card_store.dart';
import 'package:jetwallet/features/crypto_card/utils/show_card_settings_bootom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'CryptoCardMainRoute')
class CryptoCardMainScreen extends StatelessWidget {
  const CryptoCardMainScreen({super.key});

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
    return Observer(
      builder: (context) {
        final card = sSignalRModules.cryptoCardProfile.cards.first;

        return SPageFrame(
          loaderText: '',
          header: GlobalBasicAppBar(
            title: 'Simple virtual card',
            subtitle: card.label,
            hasLeftIcon: false,
            hasRightIcon: false,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CryptoCardWidget(
                  last4: card.last4,
                  sensitiveInfo: Provider.of<MainCryptoCardStore>(context).sensitiveInfo,
                ),
                const CryptoCardAmountWidget(),
                const CryptoCardActionButtons(),
                const CryptoCardTransactions(),
              ],
            ),
          ),
        );
      },
    );
  }
}
