import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/signal_r/models/earn_audit_history_model.dart';

part 'earn_details_store.g.dart';

class EarnsDetailsStore extends _EarnsDetailsStoreBase with _$EarnsDetailsStore {
  EarnsDetailsStore() : super();

  _EarnsDetailsStoreBase of(BuildContext context) => Provider.of<EarnsDetailsStore>(context, listen: false);
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
