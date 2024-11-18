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
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/rewards_profile_model.dart';

import '../../../app/store/app_store.dart';

class RewardsBalancesCell extends StatelessObserverWidget {
  const RewardsBalancesCell({super.key});

  @override
  Widget build(BuildContext context) {
    final store = RewardsFlowStore.of(context);

    final validBalances = store.balances.where((element) => element.amount != Decimal.zero);

    return SPaddingH24(
      child: Column(
        children: [
          for (final balance in validBalances)
            if (balance.amount != Decimal.zero)
              _BalanceCell(
                data: balance,
                needSeparator: validBalances.last != balance,
              ),
        ],
      ),
    );
  }
}

class _BalanceCell extends StatefulWidget {
  const _BalanceCell({
    required this.data,
    this.needSeparator = true,
  });

  final RewardsBalance data;
  final bool needSeparator;

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

    final fAmount = widget.data.amount.toFormatCount(
      accuracy: curr.accuracy,
      symbol: curr.symbol,
    );

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: SColorsLight().gray2,
      hoverColor: Colors.transparent,
      onTap: () {
        showDialog(
          context: sRouter.navigatorKey.currentContext!,
          builder: (context) => RewardTransferPopup(
            data: widget.data,
            fAmount: fAmount,
          ),
        );
      },
      child: Column(
        children: [
          const SpaceH22(),
          SizedBox(
            height: 44,
            child: Row(
              children: [
                NetworkIconWidget(
                  curr.iconUrl,
                  placeholder: const SizedBox.shrink(),
                ),
                const SpaceW12(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.5),
                  child: Text(
                    curr.description,
                    style: STStyles.subtitle1,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: SColorsLight().gray4),
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: SRewardTrophyIcon(color: Color(0xFF9575F3)),
                      ),
                      const SpaceW10(),
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Observer(
                          builder: (BuildContext context) {
                            return Text(
                              getIt<AppStore>().isBalanceHide
                                  ? '**** ${curr.symbol}'
                                  : widget.data.amount.toFormatCount(
                                      accuracy: curr.accuracy,
                                      symbol: curr.symbol,
                                    ),
                              textAlign: TextAlign.right,
                              style: STStyles.subtitle1.copyWith(
                                height: 1,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.needSeparator) ...[
            const SpaceH20(),
            const SDivider(),
          ] else ...[
            const SpaceH22(),
          ],
        ],
      ),
    );
  }
}

void showSuccessRewardSheet(String assetSymbol, String amount, String fAmout) {
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
    onSecondaryButtonTap: () => Navigator.pop(sRouter.navigatorKey.currentContext!),
  );
}

class RewardTransferPopup extends StatefulWidget {
  const RewardTransferPopup({
    super.key,
    required this.data,
    required this.fAmount,
  });

  final RewardsBalance data;
  final String fAmount;

  @override
  State<RewardTransferPopup> createState() => _RewardTransferPopupState();
}

class _RewardTransferPopupState extends State<RewardTransferPopup> {
  bool isClaimButtonActive = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Dialog(
          insetPadding: const EdgeInsets.all(24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Column(
              children: [
                const SpaceH40(),
                Container(
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
                Baseline(
                  baseline: 40.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    '${intl.reward_transfer} ${widget.fAmount} \n${intl.reward_to_my_account}',
                    maxLines: 12,
                    textAlign: TextAlign.center,
                    style: STStyles.header6.copyWith(
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
                const SpaceH36(),
                //if (isClaimButtonActive) ...[
                SButton.black(
                  text: isClaimButtonActive ? intl.reward_transfer : '',
                  isLoading: !isClaimButtonActive,
                  callback: isClaimButtonActive
                      ? () async {
                          setState(() {
                            isClaimButtonActive = false;
                          });
                          try {
                            final response = await sNetwork.getWalletModule().postRewardClaim(
                                  data: widget.data,
                                );
                            setState(() {
                              isClaimButtonActive = true;
                            });

                            Navigator.pop(sRouter.navigatorKey.currentContext!);

                            if (!response.hasError) {
                              showSuccessRewardSheet(
                                widget.data.assetSymbol ?? '',
                                '${widget.data.amount}',
                                widget.fAmount,
                              );
                            } else {
                              sNotification.showError(
                                response.error?.cause ?? intl.something_went_wrong,
                                id: 1,
                              );
                            }
                          } catch (e) {
                            Navigator.pop(sRouter.navigatorKey.currentContext!);
                            sNotification.showError(
                              intl.something_went_wrong_try_again,
                              id: 1,
                            );

                            return;
                          }
                        }
                      : null,
                ),
                //] else ...[
                //  const LoaderSpinner(),
                //],
                const SpaceH10(),
                SButton.text(
                  text: intl.reward_cancel,
                  callback: () {
                    Navigator.pop(sRouter.navigatorKey.currentContext!);
                  },
                ),
                const SpaceH20(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
