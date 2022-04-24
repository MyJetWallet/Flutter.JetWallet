import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/components/result_screens/success_screen/components/success_animation.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/helpers/widget_size_from.dart';
import '../../../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../currency_buy/model/preview_buy_with_asset_input.dart';
import '../../../currency_buy/view/curency_buy.dart';
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
    final colors = useProvider(sColorPod);
    final shouldPop = useState(true);

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: ProviderListener<int>(
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
                  'Success',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: sTextH2Style,
                ),
              ),
              Baseline(
                baseline: 31.4,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  'Order processing',
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
                name: 'Setup recurring buy',
                onTap: () {
                  shouldPop.value = false;

                  showActionWithOutRecurringBuy(
                    then: () {
                      if (!shouldPop.value) navigateToRouter(context.read);
                    },
                    context: context,
                    onItemTap: (recurringType) {
                      shouldPop.value = true;

                      navigatorPush(
                        context,
                        PreviewBuyWithAsset(
                          input: PreviewBuyWithAssetInput(
                            amount: input.amount,
                            fromCurrency: input.fromCurrency,
                            toCurrency: input.toCurrency,
                            recurringType: recurringType,
                          ),
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
