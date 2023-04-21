import 'package:flutter/material.dart';

import '../../base/simple_base_svg_24x24.dart';

class SimpleLightWalletIcon extends StatelessWidget {
  const SimpleLightWalletIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName: 'assets/icons/light/24x24/wallet/wallet.svg',
      color: color,
    );
  }
}

class SimpleLightWallet2Icon extends StatelessWidget {
  const SimpleLightWallet2Icon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName: 'assets/icons/light/24x24/wallet/wallet_2.svg',
      color: color,
    );
  }
}
