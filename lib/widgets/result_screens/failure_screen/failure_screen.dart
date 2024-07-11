import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/widgets/result_screens/widgets/result_screen_title.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../../core/l10n/i10n.dart';
import '../../../utils/helpers/navigate_to_router.dart';
import '../widgets/result_screen_description.dart';

@RoutePage(name: 'FailureScreenRouter')
class FailureScreen extends StatelessObserverWidget {
  const FailureScreen({
    super.key,
    this.primaryText,
    this.secondaryText,
    this.secondaryButtonName,
    this.onPrimaryButtonTap,
    this.onSecondaryButtonTap,
  });

  final String? primaryText;
  final String? secondaryText;
  final String? secondaryButtonName;
  final Function()? onPrimaryButtonTap;
  final Function()? onSecondaryButtonTap;

  void onClose() {
    navigateToRouter();
    onPrimaryButtonTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final secondaryText = this.secondaryText;
    final onSecondaryButtonTap = this.onSecondaryButtonTap;
    final secondaryButtonName = this.secondaryButtonName;

    return PopScope(
      canPop: false,
      child: SPageFrame(
        loaderText: intl.register_pleaseWait,
        header: GlobalBasicAppBar(
          hasTitle: false,
          hasSubtitle: false,
          hasLeftIcon: false,
          onRightIconTap: onClose,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: MediaQuery.of(context).padding.top,
            bottom: MediaQuery.of(context).padding.bottom + 16,
          ),
          child: Column(
            children: [
              const Spacer(
                flex: 2,
              ),
              Column(
                children: [
                  Lottie.asset(
                    failureAnimationAsset,
                    width: 80,
                    height: 80,
                  ),
                  const SpaceH24(),
                  ResultScreenTitle(
                    title: primaryText ?? intl.failure_screen_title,
                  ),
                  if (secondaryText != null) ...[
                    const SpaceH16(),
                    ResultScreenDescription(
                      text: secondaryText,
                    ),
                  ],
                ],
              ),
              const Spacer(
                flex: 3,
              ),
              if (secondaryButtonName != null && onSecondaryButtonTap != null) ...[
                SButton.text(
                  text: secondaryButtonName,
                  callback: onSecondaryButtonTap,
                ),
                const SpaceH8(),
              ],
              SButton.black(
                text: intl.failure_screen_button_name,
                callback: onClose,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
