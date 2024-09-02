import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';
import 'components/network_item.dart';

void showNetworkBottomSheet(
  BuildContext context,
  BlockchainModel currentNetwork,
  List<BlockchainModel> availableNetworks,
  String iconUrl,
  String asset,
  void Function(BlockchainModel) setNetwork, {
  bool backOnClose = true,
  bool isReceive = false,
}) {
  print('#@#@#@ ${availableNetworks}');
  var isClosed = false;

  void checkOrClose(val) {
    if (!backOnClose) return;
    if (isClosed) return;
    if (val is bool && !val) {
      sRouter.maybePop();
      isClosed = true;

      return;
    }

    if (val == null) {
      sRouter.maybePop();
      isClosed = true;

      return;
    }
  }

  isReceive
      ? sAnalytics.chooseNetworkPopupView(asset: asset)
      : sAnalytics.cryptoSendChooseNetworkScreenView(
          asset: asset,
          sendMethodType: '0',
        );

  sShowBasicModalBottomSheet(
    context: context,
    pinned: SBottomSheetHeader(
      name: intl.showNetworkBottomSheet_chooseNetwork,
    ),
    isDismissible: false,
    then: (p0) => checkOrClose(p0),
    children: [
      for (final network in availableNetworks)
        NetworkItem(
          iconUrl: iconUrl,
          network: network.description,
          selected: network.id == currentNetwork.id,
          onTap: () {
            setNetwork(network);
            Navigator.of(context).pop(true);
          },
        ),
      const SpaceH42(),
    ],
  );
}
