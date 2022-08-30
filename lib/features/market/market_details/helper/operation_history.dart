import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/features/market/market_details/store/operation_history.dart';

Future<void> operationHistoryInit(
  OperationHistory store,
  String? assetId,
) async {
  try {
    await store.initOperationHistory();
  } catch (_) {
    sNotification.showError(
      intl.something_went_wrong,
      id: 2,
    );
  }
}
