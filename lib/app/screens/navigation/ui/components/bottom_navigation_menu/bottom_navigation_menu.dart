import 'package:flutter/material.dart';

import 'bottom_navigation_item.dart';

class BottomNavigationMenu extends StatelessWidget {
  const BottomNavigationMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      color: Colors.white,
      child: Row(
        children: const [
          BottomNavigationItem(
            index: 0,
            icon: Icons.account_balance_wallet,
          ),
          BottomNavigationItem(
            index: 1,
            icon: Icons.portrait,
          ),
        ],
      ),
    );
  }
}
