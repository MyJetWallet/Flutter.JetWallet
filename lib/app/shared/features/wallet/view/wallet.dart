import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../shared/components/app_frame.dart';
import 'components/action_button.dart';
import 'components/wallet_app_bar/wallet_app_bar.dart';
import 'components/wallets_body/wallets_body.dart';

class Wallet extends HookWidget {
  const Wallet({
    Key? key,
    required this.assetId,
  }) : super(key: key);

  final String assetId;

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      appBar: const WalletAppBar(),
      bottomNavigationBar: const ActionButton(),
      child: Wallets(
        assetId: assetId,
      ),
    );
  }
}
