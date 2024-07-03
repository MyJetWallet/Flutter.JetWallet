import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/widgets/result_screens/widgets/result_screen_title.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../../utils/constants.dart';
import '../widgets/result_screen_description.dart';

@RoutePage(name: 'WaitingScreenRouter')
class WaitingScreen extends StatelessObserverWidget {
  const WaitingScreen({
    super.key,
    this.primaryText,
    this.secondaryText,
    this.wasAction = false,
    this.onSkip,
  });

  final Function()? onSkip;
  final String? primaryText;
  final String? secondaryText;
  final bool wasAction;

  void onSkipTap() {
    onSkip?.call();
    navigateToRouter();
  }

  @override
  Widget build(BuildContext context) {
    final secondaryText = this.secondaryText;

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: wasAction
          ? GlobalBasicAppBar(
              hasTitle: false,
              hasSubtitle: false,
              hasLeftIcon: false,
              onRightIconTap: onSkipTap,
            )
          : null,
      child: Padding(
        padding: EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: wasAction ? 0 : MediaQuery.of(context).padding.top,
          bottom: MediaQuery.of(context).padding.bottom + (wasAction ? 16 : 0),
        ),
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              Column(
                children: [
                  Lottie.asset(
                    processingAnimationAsset,
                    width: 80,
                    height: 80,
                  ),
                  const SpaceH24(),
                  ResultScreenTitle(
                    title: primaryText ?? intl.waitingScreen_processing,
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
                flex: 2,
              ),
              if (wasAction) ...[
                SButton.black(
                  text: intl.previewBuyWithUmlimint_close,
                  callback: onSkipTap,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
