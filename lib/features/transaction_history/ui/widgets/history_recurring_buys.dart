import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';

import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_recurring_buy/widgets/recurring_buys_item.dart';
import 'package:jetwallet/features/actions/action_sell/action_sell.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/reccurring/store/recurring_buys_store.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transaction_month_separator.dart';
import 'package:jetwallet/utils/helpers/are_balances_empty.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_model.dart';

class HistoryRecurringBuys extends StatelessObserverWidget {
  const HistoryRecurringBuys({super.key, this.from});

  final Source? from;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final deviceSize = sDeviceSize;
    final scrollController = ScrollController();

    final state = getIt.get<RecurringBuysStore>();

    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    final currencies = sSignalRModules.currenciesList;

    final screenHeight = MediaQuery.of(context).size.height;

    return Material(
      color: colors.white,
      child: CustomScrollView(
        controller: scrollController,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            toolbarHeight: deviceSize.when(
              small: () {
                return 80;
              },
              medium: () {
                return 60;
              },
            ),
            pinned: true,
            backgroundColor: colors.white,
            automaticallyImplyLeading: false,
            elevation: 0,
            flexibleSpace: SPaddingH24(
              child: SSmallHeader(
                title: intl.account_recurringBuy,
              ),
            ),
          ),
          if (state.recurringBuysFiltred.isNotEmpty)
            SliverGroupedListView<RecurringBuysModel, String>(
              elements: state.recurringBuysFiltred,
              groupBy: (recurring) {
                return recurring.toAsset;
              },
              sort: false,
              groupSeparatorBuilder: (String nameAsset) {
                return TransactionMonthSeparator(
                  text: nameAsset,
                );
              },
              itemBuilder: (context, recurring) {
                final index = state.recurringBuysFiltred.indexOf(recurring);
                final currentAsset = recurring.toAsset;
                var nextAsset = '';
                if (index != (state.recurringBuysFiltred.length - 1)) {
                  nextAsset = state.recurringBuysFiltred[index + 1].toAsset;
                }
                final removeDividerForLastInGroup = currentAsset != nextAsset;

                return RecurringBuysItem(
                  onTap: () {
                    sRouter.push(
                      ShowRecurringInfoActionRouter(
                        recurringItem: recurring,
                        assetName: recurring.toAsset,
                      ),
                    );
                  },
                  recurring: recurring,
                  removeDivider: removeDividerForLastInGroup,
                );
              },
            )
          else
            SliverToBoxAdapter(
              child: SizedBox(
                height: screenHeight - screenHeight * 0.161,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(
                      intl.historyRecurringBuys_noTransactionsYet,
                      style: sTextH3Style,
                    ),
                    Text(
                      intl.historyRecurringBuy_text1,
                      style: sBodyText1Style.copyWith(
                        color: colors.grey1,
                      ),
                    ),
                    const Spacer(),
                    if (!areBalancesEmpty(currencies))
                      SPaddingH24(
                        child: SSecondaryButton1(
                          active: true,
                          name: intl.actionBuy_actionWithOutRecurringBuyTitle1,
                          onTap: () {
                            if (kycState.depositStatus ==
                                kycOperationStatus(KycStatus.allowed)) {
                              state.handleNavigate(context, from);
                            } else {
                              kycAlertHandler.handle(
                                status: kycState.depositStatus,
                                isProgress: kycState.verificationInProgress,
                                currentNavigate: () => showSellAction(context),
                                requiredDocuments: kycState.requiredDocuments,
                                requiredVerifications:
                                    kycState.requiredVerifications,
                              );
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
