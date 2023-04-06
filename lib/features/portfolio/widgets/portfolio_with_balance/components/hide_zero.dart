import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:simple_kit/simple_kit.dart';

void showHideZero(BuildContext context) {
  final appStore = getIt.get<AppStore>();

  sShowBasicModalBottomSheet(
    context: context,
    then: (value) {},
    children: [
      _showHideZero(
        appStore: appStore,
      ),
    ],
  );
}

class _showHideZero extends StatefulObserverWidget {
  const _showHideZero({
    Key? key,
    required this.appStore,
  }) : super(key: key);

  final AppStore appStore;
  @override
  _showHideZeroState createState() => _showHideZeroState();
}

class _showHideZeroState extends State<_showHideZero> {
  bool hideAll = true;
  bool canChange = true;

  @override
  void initState() {
    super.initState();
    hideAll = !widget.appStore.showAllAssets;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.appStore;
    final colors = sKit.colors;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              intl.myAssets_settings,
              style: sTextH5Style,
            ),
          ],
        ),
        const SpaceH51(),
        SPaddingH24(
          child: Row(
            children: [
              SEyeOpenIcon(
                color: colors.black,
              ),
              const SpaceW20(),
              Expanded(
                child: Text(
                  intl.myAssets_hideZero,
                  style: sSubtitle2Style,
                ),
              ),
              Container(
                width: 40.0,
                height: 22.0,
                decoration: BoxDecoration(
                  color: hideAll
                      ? Colors.black
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Switch(
                  value: hideAll,
                  onChanged: (value) {
                    if (canChange) {
                      setState(() {
                        hideAll = value;
                        canChange = false;
                      });
                      state.setShowAllAssets(!value);

                      Timer(
                        const Duration(milliseconds: 400),
                            () {
                          setState(() {
                            canChange = true;
                          });
                          Navigator.pop(context);
                        },
                      );
                    }
                  },
                  activeColor: Colors.white,
                  activeTrackColor: Colors.black,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const SpaceH75(),
      ],
    );
  }
}
