import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/auth/register/store/referral_code_store.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

import 'components/invalid_referral_code.dart';
import 'components/loading_referral_code.dart';
import 'components/no_referral_code.dart';
import 'components/show_referral_code_link.dart';
import 'components/valid_referral_code.dart';

class ReferralCode extends StatelessWidget {
  const ReferralCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<ReferallCodeStore>(
      create: (context) => ReferallCodeStore(),
      builder: (context, child) => const ReferralCodeBody(),
      dispose: (context, state) => state.dispose(),
    );
  }
}

class ReferralCodeBody extends StatelessObserverWidget {
  const ReferralCodeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: GestureDetector(
        onTap: () {
          ReferallCodeStore.of(context)
              .resetBottomSheetReferralCodeValidation();
          showReferralCode(context);
        },
        child: Column(
          children: [
            ReferallCodeStore.of(context).referralCodeValidation.maybeWhen(
              input: () {
                return const NoReferralCode();
              },
              loading: () {
                return const LoadingReferralCode();
              },
              valid: () {
                return ValidReferralCodeInside(
                  referralCode: ReferallCodeStore.of(context).referralCode,
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
