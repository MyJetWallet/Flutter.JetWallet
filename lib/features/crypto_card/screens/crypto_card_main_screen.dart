import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
      create: (context) => MainCryptoCardStore(),
      child: const _CryptoCardMainScreenBody(),
    );
  }
}

class _CryptoCardMainScreenBody extends StatelessWidget {
  const _CryptoCardMainScreenBody();

  @override
  Widget build(BuildContext context) {
    const cardLable = 'My card';
    return SPageFrame(
      loaderText: '',
      header: const GlobalBasicAppBar(
        title: 'Simple virtual card',
        subtitle: cardLable,
        hasLeftIcon: false,
        hasRightIcon: false,
      ),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            showCardSettingsBootomSheet(context);
          },
          child: const Text('Settings'),
        ),
      ),
    );
  }
}
