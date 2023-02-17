import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/widgets/result_screens/failure_screen/widgets/failure_animation.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/l10n/i10n.dart';

class FailureScreen extends StatelessObserverWidget {
  const FailureScreen({
    Key? key,
    this.secondaryText,
    this.secondaryButtonName,
    this.onSecondaryButtonTap,
    required this.primaryText,
    required this.primaryButtonName,
    required this.onPrimaryButtonTap,
  }) : super(key: key);

  final String? secondaryText;
  final String? secondaryButtonName;
  final Function()? onSecondaryButtonTap;
  final String primaryText;
  final String primaryButtonName;
  final Function() onPrimaryButtonTap;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: SPageFrameWithPadding(
        loaderText: intl.register_pleaseWait,
        child: Column(
          children: [
            const SpaceH86(),
            FailureAnimation(
              widgetSize: widgetSizeFrom(deviceSize),
            ),
            Baseline(
              baseline: 92.0,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                primaryText,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: sTextH2Style,
              ),
            ),
            if (secondaryText != null)
              Baseline(
                baseline: 31.4,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  secondaryText!,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: sBodyText1Style.copyWith(
                    color: colors.grey1,
                  ),
                ),
              ),
            const Spacer(),
            SSecondaryButton1(
              active: true,
              name: primaryButtonName,
              onTap: onPrimaryButtonTap,
            ),
            const SpaceH10(),
            if (secondaryButtonName != null && onSecondaryButtonTap != null)
              STextButton1(
                active: true,
                name: secondaryButtonName!,
                onTap: onSecondaryButtonTap!,
              ),
            const SpaceH24(),
          ],
        ),
      ),
    );
  }
}
