import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:simple_kit/simple_kit.dart';

class BottomNavigationMenu extends StatefulObserverWidget {
  const BottomNavigationMenu({
    Key? key,
    required this.hideAccount,
    required this.showCard,
    required this.currentIndex,
    required this.onChanged,
  }) : super(key: key);

  final int currentIndex;
  final Function(int) onChanged;
  final bool hideAccount;
  final bool showCard;

  @override
  State<BottomNavigationMenu> createState() => _BottomNavigationMenuState();
}

class _BottomNavigationMenuState extends State<BottomNavigationMenu>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SBottomNavigationBar(
      //cardNotifications: bottomMenuNotifier.cardNotification,
      cardNotifications: false,
      selectedIndex: widget.currentIndex,
      onChanged: widget.onChanged,
      hideAccount: widget.hideAccount,
      myAssetsText: intl.bottom_bar_my_assets,
      marketText: intl.bottom_bar_market,
      accountText: intl.bottom_bar_account,
      cardText: intl.bottom_bar_card,
      showCard: widget.showCard,
    );
  }
}
