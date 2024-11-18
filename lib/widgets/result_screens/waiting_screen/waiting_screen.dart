import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/widgets/result_screens/widgets/result_screen_title.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../../utils/constants.dart';
import '../widgets/result_screen_description.dart';

@RoutePage(name: 'WaitingScreenRouter')
class WaitingScreen extends StatelessObserverWidget {
  const WaitingScreen({
    super.key,
    this.primaryText,
    this.secondaryText,
    this.onSkip,
    this.isLoading = false,
    this.isCanClouse = true,
  });

  final Function()? onSkip;
  final String? primaryText;
  final String? secondaryText;
  final bool isLoading;
  final bool isCanClouse;

  void onClose() {
    navigateToRouter();
    onSkip?.call();
  }

  @override
  Widget build(BuildContext context) {
    final secondaryText = this.secondaryText;

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: GlobalBasicAppBar(
        hasTitle: false,
        hasSubtitle: false,
        hasLeftIcon: false,
        hasRightIcon: isCanClouse,
        onRightIconTap: onClose,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: MediaQuery.of(context).padding.top,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: Center(
          child: Column(
            children: [
              const Spacer(
                flex: 2,
              ),
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
                flex: 3,
              ),
              if (isCanClouse)
                SButton.black(
                  text:
                      isLoading ? intl.waiting_screen_loading_button_name : intl.waiting_screen_processing_button_name,
                  callback: onClose,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
