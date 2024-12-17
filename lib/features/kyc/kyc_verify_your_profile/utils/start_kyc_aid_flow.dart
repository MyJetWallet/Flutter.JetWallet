import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc/kyc_plan_responce_model.dart';

Future<void> startKycAidFlow({
  required KycPlanResponceModel kycPlan,
  bool isCardFlow = false,
}) async {
  if (kycPlan.action == KycAction.chooseCountry) {
    await sRouter.push(
      KycAidChooseCountryRouter(
        initCountryCode: kycPlan.countryCode,
        isCardFlow: isCardFlow,
      ),
    );
  } else if (kycPlan.action == KycAction.webView) {
    await sRouter.push(
      KycAidWebViewRouter(
        url: kycPlan.url,
      ),
    );
  } else if (kycPlan.action == KycAction.block) {
    sNotification.showError(
      intl.operation_bloked_text,
      id: 3,
    );
  } else if (kycPlan.action == KycAction.inProcess) {
    final kycAlertHandler = getIt.get<KycAlertHandler>();
    kycAlertHandler.showVerifyingAlert();
  }
}
