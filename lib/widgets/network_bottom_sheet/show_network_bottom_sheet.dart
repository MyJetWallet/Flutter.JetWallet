import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';
import 'components/network_item.dart';

void showNetworkBottomSheet(
  BuildContext context,
  BlockchainModel currentNetwork,
  List<BlockchainModel> availableNetworks,
  String iconUrl,
  void Function(BlockchainModel) setNetwork,
) {
  sShowBasicModalBottomSheet(
    context: context,
    pinned: SBottomSheetHeader(
      name: intl.showNetworkBottomSheet_chooseNetwork,
    ),
    children: [
      for (final network in availableNetworks)
        NetworkItem(
          iconUrl: iconUrl,
          network: network.description,
          selected: network.id == currentNetwork.id,
          onTap: () {
            setNetwork(network);
            Navigator.of(context).pop();
          },
        ),
      const SpaceH42(),
    ],
  );
}
