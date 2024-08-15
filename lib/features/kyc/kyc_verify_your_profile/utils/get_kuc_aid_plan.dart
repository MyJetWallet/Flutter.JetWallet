import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/ui/kyc_aid_webview_screen.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc/kyc_plan_responce_model.dart';

Future<KycPlanResponceModel?> getKYCAidPlan() async {
  KycPlanResponceModel? kycPlan;
  try {
    final response = await sNetwork.getWalletModule().postKycPlan();
    response.pick(
      onData: (data) {
        kycPlan = data;

        loadKycAidWebViewController(url: kycPlan?.url ?? '', preload: true);
      },
      onError: (error) {
        sNotification.showError(
          error.cause,
          id: 1,
        );
      },
    );
  } catch (e) {
    sNotification.showError(
      intl.something_went_wrong_try_again,
      id: 1,
    );
  }
  return kycPlan;
}
