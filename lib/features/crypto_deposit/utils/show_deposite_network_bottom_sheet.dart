import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/crypto_deposit/widgets/network_item.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';

void showDepositeNetworkBottomSheet(
  BuildContext context,
  BlockchainModel currentNetwork,
  List<BlockchainModel> availableNetworks,
  String iconUrl,
  String asset,
  void Function(BlockchainModel) setNetwork, {
  bool backOnClose = true,
  bool isReceive = false,
}) {
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

  showBasicBottomSheet(
    context: context,
    header: BasicBottomSheetHeaderWidget(
      title: intl.showNetworkBottomSheet_chooseNetwork,
    ),
    isDismissible: false,
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
  ).then((p0) => checkOrClose(p0));
}
