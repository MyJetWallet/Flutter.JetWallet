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

class _showHideZero extends StatelessObserverWidget {
  const _showHideZero({
    Key? key,
    required this.appStore,
  }) : super(key: key);

  final AppStore appStore;

  @override
  Widget build(BuildContext context) {
    final state = appStore;
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
                  color: !state.showAllAssets
                      ? Colors.black
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Switch(
                  value: !state.showAllAssets,
                  onChanged: (value) {
                    state.setShowAllAssets(!value);
                    Navigator.pop(context);
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
