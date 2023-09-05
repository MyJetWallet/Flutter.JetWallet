import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/auth/register/store/referral_code_store.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import 'components/invalid_referral_code.dart';
import 'components/loading_referral_code.dart';
import 'components/no_referral_code.dart';
import 'components/show_referral_code_link.dart';
import 'components/valid_referral_code.dart';

/*
class ReferralCode extends StatelessWidget {
  const ReferralCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<ReferallCodeStore>(
      create: (context) => ReferallCodeStore()..init(),
      builder: (context, child) => const ReferralCodeBody(),
      dispose: (context, state) => state.dispose(),
    );
  }
}
*/

class ReferralCode extends StatefulObserverWidget {
  const ReferralCode({super.key});

  @override
  State<ReferralCode> createState() => _ReferralCodeState();
}

class _ReferralCodeState extends State<ReferralCode> {
  @override
  void initState() {
    getIt.get<ReferallCodeStore>().init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final referallStore = getIt.get<ReferallCodeStore>();

    return SPaddingH24(
      child: GestureDetector(
        onTap: () {
          sAnalytics.signInFlowPersonalReferralLink();

          referallStore.resetBottomSheetReferralCodeValidation(
            isOpening: true,
          );
          showReferralCode(context);
        },
        child: Column(
          children: [
            referallStore.referralCodeValidation.maybeWhen(
              input: () {
                return const NoReferralCode();
              },
              loading: () {
                return const LoadingReferralCode();
              },
              valid: () {
                return ValidReferralCodeInside(
                  referralCode: referallStore.referralCode,
                );
              },
              invalid: () {
                return const InvalidReferralCode();
              },
              orElse: () {
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
