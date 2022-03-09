import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../features/crypto_deposit/view/components/network_item.dart';

void showNetworkBottomSheet(
    BuildContext context,
    String currentNetwork,
    List<String> availableNetworks,
    String iconUrl,
    void Function(String) setNetwork,
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
          network: network,
          selected: network == currentNetwork,
          onTap: () {
            setNetwork(network);
            Navigator.of(context).pop();
          },
        ),
      const SpaceH7(),
    ],
  );
}