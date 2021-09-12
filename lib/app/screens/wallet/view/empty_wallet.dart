import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../router/view/components/app_frame.dart';
import 'components/action_block.dart';
import 'components/wallet_app_bar/empty_wallet_app_bar.dart';
import 'components/wallet_body/empty_wallet_body.dart';

class EmptyWallet extends HookWidget {
  const EmptyWallet({
    Key? key,
    required this.assetName,
  }) : super(key: key);

  final String assetName;

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      appBar: ZeroBalanceWalletAppBar(
        assetName: assetName,
      ),
      bottomNavigationBar: const ActionBlock(),
      child: EmptyWalletBody(
        assetName: assetName,
      ),
    );
  }
}
