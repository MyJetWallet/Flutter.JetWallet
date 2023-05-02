import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/actions/action_send/action_send.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

void showSendOptions(
  BuildContext context,
  CurrencyModel currency, {
  bool navigateBack = true,
}) {
  if (navigateBack) {
    Navigator.pop(context);
  }

  showSendTimerAlertOr(
    context: context,
    or: () => sShowBasicModalBottomSheet(
      context: context,
      then: (value) {},
      pinned: SBottomSheetHeader(
        name: intl.sendOptions_sendTo,
      ),
      children: [
        _SendOptions(
          currency: currency,
        ),
      ],
    ),
    from: BlockingType.withdrawal,
  );
}

class _SendOptions extends StatelessObserverWidget {
  const _SendOptions({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (currency.supportsByPhoneNicknameWithdrawal)
          SActionItem(
            icon: const SPhoneIcon(),
            name: intl.sendOptions_actionItemName1,
            description: intl.sendOptions_actionItemDescription1,
            onTap: () {
              sRouter.navigate(
                SendByPhoneInputRouter(
                  currency: currency,
                ),
              );
            },
          ),
        if (currency.supportsByAssetWithdrawal)
          SActionItem(
            icon: const SWallet2Icon(),
            name: intl.sendOptions_actionItemName2,
            description: intl.sendOptions_actionItemDescription2,
            onTap: () {
              Navigator.pop(context);

              sRouter.push(
                WithdrawRouter(
                  withdrawal: WithdrawalModel(
                    currency: currency,
                  ),
                ),
              );
            },
          ),
        if (currency.supportsByAssetWithdrawal)
          SActionItem(
            icon: const SWallet2Icon(),
            name: intl.sendOptions_actionItemName2,
            description: intl.sendOptions_actionItemDescription2,
            onTap: () {
              Navigator.pop(context);

              sRouter.push(
                WithdrawRouter(
                  withdrawal: WithdrawalModel(
                    currency: currency,
                  ),
                ),
              );
            },
          ),
        if (currency.supporGlobalSendWithdrawal)
          SActionItem(
            icon: const SNetworkIcon(),
            name: intl.global_send_name,
            description: intl.global_send_helper,
            onTap: () {
              Navigator.pop(context);

              showSendGlobally(context);
            },
          ),
        if (currency.supportIbanSendWithdrawal)
          SActionItem(
            icon: const SAccountIcon(),
            name: intl.iban_send_name,
            description: intl.iban_send_helper,
            onTap: () async {
              Navigator.pop(context);

              sRouter.popUntilRoot();

              await sRouter.replaceAll(
                [
                  HomeRouter(
                    children: [
                      IBanRouter(
                        initIndex: 1,
                      ),
                    ],
                  ),
                ],
              );

              if (getIt<AppStore>().tabsRouter != null) {
                getIt<AppStore>().tabsRouter!.setActiveIndex(2);

                if (getIt.get<IbanStore>().ibanTabController != null) {
                  getIt.get<IbanStore>().ibanTabController!.animateTo(
                        1,
                      );
                }
              }
            },
          ),
        const SpaceH40(),
      ],
    );
  }
}
