import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/components/result_screens/success_screen/components/success_animation.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../../shared/helpers/widget_size_from.dart';
import '../../../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../actions/action_recurring_buy/action_with_out_recurring_buy.dart';
import '../../../currency_buy/model/preview_buy_with_asset_input.dart';
import '../../../currency_buy/view/preview_buy_with_asset.dart';

class RecurringSuccessScreen extends HookWidget {
  const RecurringSuccessScreen({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewBuyWithAssetInput input;

  static void push({
    Key? key,
    required BuildContext context,
    required PreviewBuyWithAssetInput input,
  }) {
    navigatorPush(
      context,
      RecurringSuccessScreen(
        input: input,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = useProvider(deviceSizePod);
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final shouldPop = useState(true);

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: ProviderListener<int>(
        // TODO: Reconsider this approach
        provider: timerNotipod(3.01),
        onChange: (context, value) {
          if (value == 0 && shouldPop.value) {
            navigateToRouter(context.read);
          }
        },
        child: SPageFrameWithPadding(
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
                  intl.orderProcessing,
                  maxLines: 10,
                  textAlign: TextAlign.center,
                  style: sBodyText1Style.copyWith(
                    color: colors.grey1,
                  ),
                ),
              ),
              const Spacer(),
              SSecondaryButton1(
                active: true,
                name: intl.actionBuy_actionWithOutRecurringBuyTitle1,
                onTap: () {
                  shouldPop.value = false;

                  showActionWithOutRecurringBuy(
                    title: intl.actionBuy_actionWithOutRecurringBuyTitle1,
                    then: (_) {
                      if (!shouldPop.value) navigateToRouter(context.read);
                      shouldPop.value = false;
                    },
                    context: context,
                    onItemTap: (recurringType) {
                      shouldPop.value = true;

                      navigatorPushReplacement(
                        context,
                        PreviewBuyWithAsset(
                          input: PreviewBuyWithAssetInput(
                            amount: input.amount,
                            fromCurrency: input.fromCurrency,
                            toCurrency: input.toCurrency,
                            recurringType: recurringType,
                          ),
                          onBackButtonTap: () {
                            navigateToRouter(context.read);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              const SpaceH24(),
            ],
          ),
        ),
      ),
    );
  }
}
