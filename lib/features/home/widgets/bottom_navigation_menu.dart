import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';

import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

class BottomNavigationMenu extends StatefulObserverWidget {
  const BottomNavigationMenu({
    super.key,
    required this.showCard,
    required this.isCardRequested,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final Function(int) onChanged;
  final bool showCard;
  final bool isCardRequested;

  @override
  State<BottomNavigationMenu> createState() => _BottomNavigationMenuState();
}

class _BottomNavigationMenuState extends State<BottomNavigationMenu> {
  @override
  Widget build(BuildContext context) {
    return SBottomNavigationBar(
      //cardNotifications: bottomMenuNotifier.cardNotification,
      cardNotifications: false,
      selectedIndex: widget.currentIndex,
      onChanged: widget.onChanged,
      walletsText: intl.bottom_bar_wallets,
      marketText: intl.bottom_bar_market,
      accountText: intl.bottom_bar_account,
      cardText: intl.bottom_bar_card,
      rewardText: intl.rewards_flow_tab_title,
      showCard: widget.showCard,
      isCardRequested: widget.isCardRequested,
      rewardCount: sSignalRModules.rewardsData?.availableSpins ?? 0,
      showReward: (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[])
          .where((element) => element.id == AssetPaymentProductsEnum.rewardsOnboardingProgram)
          .isNotEmpty,
      investText: intl.bottom_bar_invest,
      showInvest: true,
    );
  }
}
