import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/rewards_flow/store/rewards_flow_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/rewards_profile_model.dart';

class RewardsBalancesCell extends StatelessObserverWidget {
  const RewardsBalancesCell({super.key});

  @override
  Widget build(BuildContext context) {
    final store = RewardsFlowStore.of(context);

    return SPaddingH24(
      child: Column(
        children: [
          for (final balance in store.balances)
            if (balance.amount != Decimal.zero)
              _BalanceCell(
                data: balance,
              ),
        ],
      ),
    );
  }
}

class _BalanceCell extends StatefulWidget {
  const _BalanceCell({
    super.key,
    required this.data,
  });

  final RewardsBalance data;

  @override
  State<_BalanceCell> createState() => _BalanceCellState();
}

class _BalanceCellState extends State<_BalanceCell> {
  bool isClaimButtonActive = true;

  @override
  Widget build(BuildContext context) {
    final curr = getIt.get<FormatService>().findCurrency(
          findInHideTerminalList: true,
          assetSymbol: widget.data.assetSymbol ?? 'BTC',
        );

    final fAmount = volumeFormat(
      prefix: curr.prefixSymbol,
      decimal: widget.data.amount,
      accuracy: curr.accuracy,
      symbol: curr.symbol,
    );

    return InkWell(
      onTap: () {
        sShowAlertPopup(
          sRouter.navigatorKey.currentContext!,
          image: Container(
            width: 80,
            height: 80,
            decoration: const ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.51, -0.86),
                end: Alignment(-0.51, 0.86),
                colors: [Color(0xFFCBB9FF), Color(0xFF9575F3)],
              ),
              shape: OvalBorder(),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: SRewardTrophyIcon(),
            ),
          ),
          isNeedPrimaryButton: isClaimButtonActive,
          primaryText:
              '${intl.reward_transfer} $fAmount \n${intl.reward_to_my_account}',
          primaryButtonName: intl.reward_transfer,
          secondaryButtonName: intl.reward_cancel,
          onPrimaryButtonTap: () async {
            setState(() {
              isClaimButtonActive = false;
            });

            final response = await sNetwork.getWalletModule().postRewardClaim(
                  data: widget.data,
                );

            Navigator.pop(
              sRouter.navigatorKey.currentContext!,
            );

            if (!response.hasError) {
              showSuccessRewardSheet(fAmount);
            } else {
              sNotification.showError(response.error?.cause ?? '', id: 1);
            }
          },
          onSecondaryButtonTap: () => Navigator.pop(
            sRouter.navigatorKey.currentContext!,
          ),
        );
      },
      child: Column(
        children: [
          const SpaceH22(),
          Row(
            children: [
              SNetworkCachedSvg(
                url: curr.iconUrl,
                width: 24,
                height: 24,
                placeholder: const SizedBox.shrink(),
              ),
              const SpaceW12(),
              Padding(
                padding: const EdgeInsets.only(bottom: 3.5),
                child: Text(
                  curr.description,
                  style: sSubtitle2Style,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: sKit.colors.grey4),
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: SRewardTrophyIcon(color: sKit.colors.confetti1),
                    ),
                    const SpaceW10(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        volumeFormat(
                          prefix: curr.prefixSymbol,
                          decimal: widget.data.amount,
                          accuracy: curr.accuracy,
                          symbol: curr.symbol,
                        ),
                        textAlign: TextAlign.right,
                        style: sSubtitle2Style,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SpaceH20(),
          const Divider(),
        ],
      ),
    );
  }
}

void showSuccessRewardSheet(String fAmout) {
  sShowAlertPopup(
    sRouter.navigatorKey.currentContext!,
    image: Image.asset(
      simpleCheckboxLogo,
      width: 80,
      height: 80,
    ),
    primaryText: intl.reward_success,
    secondaryText: '$fAmout ${intl.reward_tranfered_to_my_assets}',
    primaryButtonName: intl.reward_got_it,
    onPrimaryButtonTap: () {
      Navigator.pop(sRouter.navigatorKey.currentContext!);
    },
    onSecondaryButtonTap: () =>
        Navigator.pop(sRouter.navigatorKey.currentContext!),
  );
}
