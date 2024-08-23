import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/cj_banking_accounts/store/account_withdraw_to_store.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/withdrawal_banking/helpers/show_bank_transfer_select.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

import '../../app/store/app_store.dart';

void showAccountWithdrawToSelector({
  required BuildContext context,
  required VoidCallback onClose,
  required SimpleBankingAccount bankingAccount,
}) {
  final store = AccountWithdrawToStore()..init(bankingAccount: bankingAccount);

  sShowBasicModalBottomSheet(
    context: context,
    pinned: SBottomSheetHeader(
      name: intl.withdraw_to,
    ),
    scrollable: true,
    onDissmis: onClose,
    children: [
      _WithdrawToBody(
        store: store,
      ),
    ],
  );
}

class _WithdrawToBody extends StatelessWidget {
  const _WithdrawToBody({
    required this.store,
  });

  final AccountWithdrawToStore store;

  @override
  Widget build(BuildContext context) {
    final kycState = getIt.get<KycService>();

    return Column(
      children: [
        STextDivider(intl.external_method),
        SimpleTableAsset(
          label: intl.bankAccountsSelectPopupTitle,
          supplement: intl.external_transfer,
          assetIcon: Assets.svg.assets.fiat.externalTransfer.simpleSvg(
            width: 24,
          ),
          hasRightValue: false,
          onTableAssetTap: () {
            final isCJAccount = store.account?.isClearjuctionAccount ?? true;
            sAnalytics.eurWithdrawTapOnTheButtonWithdraw(
              isCJ: isCJAccount,
              accountIban: store.account?.iban ?? '',
              accountLabel: store.account?.label ?? '',
            );

            if (kycState.withdrawalStatus == kycOperationStatus(KycStatus.blocked)) {
              sNotification.showError(
                intl.operation_bloked_text,
                id: 1,
                needFeedback: true,
              );

              return;
            }

            showSendTimerAlertOr(
              context: context,
              from: [BlockingType.withdrawal],
              or: () {
                sAnalytics.eurWithdrawBankTransferWithEurSheet(
                  isCJAccount: isCJAccount,
                  accountIban: store.account?.iban ?? '',
                  accountLabel: store.account?.label ?? '',
                );

                showBankTransforSelect(context, store.account!, isCJAccount);
              },
            );
          },
        ),
        if (store.isAccountsAvaible && store.accounts.isNotEmpty) ...[
          STextDivider(intl.deposit_by_accounts),
          for (final account in store.accounts)
            SimpleTableAsset(
              label: account.label ?? 'Account 1',
              supplement:
                  account.isClearjuctionAccount ? intl.eur_wallet_simple_account : intl.eur_wallet_personal_account,
              rightValue: getIt<AppStore>().isBalanceHide
                  ? '**** ${account.currency ?? 'EUR'}'
                  : (account.balance ?? Decimal.zero).toFormatSum(
                      accuracy: 2,
                      symbol: account.currency ?? 'EUR',
                    ),
              assetIcon: Assets.svg.assets.fiat.account.simpleSvg(
                width: 24,
              ),
              onTableAssetTap: () {
                sRouter.push(
                  AmountRoute(
                    tab: AmountScreenTab.transfer,
                    toAccount: account,
                    fromAccount: store.account,
                  ),
                );
              },
            ),
        ],
        if (store.isCardsAvaible && store.cards.isNotEmpty) ...[
          STextDivider(intl.deposit_by_cards),
          for (final card in store.cards)
            SimpleTableAsset(
              label: card.label ?? 'Simple card',
              supplement: '${card.cardType.frontName} ••• ${card.last4NumberCharacters}',
              rightValue: getIt<AppStore>().isBalanceHide
                  ? '**** ${card.currency ?? 'EUR'}'
                  : (card.balance ?? Decimal.zero).toFormatSum(
                      accuracy: 2,
                      symbol: card.currency ?? 'EUR',
                    ),
              isCard: true,
              onTableAssetTap: () {
                sRouter.push(
                  AmountRoute(
                    tab: AmountScreenTab.transfer,
                    toCard: card,
                    fromAccount: store.account,
                  ),
                );
              },
            ),
        ],
        const SpaceH42(),
      ],
    );
  }
}
