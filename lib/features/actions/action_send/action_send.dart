import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/widgets/send_alert_bottom_sheet.dart';
import 'package:jetwallet/features/actions/action_send/widgets/send_options.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/flag_asset_name.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

import '../../../core/services/local_storage_service.dart';
import '../helpers/show_currency_search.dart';

enum SendType { Wallet, Phone }

void showSendAction(
  BuildContext context, {
  bool isSendAvailable = true,
  bool isNotEmptyBalance = true,
  bool shouldPop = true,
}) {
  if (shouldPop) {
    Navigator.pop(context);
  }
  final searchState = getIt.get<ActionSearchStore>();
  final sendAssets = searchState.fCurrencies
      .where(
        (element) =>
            element.isAssetBalanceNotEmpty && element.supportsCryptoWithdrawal,
      )
      .toList();

  if (isNotEmptyBalance && isSendAvailable && sendAssets.isNotEmpty) {
    showSendTimerAlertOr(
      context: context,
      or: () => _showSendAction(context),
      from: BlockingType.withdrawal,
    );
  } else {
    sendAlertBottomSheet(context);
  }
}

Future<void> _showSendAction(BuildContext context) async {
  final isAnyAssetSupportPhoneSend = sSignalRModules.currenciesList
      .where(
        (element) =>
            element.isAssetBalanceNotEmpty &&
            element.supportsByPhoneNicknameWithdrawal &&
            element.supportsCryptoWithdrawal,
      )
      .toList();

  final isGlobalSendActive = sSignalRModules.currenciesList
      .where((element) => element.supportsGlobalSend)
      .toList();

  final isIbanOutActive = sSignalRModules.currenciesList
      .where((element) => element.supportIbanSendWithdrawal)
      .toList();

  sShowBasicModalBottomSheet(
    context: context,
    pinned: const ActionBottomSheetHeader(
      name: 'Send to',
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      SCardRow(
        icon: const SWallet2Icon(),
        onTap: () {
          Navigator.pop(context);

          _showSendActionChooseAsset(context, SendType.Wallet);
        },
        amount: '',
        description: '',
        name: 'Crypto wallet',
        helper: 'To blockchain address',
        removeDivider: true,
      ),
      if (isAnyAssetSupportPhoneSend.isNotEmpty)
        SCardRow(
          icon: const SPhoneIcon(),
          onTap: () {
            Navigator.pop(context);

            _showSendActionChooseAsset(context, SendType.Phone);
          },
          amount: '',
          description: '',
          name: intl.sendOptions_actionItemName3,
          helper: intl.sendOptions_actionItemDescription1,
          removeDivider: true,
        ),
      if (isGlobalSendActive.isNotEmpty)
        SCardRow(
          icon: const SNetworkIcon(),
          onTap: () {
            Navigator.pop(context);

            showSendGlobally(context);
          },
          amount: '',
          description: '',
          name: intl.global_send_name,
          helper: intl.global_send_helper,
          removeDivider: true,
        ),
      if (isIbanOutActive.isNotEmpty)
        SCardRow(
          icon: const SAccountIcon(),
          onTap: () {
            Navigator.pop(context);

            sRouter.replaceAll(
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

            getIt.get<AppStore>().setHomeTab(2);
            if (getIt<AppStore>().tabsRouter != null) {
              getIt<AppStore>().tabsRouter!.setActiveIndex(2);

              if (getIt.get<IbanStore>().ibanTabController != null) {
                getIt.get<IbanStore>().ibanTabController!.animateTo(
                      1,
                    );
              } else {
                getIt.get<IbanStore>().setInitTab(1);
              }
            }
          },
          amount: '',
          description: '',
          name: intl.iban_send_name,
          helper: intl.iban_send_helper,
          removeDivider: true,
        ),
      const SpaceH42(),
    ],
    then: (value) {},
  );
}

Future<void> showSendGlobally(BuildContext context) async {
  sShowBasicModalBottomSheet(
    context: context,
    pinned: const ActionBottomSheetHeader(
      name: 'Destination country',
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      SCardRow(
        icon: Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          height: 24,
          width: 24,
          child: SvgPicture.asset(
            flagAssetName('UA'),
            fit: BoxFit.cover,
          ),
        ),
        height: 68,
        onTap: () {
          Navigator.pop(context);

          sRouter.push(const SendCardDetailRouter());
        },
        amount: '',
        description: '',
        name: 'Ukraine',
        removeDivider: true,
      ),
      SPaddingH24(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Image.asset(
                flagsAsset,
                height: 18,
                width: 46,
              ),
              const SizedBox(width: 9),
              Text(
                'Nigeria, Ghana and Kenya coming soon',
                style: sCaptionTextStyle.copyWith(
                  color: sKit.colors.grey2,
                ),
              )
            ],
          ),
        ),
      ),
      const SpaceH42(),
    ],
    then: (value) {},
  );
}

Future<void> _showSendActionChooseAsset(
  BuildContext context,
  SendType type,
) async {
  final showSearch = showSendCurrencySearch(context);

  final storageService = getIt.get<LocalStorageService>();
  final lastCurrency = await storageService.getValue(lastAssetSend);

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: ActionBottomSheetHeader(
      name: intl.actionSend_bottomSheetHeaderName,
      showSearch: showSearch,
      onChanged: (String value) {
        getIt.get<ActionSearchStore>().search(value);
      },
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      if (type == SendType.Wallet) ...[
        _ActionSend(
          lastCurrency: lastCurrency,
          type: type,
        ),
      ] else ...[
        _ActionSendPhone(
          lastCurrency: lastCurrency,
          type: type,
        ),
      ]
    ],
    then: (value) {},
  );
}

class _ActionSend extends StatelessObserverWidget {
  const _ActionSend({
    this.lastCurrency,
    required this.type,
  });

  final String? lastCurrency;
  final SendType type;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final state = getIt.get<ActionSearchStore>();

    var currencyFiltered = List<CurrencyModel>.from(state.fCurrencies);
    currencyFiltered = currencyFiltered
        .where(
          (element) =>
              element.isAssetBalanceNotEmpty &&
              element.supportsCryptoWithdrawal,
        )
        .toList();

    currencyFiltered.sort((a, b) {
      if (lastCurrency != null) {
        if (a.symbol == lastCurrency) {
          return 0.compareTo(1);
        } else if (b.symbol == lastCurrency) {
          return 1.compareTo(0);
        }
      }

      return b.baseBalance.compareTo(a.baseBalance);
    });

    return Column(
      children: [
        for (final currency in currencyFiltered)
          if (currency.isAssetBalanceNotEmpty)
            if (currency.supportsCryptoWithdrawal)
              SWalletItem(
                decline: currency.dayPercentChange.isNegative,
                icon: SNetworkSvg24(
                  url: currency.iconUrl,
                ),
                primaryText: currency.description,
                removeDivider: currency == currencyFiltered.last,
                amount: currency.volumeBaseBalance(baseCurrency),
                secondaryText: currency.volumeAssetBalance,
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
        const SpaceH42(),
      ],
    );
  }
}

class _ActionSendPhone extends StatelessObserverWidget {
  const _ActionSendPhone({
    this.lastCurrency,
    required this.type,
  });

  final String? lastCurrency;
  final SendType type;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final state = getIt.get<ActionSearchStore>();

    var currencyFiltered = List<CurrencyModel>.from(state.fCurrencies);
    currencyFiltered = currencyFiltered
        .where(
          (element) =>
              element.isAssetBalanceNotEmpty &&
              element.supportsCryptoWithdrawal,
        )
        .toList();

    currencyFiltered.sort((a, b) {
      if (lastCurrency != null) {
        if (a.symbol == lastCurrency) {
          return 0.compareTo(1);
        } else if (b.symbol == lastCurrency) {
          return 1.compareTo(0);
        }
      }

      return b.baseBalance.compareTo(a.baseBalance);
    });

    return Column(
      children: [
        for (final currency in currencyFiltered)
          if (currency.isAssetBalanceNotEmpty)
            if (currency.supportsCryptoWithdrawal)
              if (currency.supportsByPhoneNicknameWithdrawal)
                SWalletItem(
                  decline: currency.dayPercentChange.isNegative,
                  icon: SNetworkSvg24(
                    url: currency.iconUrl,
                  ),
                  primaryText: currency.description,
                  removeDivider: currency == currencyFiltered.last,
                  amount: currency.volumeBaseBalance(baseCurrency),
                  secondaryText: currency.volumeAssetBalance,
                  onTap: () {
                    sRouter.navigate(
                      SendByPhoneInputRouter(
                        currency: currency,
                      ),
                    );
                  },
                ),
        const SpaceH42(),
      ],
    );
  }
}
