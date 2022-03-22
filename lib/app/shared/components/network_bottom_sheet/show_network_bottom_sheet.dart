import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../service/services/signal_r/model/blockchains_model.dart';
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
    pinned: const SBottomSheetHeader(
      name: 'Choose Network',
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
      const SpaceH7(),
    ],
  );
}
