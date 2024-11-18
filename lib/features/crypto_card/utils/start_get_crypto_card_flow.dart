import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/crypto_card/utils/show_crypto_card_acknowledgment_bottom_sheet.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

Future<void> startGetCryptoCardFlow() async {
  final kycState = getIt.get<KycService>();
  final kycAlertHandler = getIt.get<KycAlertHandler>();

  if (kycState.verificationRequired) {
    final context = sRouter.navigatorKey.currentContext;
    if (context == null) return;
    await sShowAlertPopup(
      context,
      primaryText: '',
      secondaryText: intl.simple_card_account_verification,
      primaryButtonName: intl.simple_card_verify_account,
      onPrimaryButtonTap: () async {
        await sRouter.maybePop();
        await showCryptoCardAcknowledgmentBottomSheet(context);
      },
      secondaryButtonName: intl.wallet_cancel,
      onSecondaryButtonTap: () {
        sRouter.maybePop();
      },
    );
  } else {
    kycAlertHandler.handleKycBanner(
      status: kycState.depositStatus,
      isProgress: kycState.verificationInProgress,
      currentNavigate: () async {
        final context = sRouter.navigatorKey.currentContext;
        if (context == null) return;
        await showCryptoCardAcknowledgmentBottomSheet(context);
      },
      requiredDocuments: kycState.requiredDocuments,
      requiredVerifications: kycState.requiredVerifications,
      customBlockerText: intl.profile_kyc_bloked_alert,
    );
  }
}
