import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/add_card/add_card_request_model.dart';
import '../model/all_cards/all_cards_response_model.dart';
import '../model/card/card_request_model.dart';
import '../model/circle_card.dart';
import '../model/create_payment/create_payment_request_model.dart';
import '../model/create_payment/create_payment_response_model.dart';
import '../model/delete_card/delete_card_request_model.dart';
import '../model/delete_card/delete_card_response_model.dart';
import '../model/encryption_key/encryption_key_response_model.dart';
import '../model/wire_countries/wire_countries_response_model.dart';
import 'services/add_card_service.dart';
import 'services/all_cards_service.dart';
import 'services/card_service.dart';
import 'services/create_payment_service.dart';
import 'services/delete_card_service.dart';
import 'services/encryption_key_service.dart';
import 'services/wire_countries_service.dart';

class CircleService {
  CircleService(this.dio);

  final Dio dio;

  static final logger = Logger('CircleService');

  Future<CircleCard> addCard(AddCardRequestModel model) {
    return addCardService(dio, model);
  }

  Future<AllCardsResponseModel> allCards() {
    return allCardsService(dio);
  }

  Future<CircleCard> card(CardRequestModel model) {
    return cardService(dio, model);
  }

  Future<CreatePaymentResponseModel> createPayment(
    CreatePaymentRequestModel model,
  ) {
    return createPaymentService(dio, model);
  }

  Future<DeleteCardResponseModel> deleteCard(
    DeleteCardRequestModel model,
  ) {
    return deleteCardService(dio, model);
  }

  Future<EncryptionKeyResponseModel> encryptionKey() {
    return encryptionKeyService(dio);
  }

  Future<WireCountriesResponseModel> wireCountries() {
    return wireCountriesService(dio);
  }
}
