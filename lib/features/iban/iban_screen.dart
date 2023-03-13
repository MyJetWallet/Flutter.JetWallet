import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/iban/widgets/iban_body.dart';
import 'package:jetwallet/features/iban/widgets/iban_empty.dart';
import 'package:jetwallet/features/iban/widgets/iban_header.dart';
import 'package:simple_kit/modules/shared/page_frames/simple_page_frame.dart';

import '../../core/di/di.dart';
import '../../core/l10n/i10n.dart';
import '../../core/router/app_router.dart';
import '../../utils/helpers/check_kyc_status.dart';
import '../kyc/kyc_service.dart';

class IBanScreen extends StatelessObserverWidget {
  const IBanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kycState = getIt.get<KycService>();

    final kycPassed = checkKycPassed(
      kycState.depositStatus,
      kycState.sellStatus,
      kycState.withdrawalStatus,
    );
    final kycBlocked = checkKycBlocked(
      kycState.depositStatus,
      kycState.sellStatus,
      kycState.withdrawalStatus,
    );
    final verificationInProgress = kycState.inVerificationProgress;

    final isLoading = kycBlocked || verificationInProgress;
    final isAddress = kycPassed;
    final isKyc = !kycPassed && !kycBlocked && !verificationInProgress;

    final showEmptyScreen = false;

    final textForShare = 'false';

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: IBanHeader(
        isShareActive: !showEmptyScreen,
        textForShare: textForShare,
      ),
      child: showEmptyScreen ? IBanEmpty(
        isLoading: isLoading,
        isAddress: isAddress,
        isKyc: isKyc,
        onButtonTap: () {
          if (isKyc) {

          } else {
            sRouter.push(
              CrispRouter(
                welcomeText: intl.crispSendMessage_hi,
              ),
            );
          }
        },
      ) : IBanBody(
        name: 'John Doe',
        iban: 'FR14 2004 1010 0505 0001 3M02 606 0505 0001 3M02 606',
        bic: 'ACTVPTPL',
      ),
    );
  }
}
