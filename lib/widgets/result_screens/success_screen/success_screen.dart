import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:jetwallet/widgets/result_screens/widgets/progress_bar.dart';
import 'package:jetwallet/widgets/result_screens/widgets/result_screen_title.dart';
import 'package:lottie/lottie.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../../utils/constants.dart';
import '../widgets/result_screen_description.dart';

@RoutePage(name: 'SuccessScreenRouter')
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    this.onSuccess,
    this.onActionButton,
    this.onCloseButton,
    this.primaryText,
    this.secondaryText,
    this.bottomWidget,
    this.actionButtonName,
    this.primaryButtonText,
    this.showProgressBar = false,
    this.showPrimaryButton = false,
    this.time = 3,
  });

  final Function(BuildContext)? onSuccess;
  final Function()? onActionButton;
  final Function()? onCloseButton;
  final String? primaryText;
  final String? secondaryText;
  final Widget? bottomWidget;
  final int time;
  final bool showProgressBar;
  final String? actionButtonName;
  final String? primaryButtonText;
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
        bottomWidget: bottomWidget,
        time: time,
        showProgressBar: showProgressBar,
        actionButtonName: actionButtonName,
        showPrimaryButton: showPrimaryButton,
        primaryButtonText: primaryButtonText,
        onCloseButton: onCloseButton,
      ),
    );
  }
}

class _SuccessScreenBody extends StatefulWidget {
  const _SuccessScreenBody({
    this.onSuccess,
    this.onActionButton,
    this.onCloseButton,
    this.primaryText,
    this.secondaryText,
    this.bottomWidget,
    this.actionButtonName,
    this.primaryButtonText,
    this.showProgressBar = false,
    this.showPrimaryButton = false,
    required this.time,
  });

  final Function(BuildContext)? onSuccess;
  final Function()? onActionButton;
  final Function()? onCloseButton;
  final String? primaryText;
  final String? secondaryText;
  final Widget? bottomWidget;
  final int time;
  final String? primaryButtonText;
  final bool showProgressBar;
  final String? actionButtonName;
  final bool showPrimaryButton;

  @override
  State<_SuccessScreenBody> createState() => _SuccessScreenBodyState();
}

class _SuccessScreenBodyState extends State<_SuccessScreenBody> with WidgetsBindingObserver {
  bool shouldPop = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      TimerStore.of(context).dispose();

      Future.delayed(const Duration(milliseconds: 100), () {
        if (widget.onSuccess == null && shouldPop) {
          sRouter.popUntilRoot();
        } else {
          widget.onSuccess!.call(context);
        }
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final secondaryText = widget.secondaryText;
    final bottomWidget = widget.bottomWidget;
    final showProgressBar = widget.showProgressBar;
    final onCloseButton = widget.onCloseButton;
    final actionButtonName = widget.actionButtonName;
    final primaryButtonText = widget.primaryButtonText;
    final showBottomSpace = showProgressBar || actionButtonName != null || widget.showPrimaryButton;

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
      child: PopScope(
        canPop: false,
        child: Observer(
          builder: (context) {
            return SPageFrame(
              header: onCloseButton != null
                  ? GlobalBasicAppBar(
                      hasTitle: false,
                      hasSubtitle: false,
                      hasLeftIcon: false,
                      onRightIconTap: onCloseButton,
                    )
                  : null,
              loaderText: intl.register_pleaseWait,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  top: MediaQuery.of(context).padding.top,
                  bottom: MediaQuery.of(context).padding.bottom + (showBottomSpace ? 16 : 0),
                ),
                child: Column(
                  children: [
                    const Spacer(
                      flex: 2,
                    ),
                    Column(
                      children: [
                        Lottie.asset(
                          successJsonAnimationAsset,
                          width: 80,
                          height: 80,
                          repeat: false,
                        ),
                        const SpaceH24(),
                        ResultScreenTitle(
                          title: widget.primaryText ?? intl.successScreen_success,
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
                    if (bottomWidget != null) ...[
                      const SpaceH24(),
                      bottomWidget,
                    ],
                    if (showProgressBar) ...[
                      const SpaceH24(),
                      SizedBox(
                        height: 2,
                        width: MediaQuery.of(context).size.width,
                        child: ProgressBar(
                          time: widget.time,
                        ),
                      ),
                    ],
                    if (actionButtonName != null) ...[
                      const SpaceH24(),
                      SButton.text(
                        text: actionButtonName,
                        callback: () {
                          setState(() {
                            shouldPop = false;
                          });

                          widget.onActionButton?.call();
                        },
                      ),
                    ],
                    if (widget.showPrimaryButton) ...[
                      if (actionButtonName != null) const SpaceH8(),
                      SButton.black(
                        text: primaryButtonText ?? intl.cardVerification_close,
                        callback: () {
                          setState(() {
                            shouldPop = false;
                          });

                          widget.onActionButton?.call();
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
