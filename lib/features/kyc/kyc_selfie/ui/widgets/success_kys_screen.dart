import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:jetwallet/widgets/result_screens/success_screen/widgets/success_animation.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'SuccessKycScreenRoute')
class SuccessKycScreen extends StatelessWidget {
  const SuccessKycScreen({
    super.key,
    this.primaryText,
    this.secondaryText,
    this.specialTextWidget,
  });

  final String? primaryText;
  final String? secondaryText;
  final Widget? specialTextWidget;

  @override
  Widget build(BuildContext context) {
    return Provider<TimerStore>(
      create: (context) => TimerStore(3),
      builder: (context, child) => _SuccessKycScreenBody(
        primaryText: primaryText,
        secondaryText: secondaryText,
        specialTextWidget: specialTextWidget,
      ),
      dispose: (context, state) => state.dispose(),
    );
  }
}

class _SuccessKycScreenBody extends StatefulWidget {
  const _SuccessKycScreenBody({
    super.key,
    this.primaryText,
    this.secondaryText,
    this.specialTextWidget,
  });

  final String? primaryText;
  final String? secondaryText;
  final Widget? specialTextWidget;

  @override
  State<_SuccessKycScreenBody> createState() => _SuccessKycScreenBodyState();
}

class _SuccessKycScreenBodyState extends State<_SuccessKycScreenBody> {
  @override
  void initState() {
    super.initState();

    startKycService();
  }

  Future<void> startKycService() async {
    final _ = await sNetwork.getWalletModule().postKycStart();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    return SPageFrameWithPadding(
      loaderText: intl.register_pleaseWait,
      child: Column(
        children: [
          const Spacer(),
          SuccessAnimation(
            widgetSize: widgetSizeFrom(deviceSize),
          ),
          Baseline(
            baseline: 136.0,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              widget.primaryText ?? intl.successKycScreen_success,
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
          if (widget.specialTextWidget != null) widget.specialTextWidget!,
          Padding(
            padding: const EdgeInsets.only(
              bottom: 24.0,
              top: 40.0,
            ),
            child: SPrimaryButton2(
              active: true,
              name: intl.successKycScreen_done,
              onTap: () {
                navigateToRouter();
              },
            ),
          ),
        ],
      ),
    );
  }
}
