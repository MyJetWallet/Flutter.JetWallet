import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:jetwallet/widgets/result_screens/success_screen/widgets/progress_bar.dart';
import 'package:jetwallet/widgets/result_screens/success_screen/widgets/success_animation.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

class SuccessScreen extends StatefulObserverWidget {
  const SuccessScreen({
    Key? key,
    this.onSuccess,
    this.onActionButton,
    this.primaryText,
    this.secondaryText,
    this.specialTextWidget,
    this.showActionButton = false,
    this.showProgressBar = false,
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

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  bool shouldPop = true;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;
    final showBottomSpace = widget.showProgressBar || widget.showActionButton;

    return Provider<TimerStore>(
      create: (_) => TimerStore(3),
      dispose: (context, store) => store.dispose(),
      child: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: SPageFrameWithPadding(
          child: Observer(
            builder: (context) {
              if (TimerStore.of(context).time == 0) {
                if (widget.onSuccess == null && shouldPop) {
                  /// Navigates to the first route
                  sRouter.replace(
                    const HomeRouter(),
                  );
                } else {
                  widget.onSuccess!.call(context);
                }
              }

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
                                time: 5,
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
                          if (showBottomSpace) const SpaceH24(),
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
