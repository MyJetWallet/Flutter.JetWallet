import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/signal_r/models/earn_audit_history_model.dart';

part 'earn_details_store.g.dart';

class EarnsDetailsStore extends _EarnsDetailsStoreBase with _$EarnsDetailsStore {
  EarnsDetailsStore() : super();

  static _EarnsDetailsStoreBase of(BuildContext context) => Provider.of<EarnsDetailsStore>(context, listen: false);
}

abstract class _EarnsDetailsStoreBase with Store {
  _EarnsDetailsStoreBase();

  @observable
  ObservableList<EarnPositionAuditClientModel> positionAuditsList = ObservableList<EarnPositionAuditClientModel>.of([]);

  @observable
  int skip = 0;

  @observable
  bool hasMore = true;

  @observable
  bool isLoadingInitialData = false;

  @observable
  bool isLoadingPagination = false;

  @action
  Future<void> fetchPositionAudits({
    required String positionId,
    int take = 20,
  }) async {
    try {
      isLoadingInitialData = true;

      final response = await sNetwork.getWalletModule().getEarnAuditPositons(
            positionId: positionId,
            skip: skip.toString(),
            take: take.toString(),
          );

      final positionAudits = response.data?.toList() ?? [];

      if (positionAudits.isNotEmpty) {
        positionAuditsList.addAll(positionAudits);
        skip += positionAudits.length;

        positionAuditsList.sort((a, b) {
          final yearComparison = a.timestamp!.year.compareTo(b.timestamp!.year);
          if (yearComparison != 0) {
            return yearComparison;
          }

          final monthComparison = a.timestamp!.month.compareTo(b.timestamp!.month);
          if (monthComparison != 0) {
            return monthComparison;
          }

          final dayComparison = a.timestamp!.day.compareTo(b.timestamp!.day);
          if (dayComparison != 0) {
            return dayComparison;
          }

          final hourComparison = a.timestamp!.hour.compareTo(b.timestamp!.hour);
          if (hourComparison != 0) {
            return hourComparison;
          }

          return a.timestamp!.minute.compareTo(b.timestamp!.minute);
        });

        isLoadingInitialData = false;
      } else {
        hasMore = false;
      }
    } catch (e) {
      hasMore = false;
    } finally {
      isLoadingInitialData = false;
    }
  }

  @action
  Future<void> loadMorePositionAudits({
    required String positionId,
    int take = 20,
  }) async {
    if (!hasMore || isLoadingPagination) return;

    try {
      if (skip == 0) {
      } else {
        isLoadingPagination = true;
      }

      final response = await sNetwork.getWalletModule().getEarnAuditPositons(
            positionId: positionId,
            skip: skip.toString(),
            take: take.toString(),
          );

      final positionAudits = response.data?.toList() ?? [];

      if (positionAudits.isNotEmpty) {
        positionAuditsList.addAll(positionAudits);
        skip += positionAudits.length;

        positionAuditsList.sort((a, b) {
          final yearComparison = a.timestamp!.year.compareTo(b.timestamp!.year);
          if (yearComparison != 0) {
            return yearComparison;
          }

          final monthComparison = a.timestamp!.month.compareTo(b.timestamp!.month);
          if (monthComparison != 0) {
            return monthComparison;
          }

          final dayComparison = a.timestamp!.day.compareTo(b.timestamp!.day);
          if (dayComparison != 0) {
            return dayComparison;
          }

          final hourComparison = a.timestamp!.hour.compareTo(b.timestamp!.hour);
          if (hourComparison != 0) {
            return hourComparison;
          }

          return a.timestamp!.minute.compareTo(b.timestamp!.minute);
        });
      } else {
        hasMore = false;
      }
    } catch (e) {
      hasMore = false;
    } finally {
      isLoadingPagination = false;
    }
  }
}
