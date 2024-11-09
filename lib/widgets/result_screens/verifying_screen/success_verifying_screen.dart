import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:jetwallet/widgets/result_screens/widgets/progress_bar.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../../utils/constants.dart';

@RoutePage(name: 'SuccessVerifyingScreenRouter')
class SuccessVerifyingScreen extends StatelessWidget {
  const SuccessVerifyingScreen({
    super.key,
    required this.onSuccess,
  });

  // Triggered when SuccessScreen is done
  final Function() onSuccess;

  @override
  Widget build(BuildContext context) {
    return Provider<TimerStore>(
      create: (_) => TimerStore(3),
      dispose: (context, store) => store.dispose(),
      builder: (context, child) => _SuccessScreenBody(
        onSuccess: onSuccess,
      ),
    );
  }
}

class _SuccessScreenBody extends StatefulWidget {
  const _SuccessScreenBody({
    required this.onSuccess,
  });

  final Function() onSuccess;

  @override
  State<_SuccessScreenBody> createState() => _SuccessScreenBodyState();
}

class _SuccessScreenBodyState extends State<_SuccessScreenBody> {
  bool shouldPop = true;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final deviceSize = sDeviceSize;

    return ReactionBuilder(
      builder: (context) {
        return reaction<int>(
          (_) => TimerStore.of(context).time,
          (result) {
            if (result == 0) {
              widget.onSuccess.call();
            }
          },
          fireImmediately: true,
        );
      },
      child: PopScope(
        canPop: false,
        child: SPageFrame(
          loaderText: intl.register_pleaseWait,
          child: Observer(
            builder: (context) {
              return Stack(
                children: [
                  Column(
                    children: [
                      const SpaceH86(),
                      const Spacer(),
                      Image.asset(
                        verifyYourProfileAsset,
                        width: widgetSizeFrom(deviceSize) == SWidgetSize.small ? 160 : 225,
                        height: widgetSizeFrom(deviceSize) == SWidgetSize.small ? 160 : 225,
                      ),
                      const Spacer(),
                      Baseline(
                        baseline: 136.0,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          intl.cardVerification_reviewCompleted,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: sTextH2Style,
                        ),
                      ),
                      Baseline(
                        baseline: 31.4,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          intl.cardVerification_completeOrder,
                          maxLines: 10,
                          textAlign: TextAlign.center,
                          style: sBodyText1Style.copyWith(
                            color: colors.grey1,
                          ),
                        ),
                      ),
                      const SpaceH64(),
                      Column(
                        children: [
                          SizedBox(
                            height: 2,
                            width: MediaQuery.of(context).size.width,
                            child: const ProgressBar(
                              time: 3,
                            ),
                          ),
                          const SpaceH24(),
                          SButton.blue(
                            text: intl.kycAlertHandler_continue,
                            callback: () {
                              setState(() {
                                shouldPop = false;
                              });

                              widget.onSuccess.call();
                            },
                          ),
                          const SpaceH24(),
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
