import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/add_unlimint_card_request_model.dart';
import '../model/add_unlimint_card_response_model.dart';
import '../model/delete_unlimint_card_request_model.dart';
import '../model/delete_unlimint_card_response_model.dart';
import 'services/add_unlimint_card_service.dart';
import 'services/delete_unlimint_card_service.dart';

class UnlimintService {
  UnlimintService(this.dio);

  final Dio dio;

  static final logger = Logger('UnlimintService');

  Future<AddUnlimintCardResponseModel> addUnlimintCard(
      AddUnlimintCardRequestModel model,
      String localeName,
  ) {
    return addUnlimintCardService(dio, model, localeName);
  }

  Future<DeleteUnlimintCardResponseModel> deleteUnlimintCard(
    DeleteUnlimintCardRequestModel model,
    String localeName,
  ) {
    return deleteUnlimintCardService(dio, model, localeName);
  }
}
