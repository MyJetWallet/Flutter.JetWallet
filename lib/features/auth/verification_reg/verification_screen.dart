import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/features/auth/verification_reg/store/verification_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/di/di.dart';

@RoutePage(name: 'VerificationRouter')
class VerificationScreen extends StatefulObserverWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  void initState() {
    sAnalytics.verificationProfileScreenView();
    sAnalytics.kycFlowVerificationScreenView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final store = getIt<VerificationStore>();

    return SPageFrameWithPadding(
      loaderText: intl.loader_please_wait,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH64(),
          Align(
            alignment: Alignment.centerRight,
            child: SimpleBaseLinkText(
              active: true,
              name: intl.logout,
              onTap: () {
                sAnalytics.verificationProfileLogout();

                getIt<LogoutService>().logout(
                  'TWO FA, logout',
                  withLoading: false,
                  callbackAfterSend: () {},
                );

                getIt<AppRouter>().maybePop();
              },
              activeColor: colors.blue,
              inactiveColor: colors.grey4,
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
            isDone: store.isEmailDone,
          ),
          const SpaceH24(),
          if (store.showPhoneNumberSteep) ...[
            _verificationItem(
              intl.phone_number,
              '2',
              haveLink: !store.isPhoneDone,
              linkText: intl.provide_information,
              linkAction: () {
                sAnalytics.verificationProfileProvideInfo();
                sAnalytics.kycFlowProvideInformation();

                getIt<AppRouter>().maybePop();
              },
              isDisabled: !store.isPhoneDone && store.step != VerificationScreenStep.phone,
              isDone: store.isPhoneDone,
            ),
            const SpaceH24(),
          ],
          _verificationItem(
            intl.personal_details,
            store.showPhoneNumberSteep ? '3' : '2',
            haveSubText: store.step == VerificationScreenStep.personalDetail,
            haveLink: store.step == VerificationScreenStep.personalDetail,
            linkText: intl.provide_information,
            subtext: intl.personal_details_descr,
            linkAction: () {
              sAnalytics.verificationProfileProvideInfo();
              sAnalytics.kycFlowProvideInformation();

              getIt<AppRouter>().maybePop();
            },
            isDisabled: !store.isPersonalDetailsDone && store.step != VerificationScreenStep.personalDetail,
            isDone: store.isPersonalDetailsDone,
          ),
          const SpaceH24(),
          _verificationItem(
            intl.pin_code,
            store.showPhoneNumberSteep ? '4' : '3',
            haveSubText: store.step == VerificationScreenStep.pin,
            subtext: intl.pin_code_descr,
            haveLink: store.step == VerificationScreenStep.pin,
            linkText: intl.create_pin_code,
            linkAction: () {
              sAnalytics.verificationProfileCreatePIN();

              getIt<AppRouter>().maybePop();
            },
            isDisabled: !store.isCreatePinDone && store.step != VerificationScreenStep.pin,
            isDone: store.isCreatePinDone,
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
    Function()? linkAction,
    bool isDisabled = false,
  }) {
    final colors = sKit.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (isDisabled) const SpaceH3() else const SpaceH4(),
            if (!isDone) ...[
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: DecoratedBox(
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
              ),
            ] else ...[
              const SBlueDoneIcon(),
            ],
          ],
        ),
        const SpaceW14(),
        if (haveSubText || haveLink) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itemString,
                style: sSubtitle2Style,
              ),
              if (haveSubText) ...[
                const SpaceH4(),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Text(
                    subtext ?? '',
                    maxLines: 2,
                    style: sBodyText2Style.copyWith(
                      color: colors.grey1,
                    ),
                  ),
                ),
              ],
              if (haveLink) ...[
                const SpaceH12(),
                SLinkButtonText(
                  active: true,
                  name: linkText ?? '',
                  onTap: linkAction ?? () {},
                  defaultIcon: const SBlueRightArrowIcon(),
                  pressedIcon: SBlueRightArrowIcon(
                    color: colors.blue.withOpacity(0.8),
                  ),
                  inactiveIcon: const SBlueRightArrowIcon(),
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
