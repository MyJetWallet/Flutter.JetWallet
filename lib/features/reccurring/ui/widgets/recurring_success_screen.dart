import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_asset_input.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:jetwallet/widgets/result_screens/success_screen/widgets/success_animation.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import '../../../actions/action_recurring_buy/action_with_out_recurring_buy.dart';
import '../../helper/recurring_buys_operation_name.dart';

@RoutePage(name: 'RecurringSuccessScreenRouter')
class RecurringSuccessScreen extends StatelessWidget {
  const RecurringSuccessScreen({
    super.key,
    required this.input,
  });

  final PreviewBuyWithAssetInput input;

  @override
  Widget build(BuildContext context) {
    return Provider<TimerStore>(
      create: (_) => TimerStore(3),
      dispose: (context, store) => store.dispose(),
      builder: (context, child) => _RecurringSuccessScreenBody(
        input: input,
      ),
    );
  }
}

class _RecurringSuccessScreenBody extends StatefulObserverWidget {
  const _RecurringSuccessScreenBody({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewBuyWithAssetInput input;

  @override
  State<_RecurringSuccessScreenBody> createState() =>
      _RecurringSuccessScreenBodyState();
}

class _RecurringSuccessScreenBodyState
    extends State<_RecurringSuccessScreenBody> {
  bool shouldPop = true;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    return ReactionBuilder(
      builder: (context) {
        return reaction<int>(
          (_) => TimerStore.of(context).time,
          (result) {
            if (result == 0 && shouldPop) {
              navigateToRouter();
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
          child: Column(
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
                  intl.recurringSuccessScreen_success,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: sTextH2Style,
                ),
              ),
              Baseline(
                baseline: 31.4,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  intl.recurringSuccessScreen_orderProcessing,
                  maxLines: 10,
                  textAlign: TextAlign.center,
                  style: sBodyText1Style.copyWith(
                    color: colors.grey1,
                  ),
                ),
              ),
              const Spacer(),
              const SpaceH24(),
            ],
          ),
        ),
      ),
    );
  }
}
