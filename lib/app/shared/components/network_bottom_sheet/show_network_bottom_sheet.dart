import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/blockchains_model.dart';

import '../../../../shared/providers/service_providers.dart';
import 'components/network_item.dart';

void showNetworkBottomSheet(
  BuildContext context,
  BlockchainModel currentNetwork,
  List<BlockchainModel> availableNetworks,
  String iconUrl,
  void Function(BlockchainModel) setNetwork,
) {
  final intl = context.read(intlPod);

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
      const SpaceH7(),
    ],
  );
}
