import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'model/recurring_delete_request_model.dart';
import 'model/recurring_manage_request_model.dart';
import 'services/remove_recurring_buy_service.dart';
import 'services/switch_recurring_status_service.dart';

class RecurringManageService {
  RecurringManageService(this.dio);

  final Dio dio;

  static final logger = Logger('RecurringManageService');

  Future<void> remove(RecurringDeleteRequestModel model) {
    return removeRecurringBuyService(dio, model);
  }

  Future<void> set(RecurringManageRequestModel model) {
    return switchRecurringStatusService(dio, model);
  }
}
