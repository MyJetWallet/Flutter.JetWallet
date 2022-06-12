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
import '../model/payment_info/payment_info_request_model.dart';
import '../model/payment_info/payment_info_response_model.dart';
import '../model/payment_preview/payment_preview_request_model.dart';
import '../model/payment_preview/payment_preview_response_model.dart';
import '../model/wire_countries/wire_countries_response_model.dart';
import 'services/add_card_service.dart';
import 'services/all_cards_service.dart';
import 'services/card_service.dart';
import 'services/create_payment_service.dart';
import 'services/delete_card_service.dart';
import 'services/encryption_key_service.dart';
import 'services/payment_info_service.dart';
import 'services/payment_preview_service.dart';
import 'services/wire_countries_service.dart';

class CircleService {
  CircleService(this.dio);

  final Dio dio;

  static final logger = Logger('CircleService');

  Future<CircleCard> addCard(AddCardRequestModel model, String localeName) {
    return addCardService(dio, model, localeName);
  }

  Future<AllCardsResponseModel> allCards() {
    return allCardsService(dio);
  }

  Future<CircleCard> card(CardRequestModel model, String localeName) {
    return cardService(dio, model, localeName);
  }

  Future<CreatePaymentResponseModel> createPayment(
    CreatePaymentRequestModel model,
    String localeName,
  ) {
    return createPaymentService(dio, model, localeName);
  }

  Future<DeleteCardResponseModel> deleteCard(
    DeleteCardRequestModel model,
    String localeName,
  ) {
    return deleteCardService(dio, model, localeName);
  }

  Future<EncryptionKeyResponseModel> encryptionKey(String localeName) {
    return encryptionKeyService(dio, localeName);
  }

  Future<WireCountriesResponseModel> wireCountries(String localeName) {
    return wireCountriesService(dio, localeName);
  }

  Future<PaymentInfoResponseModel> paymentInfo(
    PaymentInfoRequestModel model,
    String localeName,
  ) {
    return paymentInfoService(dio, model, localeName);
  }

  Future<PaymentPreviewResponseModel> paymentPreview(
    PaymentPreviewRequestModel model,
    String localeName,
  ) {
    return paymentPreviewService(dio, model, localeName);
  }
}
