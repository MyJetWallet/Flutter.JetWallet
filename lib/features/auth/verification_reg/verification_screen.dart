import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/di/di.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SPageFrameWithPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH64(),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                getIt<LogoutService>().logout(
                  'TWO FA, logout',
                  withLoading: false,
                );
              },
              child: Text(
                intl.logout,
                style: sSubtitle3Style.copyWith(
                  color: colors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              simpleLogo,
              width: 80,
              height: 80,
            ),
          ),
          const SpaceH24(),
          Text(
            intl.verification_your_profile,
            textAlign: TextAlign.left,
            style: sTextH4Style,
          ),
          const SpaceH8(),
          Text(
            intl.verification_your_profile_descr,
            textAlign: TextAlign.left,
            maxLines: 2,
            style: sBodyText1Style.copyWith(color: colors.grey1),
          ),
          const SpaceH32(),
          _verificationItem(
            intl.email_verification,
            '1',
            isDone: true,
          ),
          const SpaceH24(),
          _verificationItem(
            intl.phone_number,
            '2',
            haveLink: true,
            linkText: intl.provide_information,
            isDisabled: true,
          ),
          const SpaceH24(),
          _verificationItem(
            intl.personal_details,
            '3',
            haveSubText: true,
            linkText: intl.provide_information,
            subtext: intl.personal_details_descr,
            isDisabled: true,
          ),
          const SpaceH24(),
          _verificationItem(
            intl.pin_code,
            '4',
            haveSubText: true,
            subtext: intl.pin_code_descr,
            linkText: intl.create_pin_code,
            isDisabled: true,
          ),
        ],
      ),
    );
  }

  Widget _verificationItem(
    String itemString,
    String step, {
    bool isDone = false,
    bool haveSubText = false,
    String? subtext,
    bool haveLink = false,
    String? linkText,
    bool isDisabled = false,
  }) {
    final colors = sKit.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isDone) ...[
          const SpaceW2(),
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDisabled ? null : colors.blue,
              border: isDisabled ? Border.all(color: colors.grey1) : null,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 6,
                  right: 6,
                  bottom: 3,
                ),
                child: Text(
                  step,
                  style: sBodyText2Style.copyWith(
                    color: isDisabled ? colors.grey1 : colors.white,
                  ),
                ),
              ),
            ),
          ),
        ] else ...[
          const SBlueDoneIcon(),
        ],
        const SpaceW14(),
        if (haveSubText || haveLink) ...[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itemString,
                style: sSubtitle2Style,
              ),
              if (haveSubText) ...[
                const SpaceH4(),
                Text(
                  subtext ?? '',
                  maxLines: 2,
                  style: sBodyText2Style.copyWith(
                    color: colors.grey1,
                  ),
                ),
              ],
              if (haveLink) ...[
                const SpaceH12(),
                InkWell(
                  onTap: () {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1),
                        child: Text(
                          linkText ?? '',
                          style: sButtonTextStyle.copyWith(color: colors.blue),
                        ),
                      ),
                      const SpaceW4(),
                      const SBlueRightArrowIcon(),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ] else ...[
          Text(
            itemString,
            style: sSubtitle2Style.copyWith(
              color: isDisabled ? colors.grey1 : colors.black,
            ),
          ),
        ],
      ],
    );
  }
}
