import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../simple_kit.dart';

class SimpleMenuActionSheetExample extends StatefulHookWidget {
  const SimpleMenuActionSheetExample({Key? key}) : super(key: key);

  static const routeName = '/simple_menu_action_sheet_example';

  @override
  State<SimpleMenuActionSheetExample> createState() =>
      _SimpleMenuActionSheetExampleState();
}

class _SimpleMenuActionSheetExampleState
    extends State<SimpleMenuActionSheetExample>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    // animationController intentionally is not disposed,
    // because bottomSheet will dispose it on its own
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    useListenable(animationController);

    return Scaffold(
      body: SShadeAnimationStack(
        controller: animationController,
        child: const SizedBox(
          height: 200,
          width: 100,
          child: Center(
            child: Text('Example Text'),
          ),
        ),
      ),
      bottomNavigationBar: _CustomBottomNavigationBar(
        transitionAnimationController: animationController,
      ),
    );
  }
}

class _CustomBottomNavigationBar extends HookWidget {
  const _CustomBottomNavigationBar({
    Key? key,
    required this.transitionAnimationController,
  }) : super(key: key);

  final AnimationController transitionAnimationController;

  @override
  Widget build(BuildContext context) {
    final actionActive = useState(false);

    void updateActionState() => actionActive.value = !actionActive.value;

    return SBottomNavigationBar(
      animationController: transitionAnimationController,
      selectedIndex: 1,
      actionActive: actionActive.value,
      onActionTap: () {
        if (!actionActive.value) {
          sShowMenuActionSheet(
            context: context,
            onBuy: () {},
            onSell: () {},
            onConvert: () {},
            onDeposit: () {},
            onWithdraw: () {},
            onSend: () {},
            onReceive: () {},
            onDissmis: updateActionState,
            whenComplete: () {
              if (actionActive.value) updateActionState();
            },
            transitionAnimationController: transitionAnimationController,
            isNotEmptyBalance: true,
          );
        } else {
          Navigator.pop(context);
        }
        updateActionState();
      },
      onChanged: (value) {},
    );
  }
}
