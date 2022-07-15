import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/kyc/models/kyc_verified_model.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:jetwallet/utils/helpers/localized_action_items.dart';
import 'package:simple_kit/simple_kit.dart';

class BottomNavigationMenu extends StatefulObserverWidget {
  const BottomNavigationMenu({
    Key? key,
    required this.transitionAnimationController,
    required this.currentIndex,
    required this.onChanged,
  }) : super(key: key);

  final AnimationController transitionAnimationController;
  final int currentIndex;
  final Function(int) onChanged;

  @override
  State<BottomNavigationMenu> createState() => _BottomNavigationMenuState();
}

class _BottomNavigationMenuState extends State<BottomNavigationMenu>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    void updateActionState() {
      getIt.get<AppStore>().setActionMenuActive(
            !getIt.get<AppStore>().actionMenuActive,
          );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (getIt.get<AppStore>().openBottomMenu) {
        _openBottomMenu(
          context,
          updateActionState,
        );
        updateActionState();

        getIt.get<AppStore>().setOpenBottomMenu(false);
      }
    });

    return SBottomNavigationBar(
      profileNotifications: _profileNotificationLength(
        KycModel(),
        true,
      ),
      selectedIndex: widget.currentIndex,
      actionActive: getIt.get<AppStore>().actionMenuActive,
      earnEnabled: false,
      animationController: widget.transitionAnimationController,
      onActionTap: () {
        _openBottomMenu(
          context,
          updateActionState,
        );
        updateActionState();
      },
      onChanged: widget.onChanged,
    );
  }

  // ignore: long-parameter-list
  void _openBottomMenu(
    BuildContext context,
    Function() updateActionState,
  ) {
    if (!getIt.get<AppStore>().actionMenuActive) {
      sShowMenuActionSheet(
        context: context,
        isNotEmptyBalance: true,
        onBuy: () {},
        onBuyFromCard: () {},
        onSell: () {},
        onConvert: () {},
        onDeposit: () {},
        onWithdraw: () {},
        onSend: () {},
        onReceive: () {},
        onDissmis: updateActionState,
        whenComplete: () {
          if (getIt.get<AppStore>().actionMenuActive) updateActionState();
        },
        transitionAnimationController: widget.transitionAnimationController,
        actionItemLocalized: localizedActionItems(context),
      );
    } else {
      Navigator.pop(context);
    }
  }

  int _profileNotificationLength(KycModel kycState, bool twoFaEnable) {
    var notificationLength = 0;

    final passed = checkKycPassed(
      kycState.depositStatus,
      kycState.sellStatus,
      kycState.withdrawalStatus,
    );

    if (!passed) {
      notificationLength += 1;
    }

    if (!twoFaEnable) {
      notificationLength += 1;
    }

    return notificationLength;
  }
}
