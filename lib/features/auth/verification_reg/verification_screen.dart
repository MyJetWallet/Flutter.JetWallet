import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/features/auth/verification_reg/store/verification_store.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/ui/widgets/verify_step.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/shared/simple_safe_button_padding.dart';

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
    final colors = SColorsLight();

    final store = getIt<VerificationStore>();

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      header: GlobalBasicAppBar(
        hasLeftIcon: false,
        rightIcon: SafeGesture(
          onTap: () {
            sAnalytics.verificationProfileLogout();

            getIt<LogoutService>().logout(
              'TWO FA, logout',
              withLoading: false,
              callbackAfterSend: () {},
            );

            getIt<AppRouter>().maybePop();
          },
          child: Text(
            intl.logout,
            style: STStyles.subtitle2.copyWith(color: colors.blue),
          ),
        ),
      ),
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    logoGradientRounded,
                    width: 80,
                    height: 80,
                  ),
                  const SpaceH24(),
                  Text(
                    intl.verification_your_profile,
                    textAlign: TextAlign.left,
                    style: STStyles.header5,
                    maxLines: 2,
                  ),
                  const SpaceH8(),
                  Text(
                    intl.verification_your_profile_descr,
                    textAlign: TextAlign.left,
                    maxLines: 4,
                    style: STStyles.body1Medium.copyWith(color: colors.gray10),
                  ),
                  const SpaceH24(),
                  VerificationSteep(
                    lable: intl.email_verification,
                    isDone: store.isEmailDone,
                  ),
                  if (store.showPhoneNumberSteep) ...[
                    VerificationSteep(
                      lable: intl.phone_number,
                      isDisabled: !store.isPhoneDone && store.step != VerificationScreenStep.phone,
                      isDone: store.isPhoneDone,
                    ),
                  ],
                  VerificationSteep(
                    lable: intl.personal_details,
                    subtext: store.step == VerificationScreenStep.personalDetail ? intl.personal_details_descr : null,
                    isDisabled: !store.isPersonalDetailsDone && store.step != VerificationScreenStep.personalDetail,
                    isDone: store.isPersonalDetailsDone,
                  ),
                  VerificationSteep(
                    lable: intl.pin_code,
                    subtext: store.step == VerificationScreenStep.pin ? intl.pin_code_descr : null,
                    isDisabled: !store.isCreatePinDone && store.step != VerificationScreenStep.pin,
                    isDone: store.isCreatePinDone,
                  ),
                  const Spacer(),
                  SafeArea(
                    child: SSafeButtonPadding(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8), // отступ кнопки (8)
                        child: SButton.blue(
                          text: intl.provide_information,
                          callback: () {
                            getIt<AppRouter>().maybePop();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
