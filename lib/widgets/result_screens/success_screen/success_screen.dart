import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/crypto_jar/store/jars_store.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:jetwallet/widgets/result_screens/widgets/progress_bar.dart';
import 'package:jetwallet/widgets/result_screens/widgets/result_screen_title.dart';
import 'package:lottie/lottie.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../../utils/constants.dart';
import '../../../utils/helpers/navigate_to_router.dart';
import '../widgets/result_screen_description.dart';

@RoutePage(name: 'SuccessScreenRouter')
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    this.onSuccess,
    this.primaryText,
    this.secondaryText,
    this.actionButtonName,
    this.onActionButton,
    this.onCloseButton,
    this.bottomWidget,
    this.time = 3,
    this.isJarFlow,
    this.isCryptoCardChangePinFlow,
    this.child,
  });

  final Function(BuildContext)? onSuccess;
  final Function()? onActionButton;
  final Function()? onCloseButton;
  final String? primaryText;
  final String? secondaryText;
  final Widget? bottomWidget;
  final int time;
  final String? actionButtonName;
  final bool? isJarFlow;
  final bool? isCryptoCardChangePinFlow;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Provider<TimerStore>(
      create: (_) => TimerStore(time),
      dispose: (context, store) => store.dispose(),
      builder: (context, _) => _SuccessScreenBody(
        onSuccess: onSuccess,
        onActionButton: onActionButton,
        primaryText: primaryText,
        secondaryText: secondaryText,
        bottomWidget: bottomWidget,
        time: time,
        actionButtonName: actionButtonName,
        onCloseButton: onCloseButton,
        isJarFlow: isJarFlow ?? false,
        isCryptoCardChangePinFlow: isCryptoCardChangePinFlow ?? false,
        child: child,
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
    required this.time,
    this.isJarFlow,
    this.isCryptoCardChangePinFlow,
    this.child,
  });

  final Function(BuildContext)? onSuccess;
  final Function()? onActionButton;
  final Function()? onCloseButton;
  final String? primaryText;
  final String? secondaryText;
  final Widget? bottomWidget;
  final int time;
  final String? actionButtonName;
  final bool? isJarFlow;
  final bool? isCryptoCardChangePinFlow;
  final Widget? child;

  @override
  State<_SuccessScreenBody> createState() => _SuccessScreenBodyState();
}

class _SuccessScreenBodyState extends State<_SuccessScreenBody> with WidgetsBindingObserver {
  bool shouldPop = true;

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

  void onClose() {
    if (widget.isJarFlow ?? false) {
      sRouter.popUntil((route) => route.settings.name == JarRouter.name);
      Future.delayed(const Duration(seconds: 3)).then((_) {
        getIt.get<JarsStore>().refreshJarsStore();
      });
    } else {
      navigateToRouter();
      widget.onCloseButton?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final secondaryText = widget.secondaryText;
    final bottomWidget = widget.bottomWidget;
    final actionButtonName = widget.actionButtonName;

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
              header: GlobalBasicAppBar(
                hasTitle: false,
                hasSubtitle: false,
                hasLeftIcon: false,
                onRightIconTap: onClose,
              ),
              loaderText: intl.register_pleaseWait,
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
                    if (widget.child != null) ...[
                      const SpaceH24(),
                      widget.child ?? Container(),
                    ],
                    const Spacer(
                      flex: 3,
                    ),
                    if (bottomWidget != null) ...[
                      const SpaceH24(),
                      bottomWidget,
                    ],
                    if (!(widget.isCryptoCardChangePinFlow ?? false)) ...[
                      const SpaceH24(),
                      SizedBox(
                        height: 2,
                        width: MediaQuery.of(context).size.width,
                        child: ProgressBar(
                          time: widget.time,
                        ),
                      ),
                    ],
                    const SpaceH24(),
                    if (actionButtonName != null) ...[
                      SButton.text(
                        text: actionButtonName,
                        callback: () {
                          setState(() {
                            shouldPop = false;
                          });

                          widget.onActionButton?.call();
                        },
                      ),
                      const SpaceH8(),
                    ],
                    SButton.black(
                      text: intl.success_screen_button_name,
                      callback: () {
                        setState(() {
                          shouldPop = false;
                        });

                        onClose();
                      },
                    ),
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
