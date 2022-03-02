import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push.dart';

class EnterCardDetails extends HookWidget {
  const EnterCardDetails({Key? key}) : super(key: key);

  static void push(BuildContext context) {
    navigatorPush(context, const EnterCardDetails());
  }

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return SPageFrame(
      header: SPaddingH24(
        child: SBigHeader(
          customIconButton: SIconButton(
            onTap: () => Navigator.pop(context),
            defaultIcon: const SCloseIcon(),
            pressedIcon: const SClosePressedIcon(),
          ),
          title: 'Enter card details',
        ),
      ),
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              const SFieldDividerFrame(
                child: SStandardField(
                  labelText: 'Card number',
                ),
              ),
              Row(
                children: const [
                  Expanded(
                    child: SFieldDividerFrame(
                      child: SStandardField(
                        labelText: 'Expiry Date',
                      ),
                    ),
                  ),
                  SDivider(
                    width: 1.0,
                    height: 88.0,
                  ),
                  Expanded(
                    child: SFieldDividerFrame(
                      child: SStandardField(
                        labelText: 'CVV',
                      ),
                    ),
                  ),
                ],
              ),
              const SFieldDividerFrame(
                child: SStandardField(
                  labelText: 'Cardholder name',
                ),
              ),
              const SFieldDividerFrame(
                child: SStandardField(
                  labelText: 'Street Address',
                ),
              ),
              const SFieldDividerFrame(
                child: SStandardField(
                  labelText: 'Street Address 2 (optional)',
                ),
              ),
              const SFieldDividerFrame(
                child: SStandardField(
                  labelText: 'City',
                ),
              ),
              const SFieldDividerFrame(
                child: SStandardField(
                  labelText: 'Postal code',
                ),
              ),
              const SPaddingH24(
                child: SStandardField(
                  labelText: 'Country',
                ),
              ),
              const SpaceH136()
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Material(
              color: colors.grey5,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SPrimaryButton2(
                  active: true,
                  name: 'Continue',
                  onTap: () {},
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
