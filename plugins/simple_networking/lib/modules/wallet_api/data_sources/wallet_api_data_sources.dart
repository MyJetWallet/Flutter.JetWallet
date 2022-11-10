import 'package:data_channel/data_channel.dart';
import 'package:dio/dio.dart';
import 'package:simple_networking/api_client/api_client.dart';
import 'package:simple_networking/helpers/handle_api_responses.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/add_card/add_card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/all_cards/all_cards_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/base_asset/get_base_assets_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/base_asset/set_base_assets_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/calculate_earn_offer_apy/calculate_earn_offer_apy_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/calculate_earn_offer_apy/calculate_earn_offer_apy_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card/card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_add/card_add_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_add/card_add_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_add/card_check_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_add/card_check_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_add/card_verification_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_add/card_verification_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_create/card_buy_create_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_create/card_buy_create_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_execute/card_buy_execute_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_info/card_buy_info_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_info/card_buy_info_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_encription_key/card_encription_key_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_remove/card_remove_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_remove/card_remove_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/create_payment/create_payment_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/create_payment/create_payment_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/delete_card/delete_card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/delete_card/delete_card_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/deposit_address/deposit_address_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/deposit_address/deposit_address_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/disclaimer/disclaimers_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/disclaimer/disclaimers_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/earn_offer_deposit/earn_offer_deposit_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/earn_offer_withdrawal/earn_offer_withdrawal_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/encryption_key/encryption_key_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc/check_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/market_info/market_info_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/market_info/market_info_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/market_news/market_news_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/market_news/market_news_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/news/news_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/news/news_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/nft_market/nft_market_buy_order_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/nft_market/nft_market_cancel_sell_order_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/nft_market/nft_market_info_response.dart';
import 'package:simple_networking/modules/wallet_api/models/nft_market/nft_market_is_valid_promo_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/nft_market/nft_market_make_sell_order_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/nft_market/nft_market_preview_buy_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/nft_market/nft_market_preview_sell_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/notification/register_token_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/payment_info/payment_info_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/payment_info/payment_info_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/payment_preview/payment_preview_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/payment_preview/payment_preview_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/profile/profile_delete_account_request.dart';
import 'package:simple_networking/modules/wallet_api/models/profile/profile_delete_reasons_model.dart';
import 'package:simple_networking/modules/wallet_api/models/profile/profile_delete_reasons_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/profile_info/profile_info_reponse_model.dart';
import 'package:simple_networking/modules/wallet_api/models/recurring_manage/recurring_delete_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/recurring_manage/recurring_manage_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/session_info/session_info_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simplex/simplex_payment_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/swap_execute_quote/execute_quote_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/swap_execute_quote/execute_quote_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/tranfer_by_phone/transfer_by_phone_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/tranfer_by_phone/transfer_by_phone_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/transfer_cancel/transfer_cancel_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/transfer_cancel/transfer_cancel_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/transfer_info/transfer_info_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/transfer_info/transfer_info_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/transfer_resend_request_model/transfer_resend_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/unlimint/add_unlimint_card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/unlimint/add_unlimint_card_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/unlimint/delete_unlimint_card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/unlimint/delete_unlimint_card_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/validate_address/validate_address_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/validate_address/validate_address_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/wallet/conversion_price_model.dart';
import 'package:simple_networking/modules/wallet_api/models/wallet_history/wallet_history_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/wallet_history/wallet_history_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/wire_countries/wire_countries_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdraw/withdraw_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdraw/withdraw_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdrawal_info/withdrawal_info_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdrawal_info/withdrawal_info_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdrawal_resend/withdrawal_resend_request.dart';

import '../models/profile/profile_report_request.dart';
import '../models/simplex/simplex_payment_response_model.dart';

class WalletApiDataSources {
  final ApiClient _apiClient;

  WalletApiDataSources(this._apiClient);

  Future<DC<ServerRejectException, DepositAddressResponseModel>>
      postDepositAddressRequest(
    DepositAddressRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/blockchain/generate-deposit-address',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(DepositAddressResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, DepositAddressResponseModel>>
      postDepositNFTAddressRequest() async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/blockchain/generate-nft-deposit-address',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(DepositAddressResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, ValidateAddressResponseModel>>
      postValidateAddressRequest(
    ValidateAddressRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/blockchain/validate-address',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(ValidateAddressResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, WithdrawResponseModel>> postWithdrawRequest(
    WithdrawRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/blockchain/withdrawal',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(WithdrawResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, WithdrawalInfoResponseModel>>
      postWithdrawalInfoRequest(
    WithdrawalInfoRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/blockchain/withdrawal-info',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(WithdrawalInfoResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, bool>> postWithdrawalResendRequest(
    WithdrawalResendRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/blockchain/withdrawal-resend',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        handleResultResponse(responseData);

        return DC.data(true);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, WalletHistoryResponseModel>>
      getWalletHistoryRequest(
    WalletHistoryRequestModel model,
  ) async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/portfolio/history-graph',
        queryParameters: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(WalletHistoryResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  /// Circle
  Future<DC<ServerRejectException, CircleCard>> postAddCardRequest(
    AddCardRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/circle/add-card',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(CircleCard.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, AllCardsResponseModel>>
      getAllCardsRequest() async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/circle/get-cards-all',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = responseData['data'] as List;

        return DC.data(AllCardsResponseModel.fromList(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, CircleCard>> postCardRequest(
    CardRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/circle/get-card',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse(
          responseData,
        );

        return DC.data(CircleCard.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, CardAddResponseModel>> cardAdd(
    CardAddRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/buy/add-card',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse(
          responseData,
        );

        return DC.data(CardAddResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, CardCheckResponseModel>> cardCheck(
    CardCheckRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/kyc/verification/card_check',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse(
          responseData,
        );

        return DC.data(CardCheckResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, CardCheckResponseModel>> cardStart(
    CardCheckRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/kyc/verification/card_start',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse(
          responseData,
        );

        return DC.data(CardCheckResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, CardVerificationResponseModel>>
      cardVerification(
    CardVerificationRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/kyc/verification/card_verification_check',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse(
          responseData,
        );

        return DC.data(CardVerificationResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, CardRemoveResponseModel>> cardRemove(
    CardRemoveRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/buy/delete-card',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse(
          responseData,
        );

        return DC.data(CardRemoveResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, EncryptionKeyCardResponseModel>>
      encryptionKey() async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/trading/buy/get-encryption-key',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse(
          responseData,
        );

        return DC.data(EncryptionKeyCardResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, CreatePaymentResponseModel>>
      postCreatePaymentRequest(
    CreatePaymentRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/circle/create-payment',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse(
          responseData,
        );

        return DC.data(CreatePaymentResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, DeleteCardResponseModel>>
      postDeleteCardRequest(
    DeleteCardRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/circle/delete-card',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(DeleteCardResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, EncryptionKeyResponseModel>>
      getEncryptionKeyRequest() async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/circle/get-encryption-key',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(EncryptionKeyResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, PaymentInfoResponseModel>>
      getPaymentInfoRequest(
    PaymentInfoRequestModel model,
  ) async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/circle/get-payment-info/${model.depositId}',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(PaymentInfoResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, PaymentPreviewResponseModel>>
      postPaymentPreviewRequest(
    PaymentPreviewRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/circle/get-payment-preview',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(PaymentPreviewResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, WireCountriesResponseModel>>
      getWireCountriesRequest() async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/circle/wire-countries',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(WireCountriesResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, SessionInfoResponseModel>>
      getSessionInfoRequest() async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/info/session-info',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(SessionInfoResponseModel.fromJson(data));
      } on ServerRejectException catch (error) {
        return DC.error(error);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DC<ServerRejectException, ProfileInfoResponseModel>>
      getProfileInfoRequest() async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/profile/info',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(ProfileInfoResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, CardBuyCreateResponseModel>>
      postCardBuyCreateRequest(
    CardBuyCreateRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/buy/create',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(CardBuyCreateResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, bool>> postCardBuyExecuteRequest(
    CardBuyExecuteRequestModel model,
  ) async {
    final jsonModel = model.toJson();
    if (model.cardPaymentData != null) {
      final jsonCardModel = model.cardPaymentData!.toJson();
      jsonModel.remove('cardPaymentData');
      jsonModel.addAll({
        'cardPaymentData': jsonCardModel,
      });
    }
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/buy/execute',
        data: jsonModel,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        handleResultResponse(responseData);

        return DC.data(true);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, CardBuyInfoResponseModel>>
      postCardBuyInfoRequest(
    CardBuyInfoRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/buy/info',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );
        validateRejectResponse(responseData);

        return DC.data(CardBuyInfoResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, DisclaimersResponseModel>>
      getDisclaimersRequest() async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/profile/disclaimers',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(DisclaimersResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, DisclaimersResponseModel>>
      getNftDisclaimersRequest() async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/profile/nft-disclaimers',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(DisclaimersResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, DisclaimersResponseModel>>
      getHighYieldDisclaimersRequest() async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/profile/highyield-disclaimers',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(DisclaimersResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, bool>> postSaveDisclaimerRequest(
    DisclaimersRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/profile/disclaimers',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        handleResultResponse(responseData);

        return DC.data(true);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  /// High Yield
  Future<DC<ServerRejectException, CalculateEarnOfferApyResponseModel>>
      postCalculateEarnOfferApyRequest(
    CalculateEarnOfferApyRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/high-yield/calculate-earn-offer-apy',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(CalculateEarnOfferApyResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postEarnOfferDepositRequest(
    EarnOfferDepositRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/high-yield/earn-offer-deposit',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        handleResultResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postEarnOfferWithdrawalRequest(
    EarnOfferWithdrawalRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/high-yield/earn-offer-withdrawal',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        handleResultResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  /// KEY VALUE

  Future<DC<ServerRejectException, void>> postRemoveKeyValueRequest(
    List<String> keys,
  ) async {
    try {
      final _ = await _apiClient.post(
        '${_apiClient.options.walletApi}/key-value/remove',
      );

      try {
        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postSetKeyValueRequest(
    KeyValueRequestModel model,
  ) async {
    try {
      final _ = await _apiClient.post(
        '${_apiClient.options.walletApi}/key-value/set',
        data: model,
      );

      try {
        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  /// KYC

  Future<DC<ServerRejectException, CheckResponseModel>>
      postKycCheckRequest() async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/kyc/verification/kyc_checks',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(CheckResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postKycStartRequest() async {
    try {
      final _ = await _apiClient.get(
        '${_apiClient.options.walletApi}/kyc/verification/kyc_start',
      );

      try {
        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postUploadDocumentsRequest(
    FormData formData,
    int documentType,
  ) async {
    try {
      final _ = await _apiClient.post(
        '${_apiClient.options.walletApi}/kyc/verification/kyc_documents/$documentType',
        data: formData,
      );

      try {
        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, MarketInfoResponseModel>>
      postMarketInfoRequest(
    MarketInfoRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/market/info',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(MarketInfoResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, MarketNewsResponseModel>>
      postMarketNewsRequest(
    MarketNewsRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/market/news',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(MarketNewsResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, NewsResponseModel>> postNewsRequest(
    NewsRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/market/news',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(NewsResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postRegisterTokenRequest(
    RegisterTokenRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/push/token',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullResponse<Map>(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, OperationHistoryResponseModel>>
      getOperationHistoryRequest(
    OperationHistoryRequestModel model,
  ) async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/history/wallet-history/operation-history',
        queryParameters: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<List>(responseData);

        return DC.data(OperationHistoryResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, List<ProfileDeleteReasonsModel>>>
      postProfileDeleteReasonsRequest(
    String localeName,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/profile/delete-reasons',
        data: ProfileDeleteReasonsRequestModel(language: localeName).toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final out = <ProfileDeleteReasonsModel>[];
        for (final element in responseData['data']) {
          out.add(
            ProfileDeleteReasonsModel.fromJson(element as Map<String, dynamic>),
          );
        }

        return DC.data(out);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postProfileDeleteRequest(
    String tokenId,
    List<String> deletionReasonIds,
  ) async {
    try {
      final _ = await _apiClient.post(
        '${_apiClient.options.walletApi}/profile/delete-profile',
        data: ProfileDeleteAccountRequest(
          tokenId: tokenId,
          deletionReasonIds: deletionReasonIds,
        ).toJson(),
      );

      try {
        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postProfileReportRequest(
    String messageId,
  ) async {
    try {
      final _ = await _apiClient.post(
        '${_apiClient.options.walletApi}/profile/report-message',
        data: ProfileReportRequest(
          messageId: messageId,
        ).toJson(),
      );

      try {
        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> deleteRemoveRecurringBuyRequest(
    RecurringDeleteRequestModel model,
  ) async {
    try {
      final _ = await _apiClient.delete(
        '${_apiClient.options.walletApi}/trading/invest/delete',
        data: model,
      );

      try {
        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postSwitchRecurringStatusRequest(
    RecurringManageRequestModel model,
  ) async {
    try {
      final _ = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/invest/switch',
        data: model,
      );

      try {
        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, SimplexPaymentResponseModel>>
      postSimplexPaymentRequest(
    SimplexPaymentRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/simplex/payment',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(SimplexPaymentResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, ExecuteQuoteResponseModel>>
      postExecuteQuoteRequest(
    ExecuteQuoteRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/swap/execute-quote',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(ExecuteQuoteResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, GetQuoteResponseModel>> postGetQuoteRequest(
    GetQuoteRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/swap/get-quote',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(GetQuoteResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, TransferByPhoneResponseModel>>
      postTransferByPhoneRequest(
    TransferByPhoneRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/transfer/by-phone',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(TransferByPhoneResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, TransferCancelResponseModel>>
      postTransferCancelRequest(
    TransferCancelRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/transfer/transfer-cancel',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(TransferCancelResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, TransferInfoResponseModel>>
      postTransferInfoRequest(
    TransferInfoRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/transfer/transfer-info',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(TransferInfoResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postTransferResendRequest(
    TransferResendRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/transfer/transfer-resend',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        handleResultResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, ConversionPriceModel>>
      getConversionPriceRequest(
    String baseAssetSymbol,
    String quotedAssetSymbol,
  ) async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/wallet/conversion-price/$baseAssetSymbol/$quotedAssetSymbol',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(ConversionPriceModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, AddUnlimintCardResponseModel>>
      postAddUnlimintCardRequest(
    AddUnlimintCardRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/unlimint-card/save',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(AddUnlimintCardResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, DeleteUnlimintCardResponseModel>>
      postDeleteUnlimintCardRequest(
    DeleteUnlimintCardRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/unlimint-card/remove',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(DeleteUnlimintCardResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, NftMarketInfoResponseModel>>
      getNFTMarketInfoRequest(
    String symbol,
  ) async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/trading/nft-market/info/$symbol',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(NftMarketInfoResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, NftMarketIsValidPromoResponseModel>>
      getNFTMarketIsValidPromoRequest(
    String promocode,
  ) async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/trading/nft-market/is-valid-promo/$promocode',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(NftMarketIsValidPromoResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, NftMarketPreviewBuyResponseModel>>
      getNFTMarketPreviewBuyRequest(
    String symbol,
    String? promocode,
  ) async {
    try {
      String link =
          '${_apiClient.options.walletApi}/trading/nft-market/preview-buy/$symbol';

      if (promocode != null) {
        link = '$link?promoCode=$promocode';
      }

      final response = await _apiClient.get(
        link,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(NftMarketPreviewBuyResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, NftMarketPreviewSellResponseModel>>
      getNFTMarketPreviewSellRequest(
    String symbol,
  ) async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/trading/nft-market/preview-sell/$symbol',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(NftMarketPreviewSellResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, bool>> postNFTMarketMakeSellOrderRequest(
    NftMarketMakeSellOrderRequestModel model,
  ) async {
    try {
      final _ = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/nft-market/make-sell-order',
        data: model.toJson(),
      );

      try {
        //final responseData = response.data as Map<String, dynamic>;
        //final data = handleFullResponse<Map>(responseData);

        return DC.data(true);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, bool>> postNFTMarketCancelSellOrderRequest(
    NftMarketCancelSellOrderRequestModel model,
  ) async {
    try {
      final _ = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/nft-market/cancel-sell-order',
        data: model.toJson(),
      );

      try {
        //final responseData = response.data as Map<String, dynamic>;
        //final data = handleFullResponse<Map>(responseData);

        return DC.data(true);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, bool>> postNFTMarketBuyOrderRequest(
    NftMarketBuyOrderRequestModel model,
  ) async {
    try {
      final _ = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/nft-market/buy-order',
        data: model.toJson(),
      );

      try {
        //final responseData = response.data as Map<String, dynamic>;
        //final data = handleFullResponse<Map>(responseData);

        return DC.data(true);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  /// Base asset
  Future<DC<ServerRejectException, void>> setBaseAssetRequest(
    SetBaseAssetsRequestModel model,
  ) async {
    try {
      final _ = await _apiClient.post(
        '${_apiClient.options.walletApi}/base-asset/set',
        data: model,
      );

      try {
        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, GetBaseAssetsResponseModel>>
      getBaseAssetsListRequest() async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/base-asset/available-list',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(GetBaseAssetsResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }
}
