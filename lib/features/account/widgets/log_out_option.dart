import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

import 'app_version_box.dart';

class LogOutOption extends StatelessObserverWidget {
  const LogOutOption({
    super.key,
    this.textColor = Colors.black,
    this.borderColor = Colors.black,
    required this.name,
    required this.onTap,
  });

  final Color textColor;
  final Color borderColor;
  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          highlightColor: colors.grey5,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: Row(
              children: <Widget>[
                const SLogOutIcon(),
                const SpaceW12(),
                Baseline(
                  baseline: 20,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    name,
                    style: sSubtitle2Style.copyWith(
                      color: colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          top: 19,
          right: 24,
          child: AppVersionBox(),
        ),
      ],
    );
  }
}
