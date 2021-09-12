import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'model/operation_history_request_model.dart';
import 'model/operation_history_response_model.dart';
import 'services/operation_history_service.dart';

class OperationHistoryService {
  OperationHistoryService(this.dio);

  final Dio dio;

  static final logger = Logger('OperationHistoryService');

  Future<OperationHistoryResponseModel> operationHistory(
      OperationHistoryRequestModel model) {
    return operationHistoryService(dio, model);
  }
}
