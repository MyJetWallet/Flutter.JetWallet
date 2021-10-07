import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/tranfer_by_phone/transfer_by_phone_request_model.dart';
import '../model/tranfer_by_phone/transfer_by_phone_response_model.dart';
import '../model/transfer_info/transfer_info_request_model.dart';
import '../model/transfer_info/transfer_info_response_model.dart';
import 'services/transfer_by_phone_service.dart';
import 'services/transfer_info_service.dart';

class TransferService {
  TransferService(this.dio);

  final Dio dio;

  static final logger = Logger('TransferService');

  Future<TransferByPhoneResponseModel> transferByPhone(
    TransferByPhoneRequestModel model,
  ) {
    return transferByPhoneService(dio, model);
  }

  Future<TransferInfoResponseModel> transferInfo(
    TransferInfoRequestModel model,
  ) {
    return transferInfoService(dio, model);
  }
}
