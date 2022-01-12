import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../../models/currency_model.dart';
import '../provider/current_asset_pod.dart';
import 'components/action_button/action_button.dart';
import 'components/wallet_body/empty_wallet_body.dart';

class EmptyWallet extends StatefulHookWidget {
  const EmptyWallet({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  static void push({
    required BuildContext context,
    required CurrencyModel currency,
  }) {
    navigatorPush(
      context,
      EmptyWallet(
        currency: currency,
      ),
    );
  }

  @override
  State<EmptyWallet> createState() => _EmptyWalletState();
}

class _EmptyWalletState extends State<EmptyWallet>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    // animationController intentionally is not disposed,
    // because bottomSheet will dispose it on its own
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentAsset = useProvider(
      currentAssetStpod(widget.currency.assetId),
    );
    useListenable(animationController);

    return Scaffold(
      bottomNavigationBar: ActionButton(
        transitionAnimationController: animationController,
        currency: currentAsset.state,
      ),
      body: SShadeAnimationStack(
        controller: animationController,
        child: SPageFrameWithPadding(
          header: SSmallHeader(
            title: '${widget.currency.description} wallet',
          ),
          child: EmptyWalletBody(
            assetName: widget.currency.description,
          ),
        ),
      ),
    );
  }
}
