import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../shared/components/app_frame.dart';
import '../../../../screens/market/model/market_item_model.dart';
import 'components/action_button.dart';
import 'components/wallet_app_bar/wallet_app_bar.dart';
import 'components/wallets_body/wallets_body.dart';

class Wallet extends HookWidget {
  const Wallet({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      appBar: const WalletAppBar(),
      bottomNavigationBar: const ActionButton(),
      child: Wallets(
        assetId: marketItem.associateAsset,
      ),
    );
  }
}
