import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:jetwallet/widgets/result_screens/success_screen/widgets/progress_bar.dart';
import 'package:jetwallet/widgets/result_screens/success_screen/widgets/success_animation.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'SuccessScreenRouter')
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    Key? key,
    this.onSuccess,
    this.onActionButton,
    this.primaryText,
    this.secondaryText,
    this.specialTextWidget,
    this.showActionButton = false,
    this.showProgressBar = false,
    this.showShareButton = false,
    this.showPrimaryButton = false,
    this.buttonText,
    this.time = 3,
  }) : super(key: key);

  // Triggered when SuccessScreen is done
  final Function(BuildContext)? onSuccess;
  final Function()? onActionButton;
  final String? primaryText;
  final String? secondaryText;
  final String? buttonText;
  final Widget? specialTextWidget;
  final int time;
  final bool showProgressBar;
  final bool showActionButton;
  final bool showShareButton;
  final bool showPrimaryButton;

  @override
  Widget build(BuildContext context) {
    return Provider<TimerStore>(
      create: (_) => TimerStore(time),
      dispose: (context, store) => store.dispose(),
      builder: (context, child) => _SuccessScreenBody(
        onSuccess: onSuccess,
        onActionButton: onActionButton,
        primaryText: primaryText,
        secondaryText: secondaryText,
        buttonText: buttonText,
        specialTextWidget: specialTextWidget,
        time: time,
        showProgressBar: showProgressBar,
        showActionButton: showActionButton,
        showShareButton: showShareButton,
        showPrimaryButton: showPrimaryButton,
      ),
    );
  }
}

class _SuccessScreenBody extends StatefulWidget {
  const _SuccessScreenBody({
    super.key,
    this.onSuccess,
    this.onActionButton,
    this.primaryText,
    this.secondaryText,
    this.specialTextWidget,
    this.showActionButton = false,
    this.showProgressBar = false,
    this.showShareButton = false,
    this.showPrimaryButton = false,
    this.buttonText,
    this.time = 3,
  });

  // Triggered when SuccessScreen is done
  final Function(BuildContext)? onSuccess;
  final Function()? onActionButton;
  final String? primaryText;
  final String? secondaryText;
  final String? buttonText;
  final Widget? specialTextWidget;
  final int time;
  final bool showProgressBar;
  final bool showActionButton;
  final bool showShareButton;
  final bool showPrimaryButton;

  @override
  State<_SuccessScreenBody> createState() => _SuccessScreenBodyState();
}

class _SuccessScreenBodyState extends State<_SuccessScreenBody> {
  bool shouldPop = true;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;
    final showBottomSpace = widget.showProgressBar ||
      widget.showActionButton ||
      widget.showPrimaryButton;

    return ReactionBuilder(
      builder: (context) {
        return reaction<int>(
          (_) => TimerStore.of(context).time,
          (result) {
            if (result == 0) {
              if (widget.onSuccess == null && shouldPop) {
                /// Navigates to the first route

                sRouter.popUntilRoot();
              } else {
                widget.onSuccess!.call(context);
              }
            }
          },
          fireImmediately: true,
        );
      },
      child: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: SPageFrameWithPadding(
          loaderText: intl.register_pleaseWait,
          child: Observer(
            builder: (context) {
              return Stack(
                children: [
                  Column(
                    children: [
                      Row(), // to expand Column in the cross axis
                      const SpaceH86(),
                      SuccessAnimation(
                        widgetSize: widgetSizeFrom(deviceSize),
                      ),
                      Baseline(
                        baseline: 136.0,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          widget.primaryText ?? intl.successScreen_success,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: sTextH2Style,
                        ),
                      ),
                      if (widget.secondaryText != null)
                        Baseline(
                          baseline: 31.4,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            widget.secondaryText!,
                            maxLines: 10,
                            textAlign: TextAlign.center,
                            style: sBodyText1Style.copyWith(
                              color: colors.grey1,
                            ),
                          ),
                        ),
                      if (widget.specialTextWidget != null)
                        widget.specialTextWidget!,
                      const Spacer(),
                      Column(
                        children: [
                          if (widget.showProgressBar) ...[
                            SizedBox(
                              height: 2,
                              width: MediaQuery.of(context).size.width,
                              child: ProgressBar(
                                time: widget.time,
                                colors: colors,
                              ),
                            ),
                            const SpaceH24(),
                          ],
                          if (widget.showActionButton)
                            SSecondaryButton1(
                              active: true,
                              name: intl.previewBuyWithUmlimint_saveCard,
                              icon: Container(
                                margin: const EdgeInsets.only(
                                  top: 32,
                                ),
                                child: SActionBuyIcon(
                                  color: colors.black,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  shouldPop = false;
                                });

                                widget.onActionButton?.call();
                              },
                            ),
                          if (widget.showShareButton)
                            SSecondaryButton1(
                              active: true,
                              name: intl.nft_share,
                              icon: Container(
                                margin: const EdgeInsets.only(
                                  top: 32,
                                ),
                                child: SShareIcon(
                                  color: colors.black,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  shouldPop = false;
                                });

                                widget.onActionButton?.call();
                              },
                            ),
                          if (widget.showPrimaryButton)
                            SPrimaryButton2(
                              active: true,
                              name: intl.cardVerification_close,
                              onTap: () {
                                setState(() {
                                  shouldPop = false;
                                });

                                widget.onActionButton?.call();
                              },
                            ),
                          if (showBottomSpace) const SpaceH42(),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
