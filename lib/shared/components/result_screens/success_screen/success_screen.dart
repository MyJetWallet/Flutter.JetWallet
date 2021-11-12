import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../helpers/navigate_to_router.dart';
import 'components/success_animation.dart';

class SuccessScreen extends HookWidget {
  const SuccessScreen({
    Key? key,
    this.then,
    this.header,
    this.text2,
    this.text3,
    required this.text1,
  }) : super(key: key);

  // Triggered when SuccessScreen is done
  final Function()? then;
  final String? header;
  final String text1;
  final String? text2;
  final String? text3;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return ProviderListener<int>(
      provider: timerNotipod(3),
      onChange: (context, value) {
        if (value == 0) {
          navigateToRouter(context.read);
          then?.call();
        }
      },
      child: SPageFrameWithPadding(
        resizeToAvoidBottomInset: false,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SpaceH120(),
              const SuccessAnimation(),
              const SpaceH131(),
              Text('Success', style: sTextH2Style),
              const SpaceH17(),
              Text(
                text1,
                style: sBodyText1Style.copyWith(
                  color: colors.grey1,
                ),
              ),
              if (text2 != null)
                Text(
                  text2!,
                  style: sBodyText1Style.copyWith(
                    color: colors.black,
                  ),
                ),
              if (text3 != null)
                Text(
                  text3!,
                  style: sBodyText1Style.copyWith(
                    color: colors.grey1,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
