import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import 'components/wallets_body/empty_wallet_body.dart';

class EmptyWallet extends HookWidget {
  const EmptyWallet({
    Key? key,
    required this.assetName,
  }) : super(key: key);

  final String assetName;

  static void push({
    required BuildContext context,
    required String assetName,
  }) {
    navigatorPush(
      context,
      EmptyWallet(
        assetName: assetName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrameWithPadding(
      header: SSmallHeader(
        title: '$assetName wallet',
      ),
      // bottomNavigationBar: const ActionButton(),
      child: EmptyWalletBody(
        assetName: assetName,
      ),
    );
  }
}
