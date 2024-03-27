import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_positions_store.dart';
import 'package:jetwallet/features/invest/ui/invests/data_line.dart';
import 'package:jetwallet/features/invest/ui/invests/invest_bottom_sheets/history_positions.dart';
import 'package:jetwallet/features/invest/ui/invests/invest_bottom_sheets/pending_positions.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_alert_bottom_sheet.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_market_watch_bottom_sheet.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/button/invest_buttons/invest_button.dart';

import '../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../utils/helpers/currency_from.dart';
import '../dashboard/invest_header.dart';
import '../invests/invest_bottom_sheets/active_positions.dart';
import '../invests/main_switch.dart';

void showInvestListBottomSheet(BuildContext context) {
  final investPositionsStore = getIt.get<InvestPositionsStore>();
  final investStore = getIt.get<InvestDashboardStore>();
  final currencies = sSignalRModules.currenciesList;
  final currency = currencyFrom(currencies, 'USDT');

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    enableDrag: false,
    expanded: true,
    pinned: SPaddingH24(
      child: Column(
        children: [
          InvestHeader(
            currency: currency,
            hideWallet: true,
            withBackBlock: true,
            withBigPadding: false,
            withDivider: false,
            onBackButton: () {
              Navigator.pop(context);
            },
          ),
          Observer(
            builder: (BuildContext context) {
              return MainSwitch(
                onChangeTab: investPositionsStore.setActiveTab,
                activeTab: investPositionsStore.activeTab,
              );
            },
          ),
        ],
      ),
    ),
    pinnedBottom: Material(
      color: SColorsLight().white,
      child: Observer(
        builder: (BuildContext context) {
          if (investPositionsStore.activeTab == 0) {
            return SizedBox(
              height: 98.0,
              child: Column(
                children: [
                  const SpaceH20(),
                  SPaddingH24(
                    child: Row(
                      children: [
                        if (investPositionsStore.activeList.isNotEmpty) ...[
                          Expanded(
                            child: SIButton(
                              activeColor: SColorsLight().black,
                              activeNameColor: SColorsLight().white,
                              inactiveColor: SColorsLight().grey2,
                              inactiveNameColor: SColorsLight().grey4,
                              active: true,
                              icon: Assets.svg.invest.investClose.simpleSvg(
                                width: 20,
                                height: 20,
                              ),
                              name: intl.invest_list_close_all,
                              onTap: () {
                                showInvestInfoBottomSheet(
                                  context: context,
                                  type: 'info',
                                  onPrimaryButtonTap: () => Navigator.pop(context),
                                  onSecondaryButtonTap: () {
                                    Navigator.pop(context);
                                    showInvestInfoBottomSheet(
                                      context: context,
                                      type: 'pending',
                                      onPrimaryButtonTap: () => Navigator.pop(context),
                                      primaryButtonName: intl.invest_alert_got_it,
                                      title: intl.invest_alert_in_progress,
                                      subtitle: intl.invest_alert_in_progress_description,
                                    );
                                    investPositionsStore.closeAllActive(context, null);
                                  },
                                  primaryButtonName: intl.invest_alert_cancel,
                                  secondaryButtonName: intl.invest_alert_close_all,
                                  bottomWidget: DataLine(
                                    mainText: intl.invest_alert_close_all_profit,
                                    secondaryText: marketFormat(
                                      decimal: investStore.totalProfit,
                                      accuracy: 2,
                                      symbol: currency.symbol,
                                    ),
                                    secondaryColor:
                                    investStore.totalProfit >= Decimal.zero
                                        ? SColorsLight().green
                                        : SColorsLight().red,
                                  ),
                                  title: intl.invest_alert_close_all_title,
                                  subtitle: intl.invest_alert_close_all_subtitle,
                                );
                              },
                            ),
                          ),
                          const SpaceW10(),
                        ],
                        Expanded(
                          child: SIButton(
                            activeColor: SColorsLight().blue,
                            activeNameColor: SColorsLight().white,
                            inactiveColor: SColorsLight().grey4,
                            inactiveNameColor: SColorsLight().grey2,
                            active: true,
                            icon: Assets.svg.invest.investPlus.simpleSvg(
                              width: 20,
                              height: 20,
                            ),
                            name: intl.invest_list_new_invest,
                            onTap: () {
                              investStore.setActiveSection('all');
                              showInvestMarketWatchBottomSheet(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SpaceH34(),
                ],
              ),
            );
          } else if (investPositionsStore.activeTab == 1) {
            return SizedBox(
              height: 98.0,
              child: Column(
                children: [
                  const SpaceH20(),
                  SPaddingH24(
                    child: Row(
                      children: [
                        if (investPositionsStore.pendingList.isNotEmpty) ...[
                          Expanded(
                            child: SIButton(
                              activeColor: SColorsLight().black,
                              activeNameColor: SColorsLight().white,
                              inactiveColor: SColorsLight().grey2,
                              inactiveNameColor: SColorsLight().grey4,
                              active: true,
                              icon: Assets.svg.invest.investClose.simpleSvg(
                                width: 20,
                                height: 20,
                              ),
                              name: intl.invest_list_delete_all,
                              onTap: () {
                                showInvestInfoBottomSheet(
                                  context: context,
                                  type: 'info',
                                  onPrimaryButtonTap: () => Navigator.pop(context),
                                  onSecondaryButtonTap: () {
                                    Navigator.pop(context);
                                    showInvestInfoBottomSheet(
                                      context: context,
                                      type: 'pending',
                                      onPrimaryButtonTap: () => Navigator.pop(context),
                                      primaryButtonName: intl.invest_alert_got_it,
                                      title: intl.invest_alert_in_progress,
                                      subtitle: intl.invest_alert_in_progress_description,
                                    );
                                    investPositionsStore.cancelAllPending(context, null);
                                  },
                                  primaryButtonName: intl.invest_alert_cancel,
                                  secondaryButtonName: intl.invest_alert_delete_all,
                                  title: intl.invest_alert_delete_all_title,
                                  subtitle: intl.invest_alert_delete_all_subtitle,
                                );
                              },
                            ),
                          ),
                          const SpaceW10(),
                        ],
                        Expanded(
                          child: SIButton(
                            activeColor: SColorsLight().blue,
                            activeNameColor: SColorsLight().white,
                            inactiveColor: SColorsLight().grey4,
                            inactiveNameColor: SColorsLight().grey2,
                            active: true,
                            icon: Assets.svg.invest.investPlus.simpleSvg(
                              width: 20,
                              height: 20,
                            ),
                            name: intl.invest_list_new_invest,
                            onTap: () {
                              investStore.setActiveSection('all');
                              showInvestMarketWatchBottomSheet(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SpaceH34(),
                ],
              ),
            );
          } else {
            return SizedBox(
              height: 98.0,
              child: Column(
                children: [
                  const SpaceH20(),
                  SPaddingH24(
                    child: Row(
                      children: [
                        Expanded(
                          child: SIButton(
                            activeColor: SColorsLight().blue,
                            activeNameColor: SColorsLight().white,
                            inactiveColor: SColorsLight().grey4,
                            inactiveNameColor: SColorsLight().grey2,
                            active: true,
                            icon: Assets.svg.invest.investPlus.simpleSvg(
                              width: 20,
                              height: 20,
                            ),
                            name: intl.invest_list_new_invest,
                            onTap: () {
                              investStore.setActiveSection('all');
                              showInvestMarketWatchBottomSheet(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SpaceH34(),
                ],
              ),
            );
          }
        },
      ),
    ),
    horizontalPinnedPadding: 0,
    removePinnedPadding: true,
    horizontalPadding: 0,
    children: [const InvestList()],
  );
}

class InvestList extends StatelessObserverWidget {
  const InvestList();

  @override
  Widget build(BuildContext context) {
    final investPositionsStore = getIt.get<InvestPositionsStore>();

    return SPaddingH24(
      child: Observer(
        builder: (BuildContext context) {
          if (investPositionsStore.activeTab == 0) {
            return const ActiveInvestList();
          } else if (investPositionsStore.activeTab == 1) {
            return const PendingInvestList();
          } else if (investPositionsStore.activeTab == 2) {
            return const HistoryInvestList();
          }

          return const ActiveInvestList();
        },
      ),
    );
  }
}
