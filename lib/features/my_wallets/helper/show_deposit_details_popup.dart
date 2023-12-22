import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/iban/widgets/iban_item.dart';
import 'package:jetwallet/features/iban/widgets/iban_terms_container.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_separator.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/24x24/public/bank_medium/bank_medium_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

Future<void> showSelectAccountForAddCash(BuildContext context) async {
  final kycState = getIt.get<KycService>();

  if (kycState.depositStatus == kycOperationStatus(KycStatus.blocked)) {
    sNotification.showError(
      intl.operation_bloked_text,
      id: 1,
      needFeedback: true,
    );

    return;
  }

  showSendTimerAlertOr(
    context: context,
    from: [BlockingType.deposit],
    or: () async {
      if (MyWalletsSrore.of(context).buttonStatus == BankingShowState.getAccount) {
        await MyWalletsSrore.of(context).createSimpleAccount();
      } else {
        sAnalytics.addCashToSheetView();
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
      }
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SPaddingH24(
          child: Text(
            intl.sell_amount_accounts,
            style: sBodyText2Style.copyWith(
              color: sKit.colors.grey2,
            ),
          ),
        ),
        if (simpleAccount != null)
          SCardRow(
            maxWidth: MediaQuery.of(context).size.width * .35,
            icon: Container(
              margin: const EdgeInsets.only(top: 3),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: sKit.colors.blue,
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: 16,
                height: 16,
                child: SBankMediumIcon(
                  color: sKit.colors.white,
                ),
              ),
            ),
            name: simpleAccount.label ?? 'Account 1',
            helper: simpleAccount.status == AccountStatus.active
                ? intl.eur_wallet_simple_account
                : intl.create_simple_creating,
            onTap: () {
              sAnalytics.tapOnTheButtonEURAccOnAddCashToSheet(
                eurAccLabel: simpleAccount.label ?? 'Account 1',
                eurAccType: 'CJ',
              );
              if (simpleAccount.status == AccountStatus.active) {
                sAnalytics.eurWalletDepositDetailsSheet(
                  isCJ: true,
                  eurAccountLabel: simpleAccount.label ?? 'Account 1',
                  isHasTransaction: true,
                  source: 'Wallets',
                );

                showDepositDetails(
                  context,
                  () {
                    sAnalytics.eurWalletTapCloseOnDeposirSheet(
                      isCJ: true,
                      eurAccountLabel: simpleAccount.label ?? 'Account 1',
                      isHasTransaction: true,
                    );
                  },
                  true,
                  simpleAccount,
                );
              }
            },
            description: '',
            amount: '',
            needSpacer: true,
            rightIcon: simpleAccount.status == AccountStatus.active
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Color(0xFFF1F4F8)),
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: Text(
                      volumeFormat(
                        decimal: simpleAccount.balance ?? Decimal.zero,
                        accuracy: eurCurrency.accuracy,
                        symbol: eurCurrency.symbol,
                      ),
                      style: sSubtitle1Style.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : null,
          ),
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: bankAccounts.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return SCardRow(
              maxWidth: bankAccounts[index].status == AccountStatus.active
                  ? MediaQuery.of(context).size.width * .35
                  : MediaQuery.of(context).size.width * .5,
              icon: Container(
                margin: const EdgeInsets.only(top: 3),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: sKit.colors.blue,
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: SBankMediumIcon(
                    color: sKit.colors.white,
                  ),
                ),
              ),
              name: bankAccounts[index].label ?? 'Account',
              helper: bankAccounts[index].status == AccountStatus.active
                  ? intl.eur_wallet_personal_account
                  : intl.create_personal_creating,
              onTap: () {
                sAnalytics.tapOnTheButtonEURAccOnAddCashToSheet(
                  eurAccLabel: bankAccounts[index].label ?? 'Account 1',
                  eurAccType: 'Unlimint',
                );
                if (bankAccounts[index].status == AccountStatus.active) {
                  sAnalytics.eurWalletDepositDetailsSheet(
                    isCJ: false,
                    eurAccountLabel: bankAccounts[index].label ?? 'Account 1',
                    isHasTransaction: true,
                    source: 'Wallets',
                  );

                  showDepositDetails(
                    context,
                    () {
                      sAnalytics.eurWalletTapCloseOnDeposirSheet(
                        isCJ: false,
                        eurAccountLabel: bankAccounts[index].label ?? 'Account',
                        isHasTransaction: true,
                      );
                    },
                    false,
                    bankAccounts[index],
                  );
                }
              },
              description: '',
              amount: '',
              needSpacer: true,
              rightIcon: bankAccounts[index].status == AccountStatus.active
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Color(0xFFF1F4F8)),
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: Text(
                        volumeFormat(
                          decimal: bankAccounts[index].balance ?? Decimal.zero,
                          accuracy: eurCurrency.accuracy,
                          symbol: eurCurrency.symbol,
                        ),
                        style: sSubtitle1Style.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : null,
            );
          },
        ),
      ],
    );
  }
}

void showAccountDepositSelector(
  BuildContext context,
  VoidCallback onClose,
  bool isCJAccount,
  SimpleBankingAccount bankingAccount,
) {
  var currencyFiltered = List<CurrencyModel>.from(sSignalRModules.currenciesList);
  currencyFiltered = currencyFiltered
      .where(
        (element) => element.isAssetBalanceNotEmpty && element.type == AssetType.crypto,
      )
      .toList();

  final isAccountAvaible = isCJAccount
      ? (sSignalRModules.paymentProducts?.any((element) => element.id == AssetPaymentProductsEnum.simpleIbanAccount) ??
              false) &&
          sSignalRModules.bankingProfileData?.simple?.account != null
      : sSignalRModules.sellMethods.any((element) => element.id == SellMethodsId.ibanSell);

  sShowBasicModalBottomSheet(
    context: context,
    pinned: SBottomSheetHeader(
      name: intl.deposit_by,
    ),
    scrollable: true,
    onDissmis: onClose,
    children: [
      MarketSeparator(
        text: intl.methods,
        isNeedDivider: false,
      ),
      SActionItem(
        icon: const BlueBankIconDeprecated(
          size: 20,
        ),
        name: intl.bankAccountsSelectPopupTitle,
        description: intl.external_transfer,
        onTap: () {
          Navigator.pop(context);
          showDepositDetails(
            context,
            () {
              sAnalytics.eurWalletTapCloseOnDeposirSheet(
                isCJ: isCJAccount,
                eurAccountLabel: bankingAccount.label ?? 'Account',
                isHasTransaction: true,
              );
            },
            isCJAccount,
            bankingAccount,
          );
        },
      ),
      if (currencyFiltered.isNotEmpty && isAccountAvaible) ...[
        SActionItem(
          icon: const BlueBankIconDeprecated(
            size: 20,
          ),
          name: intl.market_crypto,
          description: intl.internal_exchange,
          onTap: () {
            Navigator.pop(context);
            showAccountDetailsFromSelector(
              context,
              () {
                sAnalytics.eurWalletTapCloseOnDeposirSheet(
                  isCJ: isCJAccount,
                  eurAccountLabel: bankingAccount.label ?? 'Account',
                  isHasTransaction: true,
                );
              },
              isCJAccount,
              bankingAccount,
            );
          },
        ),
      ],
      const SpaceH42(),
    ],
  );
}

void showAccountDetailsFromSelector(
  BuildContext context,
  VoidCallback onClose,
  bool isCJAccount,
  SimpleBankingAccount bankingAccount,
) {
  final baseCurrency = sSignalRModules.baseCurrency;

  final searchStore = ActionSearchStore();

  var currencyFiltered = List<CurrencyModel>.from(searchStore.fCurrencies);
  currencyFiltered = currencyFiltered
      .where(
        (element) => element.isAssetBalanceNotEmpty && element.type == AssetType.crypto,
      )
      .toList();

  final showSearch = currencyFiltered.length >= 7;

  sShowBasicModalBottomSheet(
    context: context,
    pinned: ActionBottomSheetHeader(
      name: intl.add_cash_from,
      showSearch: showSearch,
      onChanged: (String value) {
        searchStore.search(value);
      },
    ),
    scrollable: true,
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    onDissmis: onClose,
    children: [
      const SpaceH16(),
      MarketSeparator(
        text: intl.sell_amount_cryptocurrencies,
        isNeedDivider: false,
      ),
      Observer(
        builder: (context) {
          var currencyFiltered = List<CurrencyModel>.from(searchStore.fCurrencies);
          currencyFiltered = currencyFiltered
              .where(
                (element) => element.isAssetBalanceNotEmpty && element.type == AssetType.crypto,
              )
              .toList();

          return Column(
            children: [
              for (final currency in currencyFiltered)
                if (currency.isAssetBalanceNotEmpty)
                  SWalletItem(
                    decline: currency.dayPercentChange.isNegative,
                    icon: SNetworkSvg24(
                      url: currency.iconUrl,
                    ),
                    primaryText: currency.description,
                    removeDivider: true,
                    amount: currency.volumeBaseBalance(baseCurrency),
                    secondaryText: currency.volumeAssetBalance,
                    onTap: () {
                      Navigator.pop(context);
                      sRouter.push(
                        AmountRoute(
                          tab: AmountScreenTab.sell,
                          asset: currency,
                          account: bankingAccount,
                        ),
                      );
                    },
                  ),
            ],
          );
        },
      ),
      const SpaceH42(),
    ],
  );
}

void showDepositDetails(
  BuildContext context,
  VoidCallback onClose,
  bool isCJAccount,
  SimpleBankingAccount bankingAccount,
) {
  if (isCJAccount) {
    sShowBasicModalBottomSheet(
      context: context,
      pinned: SBottomSheetHeader(
        name: intl.account_bottom_sheet_header,
      ),
      scrollable: true,
      onDissmis: onClose,
      children: [
        const SpaceH12(),
        IbanTermsContainer(
          text1: intl.iban_deposit_text,
          text2: intl.iban_terms_3,
        ),
        const SpaceH8(),
        IBanItem(
          name: intl.iban_benificiary,
          text: sSignalRModules.bankingProfileData?.simple?.account?.bankName ?? 'Simple Europe UAB',
          afterCopy: () {
            sAnalytics.eurWalletTapCopyDeposit(
              isCJ: true,
              eurAccountLabel: bankingAccount.label ?? '',
              isHasTransaction: false,
              copyType: intl.iban_benificiary,
            );
          },
        ),
        IBanItem(
          name: intl.iban_iban,
          text: sSignalRModules.bankingProfileData?.simple?.account?.iban ?? '',
          afterCopy: () {
            sAnalytics.eurWalletTapCopyDeposit(
              isCJ: true,
              eurAccountLabel: bankingAccount.label ?? '',
              isHasTransaction: false,
              copyType: intl.iban_iban,
            );
          },
        ),
        IBanItem(
          name: intl.iban_bic,
          text: sSignalRModules.bankingProfileData?.simple?.account?.bic ?? '',
          afterCopy: () {
            sAnalytics.eurWalletTapCopyDeposit(
              isCJ: true,
              eurAccountLabel: bankingAccount.label ?? '',
              isHasTransaction: false,
              copyType: intl.iban_bic,
            );
          },
        ),
        IBanItem(
          name: intl.iban_address,
          text: sSignalRModules.bankingProfileData?.simple?.account?.address ?? '',
          afterCopy: () {
            sAnalytics.eurWalletTapCopyDeposit(
              isCJ: true,
              eurAccountLabel: bankingAccount.label ?? '',
              isHasTransaction: false,
              copyType: intl.iban_address,
            );
          },
        ),
        const SpaceH42(),
      ],
    );
  } else {
    sShowBasicModalBottomSheet(
      context: context,
      pinned: SBottomSheetHeader(
        name: intl.account_bottom_sheet_header,
      ),
      scrollable: true,
      onDissmis: onClose,
      children: [
        const SpaceH12(),
        IbanTermsContainer(
          text1: intl.iban_deposit_text,
          text2: intl.iban_terms_5,
        ),
        const SpaceH8(),
        IBanItem(
          name: intl.iban_benificiary,
          text: '${bankingAccount.holderFirstName} ${bankingAccount.holderLastName}',
          afterCopy: () {
            sAnalytics.eurWalletTapCopyDeposit(
              isCJ: false,
              eurAccountLabel: bankingAccount.label ?? '',
              isHasTransaction: false,
              copyType: intl.iban_benificiary,
            );
          },
        ),
        IBanItem(
          name: intl.iban_iban,
          text: bankingAccount.iban ?? '',
          afterCopy: () {
            sAnalytics.eurWalletTapCopyDeposit(
              isCJ: false,
              eurAccountLabel: bankingAccount.label ?? '',
              isHasTransaction: false,
              copyType: intl.iban_iban,
            );
          },
        ),
        IBanItem(
          name: intl.iban_bic,
          text: bankingAccount.bic ?? '',
          afterCopy: () {
            sAnalytics.eurWalletTapCopyDeposit(
              isCJ: false,
              eurAccountLabel: bankingAccount.label ?? '',
              isHasTransaction: false,
              copyType: intl.iban_bic,
            );
          },
        ),
        IBanItem(
          name: intl.iban_address,
          text: bankingAccount.address ?? '',
          afterCopy: () {
            sAnalytics.eurWalletTapCopyDeposit(
              isCJ: false,
              eurAccountLabel: bankingAccount.label ?? '',
              isHasTransaction: false,
              copyType: intl.iban_address,
            );
          },
        ),
        const SpaceH42(),
      ],
    );
  }
}
