import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../helpers/navigate_to_router.dart';
import 'components/success_image.dart';

class SuccessScreen extends HookWidget {
  const SuccessScreen({
    Key? key,
    this.then,
    this.header,
    required this.description,
  }) : super(key: key);

  // Triggered when SuccessScreen is done
  final Function()? then;
  final String? header;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return ProviderListener<int>(
      provider: timerNotipod(2),
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
              const SuccessImage(),
              const SpaceH131(),
              Text('Success', style: sTextH2Style),
              const SpaceH17(),
              Text(
                description,
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
