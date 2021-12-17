import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class PhoneVerificationBlock extends HookWidget {
  const PhoneVerificationBlock({
    Key? key,
    required this.onChanged,
    required this.countryCode,
    required this.showBottomSheet,
    this.onErase,
  }) : super(key: key);

  final Function(String value) onChanged;
  final Function() showBottomSheet;
  final String countryCode;
  final Function()? onErase;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return SizedBox(
      height: 88.0,
      child: Row(
        children: [
          GestureDetector(
            onTap: showBottomSheet,
            child: Container(
              width: 100.0,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Code',
                    style: sCaptionTextStyle.copyWith(
                      color: colors.grey2,
                    ),
                  ),
                  Baseline(
                    baseline: 22.0,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      countryCode,
                      style: sSubtitle2Style,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: colors.grey4,
            width: 1.0,
          ),
          Column(
            children: [
              Container(
                height: 88.0,
                width: 250.0,
                padding: const EdgeInsets.only(left: 25.0),
                child: SStandardField(
                  onErase: onErase,
                  labelText: 'Phone number',
                  autofocus: true,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  alignLabelWithHint: true,
                  onChanged: (String number) => onChanged(number),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
