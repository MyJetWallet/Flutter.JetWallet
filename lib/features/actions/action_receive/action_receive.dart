import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/actions/helpers/show_currency_search.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

import '../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../utils/models/currency_model.dart';
import '../../kyc/kyc_service.dart';
import '../../kyc/models/kyc_operation_status_model.dart';

void showReceiveAction(BuildContext context) {
  final kyc = getIt.get<KycService>();
  final handler = getIt.get<KycAlertHandler>();

  final isReceiveMethodsAvailable = sSignalRModules.currenciesList.any((element) => element.supportsCryptoDeposit);

  if ((kyc.depositStatus == kycOperationStatus(KycStatus.allowed)) && isReceiveMethodsAvailable) {
    showSendTimerAlertOr(
      context: context,
      or: () {
        _showReceive(context);
      },
      from: [BlockingType.deposit],
    );
  } else if (!isReceiveMethodsAvailable) {
    sNotification.showError(
      intl.operation_bloked_text,
      id: 1,
    );
  } else {
    handler.handle(
      status: kyc.depositStatus,
      isProgress: kyc.verificationInProgress,
      currentNavigate: () => _showReceive(context),
      requiredDocuments: kyc.requiredDocuments,
      requiredVerifications: kyc.requiredVerifications,
    );
  }
}

void _showReceive(BuildContext context) {
  showCryptoReceiveAction(context);
}

Widget receiveItem({
  required Widget icon,
  required String text,
  required String subtext,
  required Function() onTap,
}) {
  final colors = sKit.colors;

  return InkWell(
    highlightColor: colors.grey5,
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 11,
        left: 24,
        right: 24,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: icon,
          ),
          const SpaceW20(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Baseline(
                baseline: 28,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  text,
                  style: sSubtitle2Style,
                ),
              ),
              Baseline(
                baseline: 18,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  subtext,
                  style: sCaptionTextStyle.copyWith(color: colors.grey3),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void showCryptoReceiveAction(BuildContext context) {
  getIt.get<ActionSearchStore>().init();
  final searchStore = getIt.get<ActionSearchStore>();

  sAnalytics.chooseAssetToReceiveScreenView();

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    expanded: true,
    then: (value) {},
    pinned: ActionBottomSheetHeader(
      name: intl.actionReceive_bottomSheetHeaderName1,
      onChanged: (String value) {
        getIt.get<ActionSearchStore>().search(value);
      },
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      _ActionReceive(
        searchStore: searchStore,
      ),
    ],
  );
}

class _ActionReceive extends StatelessObserverWidget {
  const _ActionReceive({
    required this.searchStore,
  });

  final ActionSearchStore searchStore;

  @override
  Widget build(BuildContext context) {
    final state = searchStore;
    final watchList = sSignalRModules.keyValue.watchlist?.value ?? [];
    sortByBalanceWatchlistAndWeight(state.fCurrencies, watchList);
    var currencyFiltered = List<CurrencyModel>.from(state.fCurrencies);
    currencyFiltered = currencyFiltered
        .where(
          (element) => element.type == AssetType.crypto && element.supportsCryptoDeposit,
        )
        .toList();

    final showSearch = showReceiveCurrencySearch(context);

    return Column(
      children: [
        if (showSearch) ...[
          SPaddingH24(
            child: SStandardField(
              controller: state.searchController,
              labelText: intl.actionBottomSheetHeader_search,
              onChanged: (String value) => state.search(value),
              maxLines: 1,
            ),
          ),
          const SDivider(),
        ],
        Column(
          children: [
            for (final currency in state.fCurrencies)
              if (currency.type == AssetType.crypto)
                if (currency.supportsCryptoDeposit)
                  SWalletItem(
                    icon: SNetworkSvg24(
                      url: currency.iconUrl,
                    ),
                    primaryText: currency.description,
                    secondaryText: currency.symbol,
                    removeDivider: currency == currencyFiltered.last,
                    onTap: () {
                      getIt.get<AppRouter>().push(
                            CryptoDepositRouter(
                              header: intl.actionReceive_receive,
                              currency: currency,
                            ),
                          );
                    },
                  ),
          ],
        ),
        const SpaceH42(),
      ],
    );
  }
}
