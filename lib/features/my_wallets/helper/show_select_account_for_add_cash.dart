import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_receive/action_receive.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/cj_banking_accounts/widgets/show_account_deposit_by_bottom_sheet.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/simple_card/ui/widgets/show_simple_card_deposit_by_bottom_sheet.dart';
import 'package:jetwallet/utils/balances/crypto_balance.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';

import '../../app/store/app_store.dart';

Future<void> showSelectAccountForAddCash(BuildContext context) async {
  final kycState = getIt.get<KycService>();
  final handler = getIt.get<KycAlertHandler>();

  final isSimpleKyc = kycState.isSimpleKyc;

  if (kycState.depositStatus == kycOperationStatus(KycStatus.blocked)) {
    sNotification.showError(
      intl.operation_bloked_text,
      id: 1,
      needFeedback: true,
    );

    sAnalytics.errorDepositIsUnavailable();

    return;
  }

  if (isSimpleKyc) {
    _showDepositToBottomSheet(context);
  } else {
    handler.handle(
      status: kycState.depositStatus,
      isProgress: kycState.verificationInProgress,
      currentNavigate: () => showSendTimerAlertOr(
        context: context,
        or: () {
          _showDepositToBottomSheet(context);
        },
        from: [BlockingType.deposit],
      ),
      requiredDocuments: kycState.requiredDocuments,
      requiredVerifications: kycState.requiredVerifications,
    );
  }
}

void _showDepositToBottomSheet(BuildContext context) {
  sAnalytics.depositToScreenView();

  showSendTimerAlertOr(
    context: context,
    from: [BlockingType.deposit],
    or: () async {
      sShowBasicModalBottomSheet(
        context: context,
        pinned: SBottomSheetHeader(
          name: intl.add_cash_to,
        ),
        scrollable: true,
        children: [
          const SpaceH12(),
          const _ShowSelectAccountForAddCash(),
          const SpaceH42(),
        ],
      );
    },
  );
}

class _ShowSelectAccountForAddCash extends StatelessObserverWidget {
  const _ShowSelectAccountForAddCash();

  @override
  Widget build(BuildContext context) {
    final eurCurrency = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    ).where((element) => element.symbol == 'EUR').first;

    final bankAccounts = sSignalRModules.bankingProfileData?.banking?.accounts ?? <SimpleBankingAccount>[];
    final simpleAccount = sSignalRModules.bankingProfileData?.simple?.account;

    final cards = sSignalRModules.bankingProfileData?.banking?.cards
            ?.where(
              (element) => element.status == AccountStatusCard.active,
            )
            .toList() ??
        [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        STextDivider(intl.sell_amount_accounts),
        SimpleTableAsset(
          assetIcon: Assets.svg.assets.crypto.defaultPlaceholder.simpleSvg(
            width: 24,
          ),
          label: intl.wallet_crypto_wallet,
          supplement: intl.wallet_crypto_assets,
          onTableAssetTap: () {
            showReceiveAction(context);
          },
          rightValue: !getIt<AppStore>().isBalanceHide
              ? calculateCryptoBalance()
              : '**** ${sSignalRModules.baseCurrency.symbol}',
        ),
        if (simpleAccount != null)
          SimpleTableAsset(
            assetIcon: Assets.svg.assets.fiat.account.simpleSvg(
              width: 24,
            ),
            label: simpleAccount.label ?? 'Account 1',
            supplement: simpleAccount.status == AccountStatus.active
                ? intl.eur_wallet_simple_account
                : intl.create_simple_creating,
            onTableAssetTap: () {
              if (simpleAccount.status == AccountStatus.active) {
                showAccountDepositBySelector(
                  context: context,
                  onClose: () {},
                  bankingAccount: simpleAccount,
                );
              }
            },
            hasRightValue: simpleAccount.status == AccountStatus.active,
            rightValue: simpleAccount.status == AccountStatus.active
                ? getIt<AppStore>().isBalanceHide
                    ? '**** ${eurCurrency.symbol}'
                    : (simpleAccount.balance ?? Decimal.zero).toFormatSum(
                        accuracy: eurCurrency.accuracy,
                        symbol: eurCurrency.symbol,
                      )
                : null,
          ),
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: bankAccounts.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return SimpleTableAsset(
              assetIcon: Assets.svg.assets.fiat.account.simpleSvg(
                width: 24,
              ),
              label: bankAccounts[index].label ?? 'Account',
              supplement: bankAccounts[index].status == AccountStatus.active
                  ? intl.eur_wallet_personal_account
                  : intl.create_personal_creating,
              onTableAssetTap: () {
                if (bankAccounts[index].status == AccountStatus.active) {
                  showAccountDepositBySelector(
                    context: context,
                    onClose: () {},
                    bankingAccount: bankAccounts[index],
                  );
                }
              },
              hasRightValue: bankAccounts[index].status == AccountStatus.active,
              rightValue: bankAccounts[index].status == AccountStatus.active
                  ? getIt<AppStore>().isBalanceHide
                      ? '**** ${eurCurrency.symbol}'
                      : (bankAccounts[index].balance ?? Decimal.zero).toFormatSum(
                          accuracy: eurCurrency.accuracy,
                          symbol: eurCurrency.symbol,
                        )
                  : null,
            );
          },
        ),
        if (cards.isNotEmpty) ...[
          STextDivider(intl.deposit_by_cards),
          for (final card in cards)
            SimpleTableAsset(
              label: card.label ?? '',
              supplement: '${card.cardType.frontName} ••• ${card.last4NumberCharacters}',
              rightValue: getIt<AppStore>().isBalanceHide
                  ? '**** ${card.currency ?? 'EUR'}'
                  : (card.balance ?? Decimal.zero).toFormatSum(
                      accuracy: 2,
                      symbol: card.currency ?? 'EUR',
                    ),
              isCard: true,
              onTableAssetTap: () {
                if (card.status == AccountStatusCard.active) {
                  showSimpleCardDepositBySelector(
                    context: context,
                    onClose: () {},
                    card: card,
                  );
                }
              },
            ),
        ],
      ],
    );
  }
}
