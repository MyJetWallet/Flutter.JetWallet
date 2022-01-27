import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import 'app_version_box.dart';

class LogOutOption extends HookWidget {
  const LogOutOption({
    Key? key,
    this.textColor = Colors.black,
    this.borderColor = Colors.black,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final Color textColor;
  final Color borderColor;
  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            height: 30.0,
            margin: const EdgeInsets.symmetric(
              vertical: 18.0,
              horizontal: 24.0,
            ),
            child: Row(
              children: <Widget>[
                const SLogOutIcon(),
                const SpaceW20(),
                Baseline(
                  baseline: 20,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    name,
                    style: sSubtitle1Style.copyWith(
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
