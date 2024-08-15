import 'package:jetwallet/core/router/app_router.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc/kyc_plan_responce_model.dart';

Future<void> startKycAidFlow(KycPlanResponceModel kycPlan) async {
  if (kycPlan.action == KycAction.chooseCountry) {
    await sRouter.popAndPush(
      KycAidChooseCountryRouter(
        initCountryCode: kycPlan.countryCode,
      ),
    );
  } else {
    await sRouter.popAndPush(
      KycAidWebViewRouter(
        url: kycPlan.url,
      ),
    );
  }
}
