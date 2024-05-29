import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

import '../../../../core/di/di.dart';
import '../../../../core/l10n/i10n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../utils/models/currency_model.dart';
import '../../../actions/action_send/widgets/show_send_timer_alert_or.dart';
import '../../../kyc/helper/kyc_alert_handler.dart';
import '../../../kyc/kyc_service.dart';
import '../../../kyc/models/kyc_operation_status_model.dart';
import 'my_wallet.dart';

class InvestHeader extends StatelessObserverWidget {
  const InvestHeader({
    super.key,
    required this.currency,
    this.withBigPadding = true,
    this.withBackBlock = false,
    this.hideWallet = false,
    this.withDivider = true,
    this.onBackButton,
  });

  final CurrencyModel currency;
  final bool withBigPadding;
  final bool withBackBlock;
  final bool hideWallet;
  final bool withDivider;
  final Function()? onBackButton;

  @override
  Widget build(BuildContext context) {
    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    final colors = sKit.colors;

    return Column(
      children: [
        if (withBigPadding) const SpaceH64() else const SpaceH8(),
        Row(
          children: [
            if (!withBackBlock)
              Text(
                intl.invest_title,
                style: STStyles.header4SMInvest.copyWith(
                  color: colors.black,
                ),
              )
            else
              SIconButton(
                defaultIcon: const SBackIcon(),
                pressedIcon: const SBackIcon(),
                onTap: () {
                  onBackButton?.call();
                },
              ),
            const Spacer(),
            if (!hideWallet)
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  if (kycState.tradeStatus == kycOperationStatus(KycStatus.allowed)) {
                    showSendTimerAlertOr(
                      context: context,
                      or: () => sRouter.push(
                        const InvestTransferRoute(),
                      ),
                      from: [BlockingType.trade],
                    );
                  } else {
                    kycAlertHandler.handle(
                      status: kycState.tradeStatus,
                      isProgress: kycState.verificationInProgress,
                      currentNavigate: () => showSendTimerAlertOr(
                        context: context,
                        or: () => sRouter.push(
                          const InvestTransferRoute(),
                        ),
                        from: [BlockingType.trade],
                      ),
                      requiredDocuments: kycState.requiredDocuments,
                      requiredVerifications: kycState.requiredVerifications,
                    );
                  }
                },
                child: MyWallet(currency: currency),
              ),
          ],
        ),
        const SpaceH8(),
        if (withDivider)
          Container(
            height: 0.5,
            decoration: BoxDecoration(
              color: colors.grey4,
            ),
          ),
      ],
    );
  }
}
