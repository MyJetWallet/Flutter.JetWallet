import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/crypto_jar/store/create_jar_store.dart';
import 'package:jetwallet/features/crypto_jar/store/jars_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/my_wallets/helper/show_wallet_verify_account.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:simple_analytics/simple_analytics.dart';

class CreateJarButtonWidget extends StatelessWidget {
  const CreateJarButtonWidget({
    required this.isAddButtonDisabled,
    required this.scrollToTitle,
    super.key,
  });

  final bool isAddButtonDisabled;
  final Function()? scrollToTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        bottom: 40.0,
        left: 24.0,
        right: 24.0,
      ),
      child: SButtonContext(
        type: SButtonContextType.iconedSmall,
        text: intl.jar_add_jar,
        isDisabled: isAddButtonDisabled,
        onTap: () {
          void func() {
            getIt.get<CreateJarStore>().getJarGoalLimit();

            if (scrollToTitle != null) {
              scrollToTitle!.call();
            }

            getIt<AppRouter>().push(EnterJarNameRouter());
          }

          if (scrollToTitle != null) {
            getIt.get<EventBus>().fire(EndReordering());
          }

          getIt.get<JarsStore>().refreshJarsStore();

          sAnalytics.jarTapOnButtonAddCryptoJarOnDashboard();

          final kycState = getIt.get<KycService>();
          if (checkKycPassed(
            kycState.depositStatus,
            kycState.tradeStatus,
            kycState.withdrawalStatus,
          )) {
            func();
          } else {
            final kycHandler = getIt.get<KycAlertHandler>();

            if (kycState.depositStatus == kycOperationStatus(KycStatus.kycInProgress)) {
              kycHandler.handle(
                status: kycState.depositStatus,
                isProgress: kycState.verificationInProgress,
                currentNavigate: () {},
                requiredDocuments: kycState.requiredDocuments,
                requiredVerifications: kycState.requiredVerifications,
              );
            } else {
              showWalletVerifyAccount(
                context,
                after: () {
                  func();
                },
                isBanking: false,
              );
            }
          }
        },
      ),
    );
  }
}
