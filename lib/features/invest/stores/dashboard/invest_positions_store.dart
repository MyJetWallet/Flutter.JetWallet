import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/button/invest_buttons/invest_text_button.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';
import 'package:simple_networking/modules/wallet_api/models/invest/new_invest_request_model.dart';

import '../../../../core/di/di.dart';
import '../../../../core/l10n/i10n.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../utils/formatting/base/volume_format.dart';
import '../../helpers/invest_period_info.dart';
import '../../ui/invests/data_line.dart';
import '../../ui/widgets/invest_alert_bottom_sheet.dart';
import 'invest_dashboard_store.dart';

part 'invest_positions_store.g.dart';

@lazySingleton
class InvestPositionsStore = _InvestPositionsStoreBase with _$InvestPositionsStore;

abstract class _InvestPositionsStoreBase with Store {
  _InvestPositionsStoreBase() {
    loader = StackLoaderStore();
  }

  @observable
  bool isActiveGrouped = true;

  @observable
  bool isHistoryGrouped = true;

  @observable
  int activeInstrumentTab = 0;

  @observable
  int activeTab = 0;

  @observable
  int historyTab = 0;

  @observable
  int activeSortState = 0;

  @observable
  int historySortState = 0;

  @observable
  StackLoaderStore? loader;

  @observable
  List<NewInvestJournalModel> journalList = [];

  @observable
  List<NewInvestJournalModel> rolloverList = [];

  @observable
  List<InvestSummaryModel> allSummary = [];

  @action
  void setSummary(
    List<InvestSummaryModel> summary,
  ) {
    allSummary = summary;
  }

  @observable
  Decimal totalAmount = Decimal.zero;

  @observable
  Decimal totalProfit = Decimal.zero;

  @observable
  Decimal totalProfitPercent = Decimal.zero;

  @computed
  InvestInstrumentsModel? get investInstrumentsData => sSignalRModules.investInstrumentsData;
  @computed
  InvestPositionsModel? get investPositionsData => sSignalRModules.investPositionsData;

  @action
  void setTotals(
    Decimal amount,
    Decimal profit,
    Decimal percent,
  ) {
    totalAmount = amount;
    totalProfit = profit;
    totalProfitPercent = percent;
  }

  @action
  Future<void> requestInvestHistorySummary(
    bool needLoader,
  ) async {
    final investStore = getIt.get<InvestDashboardStore>();

    final response = await sNetwork.getWalletModule().getInvestHistorySummary(
          dateFrom: '${DateTime.now().subtract(
            Duration(
              days: getDaysByPeriod(investStore.period),
            ),
          )}',
          dateTo: '${DateTime.now()}',
        );

    var amount = Decimal.zero;
    var profit = Decimal.zero;
    var percent = Decimal.zero;

    if (response.data != null && response.data!.isNotEmpty) {
      for (final instrument in response.data!) {
        amount += instrument.amount ?? Decimal.zero;
        profit += instrument.amountPl ?? Decimal.zero;
      }
      if (amount != Decimal.zero && profit != Decimal.zero) {
        percent = Decimal.fromJson('${(Decimal.fromInt(100) * profit / amount).toDouble()}');
      }
      setTotals(amount, profit, percent);
      setSummary(response.data!);
    }
  }

  @action
  Future<void> initPosition(InvestPositionModel position) async {
    final response = await sNetwork.getWalletModule().getPositionHistory(id: position.id!, skip: '0', take: '20');
    if (!response.hasError && response.data != null) {
      journalList = response.data!;
    }
    final responseRollover =
        await sNetwork.getWalletModule().getPositionHistoryRollover(id: position.id!, skip: '0', take: '20');
    if (!responseRollover.hasError && responseRollover.data != null) {
      rolloverList = responseRollover.data!;
    }
  }

  @computed
  List<InvestInstrumentModel> get instrumentsList => investInstrumentsData?.instruments ?? [];

  @computed
  List<InvestPositionModel> get positionsList => investPositionsData?.positions ?? [];

  @computed
  ObservableList<InvestPositionModel> get activeList {
    final activeList = positionsList;
    final activePositions = <InvestPositionModel>[];
    if (activeList.isNotEmpty) {
      for (var i = 0; i < activeList.length; i++) {
        if (activeList[i].status == PositionStatus.opened || activeList[i].status == PositionStatus.pending) {
          activePositions.add(activeList[i]);
        }
      }
    }

    return ObservableList.of(activePositions);
  }

  @computed
  ObservableList<InvestPositionModel> get pendingList {
    final activeList = positionsList;
    final pendingPositions = <InvestPositionModel>[];
    if (activeList.isNotEmpty) {
      for (var i = 0; i < activeList.length; i++) {
        if (activeList[i].status == PositionStatus.pending) {
          pendingPositions.add(activeList[i]);
        }
      }
    }

    return ObservableList.of(pendingPositions);
  }

  @computed
  ObservableList<InvestPositionModel> get closedList {
    final activeList = positionsList;
    final closedPositions = <InvestPositionModel>[];
    if (activeList.isNotEmpty) {
      for (var i = 0; i < activeList.length; i++) {
        if (activeList[i].status == PositionStatus.closed) {
          closedPositions.add(activeList[i]);
        }
      }
    }

    return ObservableList.of(closedPositions);
  }

  @computed
  ObservableList<InvestPositionModel> get cancelledList {
    final activeList = positionsList;
    final cancelledPositions = <InvestPositionModel>[];
    if (activeList.isNotEmpty) {
      for (var i = 0; i < activeList.length; i++) {
        if (activeList[i].status == PositionStatus.cancelled) {
          cancelledPositions.add(activeList[i]);
        }
      }
    }

    return ObservableList.of(cancelledPositions);
  }

  @action
  void setActiveTab(int newTab) {
    activeTab = newTab;
  }

  @action
  void setActiveInstrumentTab(int newTab) {
    activeInstrumentTab = newTab;
  }

  @action
  void setIsActiveGrouped(bool value) {
    isActiveGrouped = value;
  }

  @action
  void setIsHistoryGrouped(bool value) {
    isHistoryGrouped = value;
  }

  @action
  void setHistoryTab(int value) {
    historyTab = value;
  }

  @action
  void setHistorySort() {
    historySortState = historySortState == 2 ? 0 : historySortState + 1;
  }

  @action
  void setActiveSort() {
    activeSortState = activeSortState == 2 ? 0 : activeSortState + 1;
  }

  @action
  void closeAllActive(BuildContext context, String? id) {
    loader!.startLoading();
    var positions = List.of(activeList);
    if (id != null) {
      positions = positions.where((element) => element.symbol == id).toList();
    }
    for (final position in positions) {
      try {
        sNetwork.getWalletModule().closeActivePosition(positionId: position.id ?? '');
        if (position.id == positions.last.id) {
          checkClosedPosition(
            position.id!,
            () {
              Navigator.pop(context);
              showInvestInfoBottomSheet(
                context: context,
                type: 'success',
                onPrimaryButtonTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                primaryButtonName: intl.invest_alert_got_it,
                title: intl.invest_alert_success_close,
              );
            },
          );
        }
      } catch (e) {
        loader!.finishLoading();
        Navigator.pop(context);
        showInvestInfoBottomSheet(
          context: context,
          type: 'error',
          onPrimaryButtonTap: () => Navigator.pop(context),
          primaryButtonName: intl.invest_alert_got_it,
          title: intl.invest_alert_error,
          subtitle: intl.invest_alert_error_description,
        );
      }
    }
  }

  @computed
  bool get isBalanceHide => getIt<AppStore>().isBalanceHide;

  @action
  void closeActivePosition(
    BuildContext context,
    InvestPositionModel position,
    InvestInstrumentModel instrument,
  ) {
    try {
      sNetwork.getWalletModule().closeActivePosition(positionId: position.id ?? '');
      final investStore = getIt.get<InvestDashboardStore>();
      showInvestInfoBottomSheet(
        context: context,
        type: 'success',
        onPrimaryButtonTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
        primaryButtonName: intl.invest_alert_got_it,
        title: intl.invest_alert_success_close_position,
        removeWidgetSpace: true,
        bottomWidget: Column(
          children: [
            const SpaceH16(),
            DataLine(
              mainText: intl.invest_alert_close_all_profit,
              secondaryText: isBalanceHide
                  ? '**** USDT'
                  : volumeFormat(
                      decimal: investStore.getProfitByPosition(position),
                      accuracy: 2,
                      symbol: 'USDT',
                    ),
              secondaryColor: SColorsLight().green,
            ),
            const SpaceH8(),
            DataLine(
              mainText: intl.invest_close_price,
              secondaryText: volumeFormat(
                decimal: investStore.getPendingPriceBySymbol(instrument.symbol ?? ''),
                accuracy: instrument.priceAccuracy ?? 2,
                symbol: '',
              ),
            ),
            const SpaceH16(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DataLine(
                  fullWidth: false,
                  mainText: intl.invest_close_fee,
                  secondaryText: isBalanceHide
                      ? '**** USDT'
                      : volumeFormat(
                          decimal: (position.volumeBase ?? Decimal.zero) *
                              investStore.getPendingPriceBySymbol(instrument.symbol ?? '') *
                              (instrument.closeFee ?? Decimal.zero),
                          accuracy: instrument.priceAccuracy ?? 2,
                          symbol: 'USDT',
                        ),
                ),
                const SpaceW20(),
                SITextButton(
                  active: true,
                  name: intl.invest_full_report,
                  onTap: () {},
                  icon: Assets.svg.invest.report.simpleSvg(
                    width: 16,
                    height: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      showInvestInfoBottomSheet(
        context: context,
        type: 'error',
        onPrimaryButtonTap: () => Navigator.pop(context),
        primaryButtonName: intl.invest_alert_got_it,
        title: intl.invest_alert_error,
        subtitle: intl.invest_alert_error_description,
      );
    }
  }

  @action
  void cancelAllPending(BuildContext context, String? id) {
    loader!.startLoading();
    var positions = List.of(pendingList);
    if (id != null) {
      positions = positions.where((element) => element.symbol == id).toList();
    }
    for (final position in positions) {
      try {
        sNetwork.getWalletModule().cancelPendingPosition(positionId: position.id ?? '');
        if (position == positions.last) {
          checkClosedPosition(
            position.id!,
            () {
              Navigator.pop(context);
              showInvestInfoBottomSheet(
                context: context,
                type: 'success',
                onPrimaryButtonTap: () => Navigator.pop(context),
                primaryButtonName: intl.invest_alert_got_it,
                title: intl.invest_alert_success_delete,
              );
            },
          );
        }
      } catch (e) {
        Navigator.pop(context);
        loader!.finishLoading();
        showInvestInfoBottomSheet(
          context: context,
          type: 'error',
          onPrimaryButtonTap: () => Navigator.pop(context),
          primaryButtonName: intl.invest_alert_got_it,
          title: intl.invest_alert_error,
          subtitle: intl.invest_alert_error_description,
        );
      }
    }
  }

  @action
  void cancelPending(BuildContext context, String? id) {
    loader!.startLoading();

    try {
      sNetwork.getWalletModule().cancelPendingPosition(positionId: id ?? '');

      checkClosedPosition(
        id ?? '',
        () {
          Navigator.pop(context);
          Navigator.pop(context);
          showInvestInfoBottomSheet(
            context: context,
            type: 'success',
            onPrimaryButtonTap: () => Navigator.pop(context),
            primaryButtonName: intl.invest_alert_got_it,
            title: intl.invest_alert_success_delete,
          );
        },
      );
    } catch (e) {
      Navigator.pop(context);
      loader!.finishLoading();
      showInvestInfoBottomSheet(
        context: context,
        type: 'error',
        onPrimaryButtonTap: () => Navigator.pop(context),
        primaryButtonName: intl.invest_alert_got_it,
        title: intl.invest_alert_error,
        subtitle: intl.invest_alert_error_description,
      );
    }
  }

  @action
  Future<void> checkClosedPosition(
    String id,
    Function() onClose,
  ) async {
    try {
      final response = await getIt.get<SNetwork>().simpleNetworking.getWalletModule().getPosition(positionId: id);

      if (response.hasError) {
        sNotification.showError(
          response.error?.cause ?? '',
          id: 1,
          needFeedback: true,
        );
        loader!.finishLoading();
      } else {
        if (response.data?.position?.status == PositionStatus.closing ||
            response.data?.position?.status == PositionStatus.cancelling) {
          Timer(
            const Duration(seconds: 1),
            () {
              checkClosedPosition(id, onClose);
            },
          );
        } else {
          loader!.finishLoading();
          onClose();
        }
      }
    } catch (e) {
      sNotification.showError(
        intl.something_went_wrong,
      );
      loader!.finishLoading();
    }
  }
}
