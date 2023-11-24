import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/pay_with_bottom_sheet.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

void showBuyAction({
  bool shouldPop = true,
  bool showRecurring = false,
  Source? from,
  CurrencyModel? currency,
  required BuildContext context,
}) {
  final kyc = getIt.get<KycService>();
  final handler = getIt.get<KycAlertHandler>();

  final isCardsAvailable = sSignalRModules.buyMethods.any((element) => element.id == PaymentMethodType.bankCard);

  final isSimpleAccountAvaible =
      (sSignalRModules.paymentProducts?.any((element) => element.id == AssetPaymentProductsEnum.simpleIbanAccount) ??
              false) &&
          sSignalRModules.bankingProfileData?.simple?.account != null;

  final isBankingAccountsAvaible =
      (sSignalRModules.paymentProducts?.any((element) => element.id == AssetPaymentProductsEnum.bankingIbanAccount) ??
              false) &&
          (sSignalRModules.bankingProfileData?.banking?.accounts ?? []).isNotEmpty;

  final isBuyAvaible = isCardsAvailable || isSimpleAccountAvaible || isBankingAccountsAvaible;

  final isDepositBlocker =
      sSignalRModules.clientDetail.clientBlockers.any((element) => element.blockingType == BlockingType.deposit);

  if ((kyc.tradeStatus == kycOperationStatus(KycStatus.blocked)) || !isBuyAvaible) {
    if (shouldPop) Navigator.pop(context);
    sNotification.showError(
      intl.operation_bloked_text,
      duration: 4,
      id: 1,
      hideIcon: true,
    );
  } else if ((kyc.depositStatus == kycOperationStatus(KycStatus.blocked)) &&
      !(sSignalRModules.bankingProfileData?.isAvaibleAnyAccount ?? false)) {
    if (shouldPop) Navigator.pop(context);
    sNotification.showError(
      intl.operation_bloked_text,
      duration: 4,
      id: 1,
      hideIcon: true,
    );
  } else if (isDepositBlocker) {
    _showAction(
      context: context,
      blockingTypeCheck: BlockingType.deposit,
    );
  } else if (isBuyAvaible) {
    _showAction(context: context);
  } else {
    handler.handle(
      status: kyc.tradeStatus,
      isProgress: kyc.verificationInProgress,
      currentNavigate: () => _showAction(context: context),
      requiredDocuments: kyc.requiredDocuments,
      requiredVerifications: kyc.requiredVerifications,
    );
  }
}

void _showAction({
  required BuildContext context,
  BlockingType blockingTypeCheck = BlockingType.trade,
}) {
  sAnalytics.newBuyChooseAssetView();

  showSendTimerAlertOr(
    context: context,
    or: () {
      sRouter.push(
        ChooseAssetRouter(
          onChooseAsset: (currency) {
            showPayWithBottomSheet(
              context: context,
              currency: currency,
            );
          },
        ),
      );
    },
    from: [blockingTypeCheck],
  );
}
