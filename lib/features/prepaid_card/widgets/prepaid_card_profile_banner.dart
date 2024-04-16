import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

class PrepaidCardProfileBanner extends StatelessWidget {
  const PrepaidCardProfileBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Observer(
      builder: (context) {
        final isPrepaidCardAvaible = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[])
            .any((element) => element.id == AssetPaymentProductsEnum.prepaidCard);
        return !isPrepaidCardAvaible
            ? const Offstage()
            : GestureDetector(
                onTap: () {
                  sAnalytics.tapOnTheBunnerPrepaidCardsOnProfile();

                  final kycState = getIt.get<KycService>();
                  final handler = getIt.get<KycAlertHandler>();

                  handler.handle(
                    multiStatus: [
                      kycState.withdrawalStatus,
                    ],
                    isProgress: kycState.verificationInProgress,
                    currentNavigate: () {
                      showSendTimerAlertOr(
                        context: context,
                        from: [BlockingType.withdrawal],
                        or: () {
                          sRouter.push(const PrepaidCardServiceRouter());
                        },
                      );
                    },
                    requiredDocuments: kycState.requiredDocuments,
                    requiredVerifications: kycState.requiredVerifications,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  margin: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 24,
                  ),
                  decoration: ShapeDecoration(
                    color: colors.extraLightsBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            intl.prepaid_card_prepaid_card,
                            style: STStyles.body1Bold,
                          ),
                          Text(
                            intl.prepaid_card_buy_for_cryptocurrency,
                            style: STStyles.body1Medium,
                          ),
                        ],
                      ),
                      Assets.svg.brand.small.card.simpleSvg(
                        width: 48,
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
