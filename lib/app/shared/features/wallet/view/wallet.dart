import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import 'components/action_button.dart';
import 'components/wallets_body/wallets_body.dart';

class Wallet extends HookWidget {
  const Wallet({
    Key? key,
    required this.assetId,
  }) : super(key: key);

  final String assetId;

  static void push({
    required BuildContext context,
    required String assetId,
  }) {
    navigatorPush(
      context,
      Wallet(
        assetId: assetId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      header: const SPaddingH24(
        child: SSmallHeader(
          title: 'My Wallets',
        ),
      ),
      bottomNavigationBar: const ActionButton(),
      child: Wallets(
        assetId: assetId,
      ),
    );
  }
}
