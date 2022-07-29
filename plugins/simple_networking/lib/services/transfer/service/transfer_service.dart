import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/tranfer_by_phone/transfer_by_phone_request_model.dart';
import '../model/tranfer_by_phone/transfer_by_phone_response_model.dart';
import '../model/transfer_cancel/transfer_cancel_request_model.dart';
import '../model/transfer_cancel/transfer_cancel_response_model.dart';
import '../model/transfer_info/transfer_info_request_model.dart';
import '../model/transfer_info/transfer_info_response_model.dart';
import '../model/transfer_resend_request_model/transfer_resend_request_model.dart';
import 'services/transfer_by_phone_service.dart';
import 'services/transfer_cancel_service.dart';
import 'services/transfer_info_service.dart';
import 'services/transfer_resend_service.dart';

class TransferService {
  TransferService(this.dio);

  final Dio dio;

  static final logger = Logger('TransferService');

  Future<TransferByPhoneResponseModel> transferByPhone(
    TransferByPhoneRequestModel model,
    String localeName,
  ) {
    return transferByPhoneService(dio, model, localeName);
  }

  Future<TransferInfoResponseModel> transferInfo(
    TransferInfoRequestModel model,
    String localeName,
  ) {
    return transferInfoService(dio, model, localeName);
  }

  Future<void> transferResend(
    TransferResendRequestModel model,
    String localeName,
  ) {
    return transferResendService(dio, model, localeName);
  }

  Future<TransferCancelResponseModel> transferCancel(
      TransferCancelRequestModel model,
      String localeName,
      ) {
    return transferCancelService(dio, model, localeName);
  }
}
