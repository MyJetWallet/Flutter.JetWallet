import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/create/card_buy_create_request_model.dart';
import '../model/create/card_buy_create_response_model.dart';
import '../model/execute/card_buy_execute_request_model.dart';
import '../model/info/card_buy_info_request_model.dart';
import '../model/info/card_buy_info_response_model.dart';
import 'services/card_buy_create_service.dart';
import 'services/card_buy_execute_service.dart';
import 'services/card_buy_info_service.dart';

class CardBuyService {
  CardBuyService(this.dio);

  final Dio dio;

  static final logger = Logger('CardBuyService');

  Future<CardBuyCreateResponseModel> cardBuyCreatePayment(
    CardBuyCreateRequestModel model,
    String localeName,
  ) {
    return cardBuyCreateService(dio, model, localeName);
  }

  Future<void> cardBuyExecutePayment(
      CardBuyExecuteRequestModel model,
      String localeName,
  ) {
    return cardBuyExecuteService(dio, model, localeName);
  }

  Future<CardBuyInfoResponseModel> cardBuyInfo(
    CardBuyInfoRequestModel model,
    String localeName,
  ) {
    return cardBuyInfoService(dio, model, localeName);
  }
}
