import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/auth/register/store/referral_code_store.dart';
import 'package:jetwallet/features/auth/register/ui/widgets/referral_code/components/entered_valid_referal_code.dart';
import 'package:simple_kit/simple_kit.dart';

import 'components/invalid_referral_code.dart';
import 'components/loading_referral_code.dart';
import 'components/no_referral_code.dart';
import 'components/show_referral_code_link.dart';

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

    return Column(
      children: [
        referallStore.referralCodeValidation.maybeWhen(
          input: () {
            return NoReferralCode(
              onAddPressed: () {
                referallStore.resetBottomSheetReferralCodeValidation(
                  isOpening: true,
                );
                showReferralCode(context);
              },
            );
          },
          loading: () {
            return const SPaddingH24(
              child: LoadingReferralCode(),
            );
          },
          valid: () {
            return EnteredValidReferalCode(
              referralCode: referallStore.referralCode ?? '',
              onDelete: () {
                referallStore.clearReferralCode();
              },
            );
          },
          invalid: () {
            return InkWell(
              onTap: () {
                referallStore.resetBottomSheetReferralCodeValidation(
                  isOpening: true,
                );
                showReferralCode(context);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: InvalidReferralCode(),
              ),
            );
          },
          orElse: () {
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
