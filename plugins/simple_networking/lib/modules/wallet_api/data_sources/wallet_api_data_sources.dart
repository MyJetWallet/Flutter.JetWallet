import 'package:data_channel/data_channel.dart';
import 'package:dio/dio.dart';
import 'package:simple_networking/api_client/api_client.dart';
import 'package:simple_networking/helpers/handle_api_responses.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/auth_api/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/create_banking_account_simple_response.dart';
import 'package:simple_networking/modules/signal_r/models/rewards_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/simple_coin_history_model.dart';
import 'package:simple_networking/modules/wallet_api/models/add_card/add_card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';
import 'package:simple_networking/modules/wallet_api/models/all_cards/all_cards_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/apple_pay_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/banking_withdrawal/banking_withdrawal_preview_model.dart';
import 'package:simple_networking/modules/wallet_api/models/banking_withdrawal/banking_withdrawal_preview_response.dart';
import 'package:simple_networking/modules/wallet_api/models/banking_withdrawal/banking_withdrawal_request.dart';
import 'package:simple_networking/modules/wallet_api/models/banners/close_banner_request_model.dart';
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
import 'package:simple_networking/modules/wallet_api/models/earn_close_position/earn_close_position_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/earn_deposit_position/earn_deposit_position_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/earn_offer_deposit/earn_offer_deposit_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/earn_offer_request/earn_offer_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/earn_offer_withdrawal/earn_offer_withdrawal_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/earn_withdraw_position/earn_withdraw_position_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/encryption_key/encryption_key_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/fee_info/fee_preview_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/fee_info/fee_preview_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/google_pay/google_pay_confirm_model.dart';
import 'package:simple_networking/modules/wallet_api/models/iban_withdrawal/iban_preview_withdrawal_model.dart';
import 'package:simple_networking/modules/wallet_api/models/iban_withdrawal/iban_withdrawal_model.dart';
import 'package:simple_networking/modules/wallet_api/models/invest_transfer/invest_transfer_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/invest_transfer/invest_transfer_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc/apply_country_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc/apply_country_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc/check_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc/kyc_plan_responce_model.dart';
import 'package:simple_networking/modules/wallet_api/models/limits/buy_limits_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/limits/buy_limits_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/limits/sell_limits_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/limits/sell_limits_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/limits/swap_limits_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/limits/swap_limits_response_model.dart';
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
import 'package:simple_networking/modules/wallet_api/models/p2p_methods/p2p_methods_responce_model.dart';
import 'package:simple_networking/modules/wallet_api/models/payment_info/payment_info_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/payment_info/payment_info_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/payment_preview/payment_preview_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/payment_preview/payment_preview_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/buy_prepaid_card_intention_dto_list_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/buy_purchase_card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/buy_purchase_card_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/card_countries_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/get_purchase_card_brands_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/get_purchase_card_list_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/get_vouncher_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/purchase_card_brand_list_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/profile/profile_change_email_request.dart';
import 'package:simple_networking/modules/wallet_api/models/profile/profile_delete_account_request.dart';
import 'package:simple_networking/modules/wallet_api/models/profile/profile_delete_reasons_model.dart';
import 'package:simple_networking/modules/wallet_api/models/profile/profile_delete_reasons_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/profile_info/profile_info_reponse_model.dart';
import 'package:simple_networking/modules/wallet_api/models/recurring_manage/recurring_delete_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/recurring_manage/recurring_manage_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/rewards/reward_spin_response.dart';
import 'package:simple_networking/modules/wallet_api/models/sell/execute_crypto_sell_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/sell/get_crypto_sell_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/sell/get_crypto_sell_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/send_gift/gift_model.dart';
import 'package:simple_networking/modules/wallet_api/models/send_globally/send_to_bank_card_response.dart';
import 'package:simple_networking/modules/wallet_api/models/send_globally/send_to_bank_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/session_info/session_info_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_request.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_limits_request.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_limits_responce.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_sensitive_request.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_set_password_request.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_terminate_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simplex/simplex_payment_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/swap_execute_quote/execute_quote_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/swap_execute_quote/execute_quote_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/tranfer_by_phone/transfer_by_phone_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/tranfer_by_phone/transfer_by_phone_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/transfer/account_transfer_preview_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/transfer/account_transfer_preview_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/transfer/account_transfer_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/transfer/account_transfer_response_model.dart';
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
import 'package:simple_networking/modules/wallet_api/models/wallet/set_active_assets_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/wallet_history/wallet_history_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/wallet_history/wallet_history_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/wire_countries/wire_countries_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdraw/withdraw_preview_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdraw/withdraw_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdraw/withdraw_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdrawal_info/withdrawal_info_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdrawal_info/withdrawal_info_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdrawal_resend/withdrawal_resend_request.dart';
import 'dart:developer' as dev;
import '../../../simple_networking.dart';
import '../../signal_r/models/earn_audit_history_model.dart';
import '../../signal_r/models/invest_positions_model.dart';
import '../models/iban_info/iban_info_response_model.dart';
import '../models/invest/new_invest_request_model.dart';
import '../models/profile/profile_report_request.dart';
import '../models/profile/profile_set_address_request.dart';
import '../models/simple_card/simple_card_remind_pin_response.dart';
import '../models/simple_card/simple_card_sevsitive_response.dart';
import '../models/simplex/simplex_payment_response_model.dart';

class WalletApiDataSources {
  final ApiClient _apiClient;

  WalletApiDataSources(this._apiClient);

  Future<DC<ServerRejectException, DepositAddressResponseModel>> postDepositAddressRequest(
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

  Future<DC<ServerRejectException, DepositAddressResponseModel>> postDepositNFTAddressRequest() async {
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

  Future<DC<ServerRejectException, ValidateAddressResponseModel>> postValidateAddressRequest(
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

  Future<DC<ServerRejectException, WithdrawResponseModel>> postWithdrawJarRequest(
    WithdrawJarRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/blockchain/withdrawal/jar',
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

  Future<DC<ServerRejectException, WithdrawJarLimitResponseModel>> postWithdrawJarLimitRequest(
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/blockchain/withdrawal/jar/limit',
        data: body,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(WithdrawJarLimitResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, WithdrawPreviewResponseModel>> postWithdrawJarPreviewRequest(
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/blockchain/withdrawal/jar/preview',
        data: body,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(WithdrawPreviewResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, WithdrawPreviewResponseModel>> postWithdrawPreviewRequest(
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/blockchain/withdrawal/preview',
        data: body,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(WithdrawPreviewResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, WithdrawalInfoResponseModel>> postWithdrawalInfoRequest(
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

  Future<DC<ServerRejectException, WalletHistoryResponseModel>> getWalletHistoryRequest(
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

  Future<DC<ServerRejectException, void>> setActiveAssetslRequest(
    SetActiveAssetsRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/wallet/set-active-assets',
        data: model,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullResponse(responseData);

        return DC.data(null);
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

  Future<DC<ServerRejectException, AllCardsResponseModel>> getAllCardsRequest() async {
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

  Future<DC<ServerRejectException, void>> updateCardLabel(
    String cardId,
    String label,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/buy/update-card-label',
        data: {'cardId': cardId, 'label': label},
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final _ = handleFullResponse(responseData);

        return DC.data(null);
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

  Future<DC<ServerRejectException, CardVerificationResponseModel>> cardVerification(
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

  Future<DC<ServerRejectException, String>> postSDKTokenRequest(
    String country,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/kyc/verification/sdk_token',
        data: {
          'countryCode': country,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse(
          responseData,
        );

        return DC.data(data['data']['token']);
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

  Future<DC<ServerRejectException, EncryptionKeyCardResponseModel>> encryptionKey() async {
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

  Future<DC<ServerRejectException, CreatePaymentResponseModel>> postCreatePaymentRequest(
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

  Future<DC<ServerRejectException, DeleteCardResponseModel>> postDeleteCardRequest(
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

  Future<DC<ServerRejectException, EncryptionKeyResponseModel>> getEncryptionKeyRequest() async {
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

  Future<DC<ServerRejectException, PaymentInfoResponseModel>> getPaymentInfoRequest(
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

  Future<DC<ServerRejectException, PaymentPreviewResponseModel>> postPaymentPreviewRequest(
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

  Future<DC<ServerRejectException, WireCountriesResponseModel>> getWireCountriesRequest() async {
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

  Future<DC<ServerRejectException, SessionInfoResponseModel>> getSessionInfoRequest() async {
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

  Future<DC<ServerRejectException, ProfileInfoResponseModel>> getProfileInfoRequest() async {
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

  Future<DC<ServerRejectException, void>> postCardSoonRequest() async {
    try {
      final responce = await _apiClient.get(
        '${_apiClient.options.walletApi}/profile/request-card',
      );

      try {
        final responseData = responce.data as Map<String, dynamic>;

        handleFullResponse<Map>(
          responseData,
        );

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, CardBuyCreateResponseModel>> postCardBuyCreateRequest(
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

  Future<DC<ServerRejectException, GetCryptoSellResponseModel>> postSellCreateRequest(
    GetCryptoSellRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/sell/create',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(GetCryptoSellResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, GetCryptoSellResponseModel>> postSellExecuteRequest(
    ExecuteCryptoSellRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/sell/execute',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(GetCryptoSellResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, bool>> postApplePayConfirmRequest(
    String depositId,
    String applePayToken,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/public/applepay/confirm',
        data: {
          'depositId': depositId,
          'applePayToken': applePayToken,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        handleFullResponse<Map>(
          responseData,
        );

        return DC.data(true);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, ApplePayResponseModel>> getApplePayInfoRequest(
    String depositId,
  ) async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/public/applepay/info/$depositId',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(ApplePayResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, GooglePayConfirmModel>> postGooglePayConfirmRequest(
    String depositId,
    String googlePayToken,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/public/googlepay/confirm',
        data: {
          'depositId': depositId,
          'googlePayToken': googlePayToken,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(GooglePayConfirmModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, ApplePayResponseModel>> getGooglePayInfoRequest(
    String depositId,
  ) async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/public/googlepay/info/$depositId',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(ApplePayResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, bool>> postCardBuyExecuteRequest(
    CardBuyExecuteRequestModel model, {
    CancelToken? cancelToken,
  }) async {
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
        cancelToken: cancelToken,
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

  Future<DC<ServerRejectException, CardBuyInfoResponseModel>> postCardBuyInfoRequest(
    CardBuyInfoRequestModel model, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/buy/info',
        data: model.toJson(),
        cancelToken: cancelToken,
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

  Future<DC<ServerRejectException, DisclaimersResponseModel>> getDisclaimersRequest() async {
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

  Future<DC<ServerRejectException, DisclaimersResponseModel>> getNftDisclaimersRequest() async {
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

  Future<DC<ServerRejectException, DisclaimersResponseModel>> getHighYieldDisclaimersRequest() async {
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
  Future<DC<ServerRejectException, CalculateEarnOfferApyResponseModel>> postCalculateEarnOfferApyRequest(
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

  Future<DC<ServerRejectException, void>> postEarnOfferCreatePosition(
    EarnOfferRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/earn/create-position',
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

  Future<DC<ServerRejectException, CheckResponseModel>> postKycCheckRequest() async {
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

  Future<DC<ServerRejectException, String>> postFaceSDKTokenRequest(String countryCode) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/kyc/verification/face_sdk_token',
        data: {
          'countryCode': countryCode,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse(
          responseData,
        );

        return DC.data(data['data']['token']);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, int>> postFaceCheckStatusRequest() async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/kyc/verification/face_check_status',
        data: {},
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse(
          responseData,
        );

        return DC.data(data['data']['status']);
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
    String country,
  ) async {
    try {
      final _ = await _apiClient.post(
        '${_apiClient.options.walletApi}/kyc/verification/kyc_documents/$documentType/$country',
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

  Future<DC<ServerRejectException, KycPlanResponceModel>> postKycPlanRequest() async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/kyc/verification/kyc_plan',
        data: {},
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(KycPlanResponceModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, ApplyCountryResponseModel>> postKYCAplyCountryRequest(
      ApplyCountryRequestModel model) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/kyc/verification/apply_country',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(ApplyCountryResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, MarketInfoResponseModel>> postMarketInfoRequest(
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

  Future<DC<ServerRejectException, IbanInfoResponseModel>> getIbanInfoRequest() async {
    try {
      const testModel = DeleteCardRequestModel(cardId: 'test');
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/iban/get-iban-details',
        data: testModel.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(IbanInfoResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, MarketNewsResponseModel>> postMarketNewsRequest(
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

  Future<DC<ServerRejectException, OperationHistoryResponseModel>> getOperationHistoryRequest(
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

  Future<DC<ServerRejectException, OperationHistoryItem>> getOperationHistoryOperationIDRequest(
    String operationId,
  ) async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/history/wallet-history/operation-history/$operationId',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(OperationHistoryItem.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, List<ProfileDeleteReasonsModel>>> postProfileDeleteReasonsRequest(
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

  Future<DC<ServerRejectException, void>> postSetAddressRequest(
    ProfileSetAddressRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/profile/set-address',
        data: model,
      );

      final responseData = response.data as Map<String, dynamic>;
      final _ = handleFullResponse<List>(responseData);

      try {
        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, ProfileChangeEmailRequest>> postEmailChangeRequest(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/profile/email-change-request',
        data: data,
      );

      final responseData = response.data as Map<String, dynamic>;
      final dataResponse = handleFullResponse<Map>(responseData);

      try {
        return DC.data(ProfileChangeEmailRequest.fromJson(dataResponse));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postEmailVerifyRequest(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/profile/email-change-verify',
        data: data,
      );

      final responseData = response.data as Map<String, dynamic>;
      final _ = handleFullResponse(responseData);

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

  Future<DC<ServerRejectException, SimplexPaymentResponseModel>> postSimplexPaymentRequest(
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

  Future<DC<ServerRejectException, ExecuteQuoteResponseModel>> postExecuteQuoteRequest(
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

  Future<DC<ServerRejectException, TransferByPhoneResponseModel>> postTransferByPhoneRequest(
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

  Future<DC<ServerRejectException, TransferCancelResponseModel>> postTransferCancelRequest(
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

  Future<DC<ServerRejectException, TransferInfoResponseModel>> postTransferInfoRequest(
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

  Future<DC<ServerRejectException, ConversionPriceModel>> getConversionPriceRequest(
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

  Future<DC<ServerRejectException, AddUnlimintCardResponseModel>> postAddUnlimintCardRequest(
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

  Future<DC<ServerRejectException, DeleteUnlimintCardResponseModel>> postDeleteUnlimintCardRequest(
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

  Future<DC<ServerRejectException, NftMarketInfoResponseModel>> getNFTMarketInfoRequest(
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

  Future<DC<ServerRejectException, NftMarketIsValidPromoResponseModel>> getNFTMarketIsValidPromoRequest(
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

  Future<DC<ServerRejectException, NftMarketPreviewBuyResponseModel>> getNFTMarketPreviewBuyRequest(
    String symbol,
    String? promocode,
  ) async {
    try {
      String link = '${_apiClient.options.walletApi}/trading/nft-market/preview-buy/$symbol';

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

  Future<DC<ServerRejectException, NftMarketPreviewSellResponseModel>> getNFTMarketPreviewSellRequest(
      String symbol, String assetSymbol) async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/trading/nft-market/preview-sell/$symbol',
        queryParameters: {'assetSymbol': assetSymbol},
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

  Future<DC<ServerRejectException, GetBaseAssetsResponseModel>> getBaseAssetsListRequest() async {
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

  Future<DC<ServerRejectException, void>> debugErrorRequest() async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi!.replaceAll("/v1", "")}/debug/error',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> debugRejectRequest() async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi!.replaceAll("/v1", "")}/debug/reject',
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

  Future<DC<ServerRejectException, void>> sendToBankCardRequest(
    SendToBankRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/send-globally/Send-to-bank-card',
        data: model,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, SendToBankCardResponse>> sendToBankCardPreviewRequest(
    SendToBankRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/send-globally/Send-to-bank-card-preview',
        data: model,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(SendToBankCardResponse.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> sendGiftByEmailRequest(
    SendGiftByEmailRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/gift/by-email',
        data: model,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> sendGiftByPhoneRequest(
    SendGiftByPhoneRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/gift/by-phone',
        data: model,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> cancelGiftRequest(
    String operationId,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/gift/cancel',
        data: {'id': operationId},
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, GiftModel>> getGiftRequest(
    String id,
  ) async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/gift/$id',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(GiftModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> acceptGiftRequest(
    String id,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/gift/accept',
        data: {'id': id},
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> declineGiftRequest(
    String id,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/gift/decline',
        data: {'id': id},
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, AddressBookModel>> getAddressBookRequest(
    int accountType,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/address-book/contacts',
        data: {
          'accountType': accountType,
          "withIban": true,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(AddressBookModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, AddressBookContactModel>> postAddressBookAddRequest(
    String name,
    String nickname,
    String iban,
    String bic,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/address-book/add',
        data: {
          'name': name,
          'nickname': nickname,
          'iban': iban,
          'bic': bic,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(AddressBookContactModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, AddressBookContactModel>> postAddressBookAddSimpleRequest(
    String name,
    String iban,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/address-book/add/simple',
        data: {
          'name': name,
          'iban': iban,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(AddressBookContactModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, AddressBookContactModel>> postAddressBookAddPersonalRequest(
    String name,
    String iban,
    String bic,
    String country,
    String fullName,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/address-book/add/personal',
        data: {
          'name': name,
          'iban': iban,
          'bic': bic,
          'bankCountry': country,
          'fullName': fullName,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(AddressBookContactModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postAddressBookDeleteRequest(
    String id,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/address-book/delete',
        data: {
          'id': id,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final _ = handleFullResponse<Map>(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postAddressBookEditRequest(
    AddressBookContactModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/address-book/edit',
        data: model,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final _ = handleFullResponse<Map>(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postIbanWithdrawalRequest(
    IbanWithdrawalModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/iban/withdrawal',
        data: model,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final _ = handleFullResponse<Map>(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, IbanPreviewWithdrawalModel>> postPreviewIbanWithdrawalRequest(
    IbanWithdrawalModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/iban/preview-withdrawal',
        data: model,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(IbanPreviewWithdrawalModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, RewardSpinResponse>> postRewardSpinRequest() async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/rewards/spin',
        data: {},
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(RewardSpinResponse.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postRewardClaimRequest(
    RewardsBalance data,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/rewards/claim',
        data: data,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final _ = handleFullResponse<Map>(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  // Banking

  Future<DC<ServerRejectException, CreateBankingAccountSimpleResponse>> postAccountCreateRequest(
    String requestId,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/account/create',
        data: {
          'requestId': requestId,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(CreateBankingAccountSimpleResponse.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, CreateBankingAccountSimpleResponse>> postSimpleAccountCreateRequest() async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/account/create/simple',
        data: {},
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(CreateBankingAccountSimpleResponse.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postAccountChangeLabelRequest({
    required String accountId,
    required String label,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/account/change-label',
        data: {
          'accountId': accountId,
          'label': label,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final _ = handleFullResponse<Map>(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, String>> postBankingKycStartRequest() async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/kyc-start',
        data: {},
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(data['token']);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, BankingWithdrawalPreviewResponse>> postBankingWithdrawalPreviewRequest(
    BankingWithdrawalPreviewModel request,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/account/withdrawal-preview',
        data: request.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(BankingWithdrawalPreviewResponse.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, String>> postBankingWithdrawalRequest(BankingWithdrawalRequest request) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/account/withdrawal',
        data: request.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(data['operationId']);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, SimpleCardCreateResponse>> postSimpleCardCreateRequest(
    SimpleCardCreateRequest data,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/virtual-card/create',
        data: data,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final fullResponse = handleFullResponse<Map>(responseData);

        return DC.data(SimpleCardCreateResponse.fromJson(fullResponse));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, SimpleCardSensitiveResponse>> postSensitiveDataRequest(
    SimpleCardSensitiveRequest data,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/card/sensitive',
        data: data.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final fullResponse = handleFullResponse<Map>(responseData);

        return DC.data(SimpleCardSensitiveResponse.fromJson(fullResponse));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, SimpleCardRemindPinResponse>> postRemindPinPhoneRequest({
    required String cardId,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/card/remind-pin-phone',
        data: {
          'cardId': cardId,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final fullResponse = handleFullResponse<Map>(responseData);

        return DC.data(SimpleCardRemindPinResponse.fromJson(fullResponse));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, String>> postRemindPinRequest({
    required String cardId,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/card/remind-pin',
        data: {
          'cardId': cardId,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final fullResponse = handleFullResponse<Map>(responseData);

        return DC.data(fullResponse['operationId']);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postCardSetPasswordRequest(
    SimpleCardSetPasswordRequest data,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/card/set-password',
        data: data,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final _ = handleFullResponse<Map>(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postCardChangePasswordRequest(
    SimpleCardSetPasswordRequest data,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/card/change-password',
        data: data,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final _ = handleFullResponse<Map>(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postCardFreezeRequest({
    required String cardId,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/card/freeze',
        data: {
          'cardId': cardId,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final _ = handleFullResponse<Map>(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postCardUnfreezeRequest({
    required String cardId,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/card/unfreeze',
        data: {
          'cardId': cardId,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final _ = handleFullResponse<Map>(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postCardTerminateRequest(
    SimpleCardTerminateRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/card/terminate',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final _ = handleFullResponse<Map>(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, SimpleCardLimitsResponceModel>> postCardLimitsRequest(
    SimpleCardLimitsRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/card/limits',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(SimpleCardLimitsResponceModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, BuyLimitsResponseModel>> postBuyLimitsRequest(
    BuyLimitsRequestModel request,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/buy/limits',
        data: request.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(BuyLimitsResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, SellLimitsResponseModel>> postSellLimitsRequest(
    SellLimitsRequestModel request,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/sell/limits',
        data: request.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(SellLimitsResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, SwapLimitsResponseModel>> postSwapLimitsRequest(
    SwapLimitsRequestModel request,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/trading/swap/limits',
        data: request.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(SwapLimitsResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  // Transfer
  Future<DC<ServerRejectException, AccountTransferPreviewResponseModel>> postTransferPreviewRequest(
    AccountTransferPreviewRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/account/transfer-preview',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(AccountTransferPreviewResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, AccountTransferResponseModel>> postTransferRequest(
    AccountTransferRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/account/transfer',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(AccountTransferResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  // invest
  Future<DC<ServerRejectException, AssetModelAdm>> getAsset({
    required String assetId,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/InvestTrading/InvestReader/get-asset',
        data: {
          "AssetId": assetId,
        },
      );

      dev.log('response: $response');

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(AssetModelAdm.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, InvestPositionResponseModel>> createActivePositionRequest({
    required NewInvestRequestModel model,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/InvestTrading/InvestAction/create-market-open-position',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(InvestPositionResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, InvestPositionResponseModel>> createPendingLimitPositionRequest({
    required NewInvestOrderRequestModel model,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/InvestTrading/InvestAction/create-pending-limit-position',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(InvestPositionResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, InvestPositionResponseModel>> createPendingStopPositionRequest({
    required NewInvestOrderRequestModel model,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/InvestTrading/InvestAction/create-pending-stop-position',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(InvestPositionResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, InvestPositionResponseModel>> changePendingPrice({
    required String id,
    required double price,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/InvestTrading/InvestAction/change-pending-price',
        data: {
          "positionId": id,
          "pendingPrice": price,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(InvestPositionResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, InvestPositionResponseModel>> cancelPendingPositionRequest({
    required String positionId,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/InvestTrading/InvestAction/cancel-pending-position',
        data: {
          "positionId": positionId,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(InvestPositionResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, InvestPositionResponseModel>> closeActivePositionRequest({
    required String positionId,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/InvestTrading/InvestAction/close-active-position',
        data: {
          "positionId": positionId,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(InvestPositionResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, InvestPositionResponseModel>> getPositionRequest({
    required String positionId,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/InvestTrading/InvestReader/get-position?positionId=$positionId',
        data: {
          "positionId": positionId,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(InvestPositionResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, InvestPositionResponseModel>> setPositionTPSLRequest({
    required TPSLPositionModel data,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/InvestTrading/InvestAction/set-position-tpsl',
        data: data.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(InvestPositionResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, List<NewInvestJournalModel>>> getPositionHistoryRequest({
    required String id,
    required String skip,
    required String take,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/InvestTrading/InvestAudit/get-position-history?positionId=$id&skip=$skip&take=$take',
        data: {
          "positionId": id,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullResponse<Map>(responseData);

        final out = <NewInvestJournalModel>[];
        for (final element in responseData['data']) {
          out.add(
            NewInvestJournalModel.fromJson(element as Map<String, dynamic>),
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

  Future<DC<ServerRejectException, List<NewInvestJournalModel>>> getPositionHistoryRolloverRequest({
    required String id,
    required String skip,
    required String take,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/InvestTrading/InvestAudit/get-position-rollover?positionId=$id&skip=$skip&take=$take',
        data: {
          "positionId": id,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullResponse<Map>(responseData);

        final out = <NewInvestJournalModel>[];
        for (final element in responseData['data']) {
          out.add(
            NewInvestJournalModel.fromJson(element as Map<String, dynamic>),
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

  Future<DC<ServerRejectException, List<InvestPositionModel>>> getInvestHistoryRequest({
    required String skip,
    required String take,
    String? symbol,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/InvestTrading/InvestReader/get-closed-positions?skip=$skip&take=$take${symbol != null ? '&symbol=$symbol' : ''}',
        data: {
          "positionId": skip,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullResponse<Map>(responseData);

        final out = <InvestPositionModel>[];
        for (final element in responseData['data']['positions']) {
          out.add(
            InvestPositionModel.fromJson(element as Map<String, dynamic>),
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

  Future<DC<ServerRejectException, List<InvestPositionModel>>> getInvestHistoryCanceledRequest({
    required String skip,
    required String take,
    String? symbol,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/InvestTrading/InvestReader/get-cancelled-positions?skip=$skip&take=$take${symbol != null ? '&symbol=$symbol' : ''}',
        data: {
          "positionId": skip,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullResponse<Map>(responseData);

        final out = <InvestPositionModel>[];
        for (final element in responseData['data']) {
          out.add(
            InvestPositionModel.fromJson(element as Map<String, dynamic>),
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

  Future<DC<ServerRejectException, List<InvestSummaryModel>>> getInvestHistorySummaryRequest({
    required String dateFrom,
    required String dateTo,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/InvestTrading/InvestReader/get-closed-positions-summary?dateFrom=$dateFrom&dateTo=$dateTo',
        data: {
          "positionId": dateFrom,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullResponse<Map>(responseData);

        final out = <InvestSummaryModel>[];
        for (final element in responseData['data']) {
          out.add(
            InvestSummaryModel.fromJson(element as Map<String, dynamic>),
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

  Future<DC<ServerRejectException, List<EarnPositionClientModel>>> getEarnPositionsClosed({
    required String skip,
    required String take,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/earn/get-closed-positions',
        data: {
          "skip": skip,
          "take": take,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullResponse<Map>(responseData);

        final out = <EarnPositionClientModel>[];
        for (final element in responseData['data']) {
          out.add(
            EarnPositionClientModel.fromJson(element as Map<String, dynamic>),
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

  Future<DC<ServerRejectException, List<EarnPositionAuditClientModel>>> getEarnAuditPositons({
    required String positionId,
    required String skip,
    required String take,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/earn/get-position-audits',
        data: {
          "positionId": positionId,
          "skip": skip,
          "take": take,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullResponse<Map>(responseData);
        final out = <EarnPositionAuditClientModel>[];
        for (final element in responseData['data']) {
          out.add(
            EarnPositionAuditClientModel.fromJson(element as Map<String, dynamic>),
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

  Future<DC<ServerRejectException, EarnPositionClientModel>> postEarnWithdrawPositionRequest(
    EarnWithdrawPositionRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/earn/withdraw-position',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(EarnPositionClientModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, EarnPositionClientModel>> postEarnClosePositionRequest(
    EarnColosePositionRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/earn/close-position',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(EarnPositionClientModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, EarnPositionClientModel>> postEarnDepositPositionRequest(
    EarnDepositPositionRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/earn/deposit-position',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(EarnPositionClientModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  //Invest transfer
  Future<DC<ServerRejectException, InvestTransferResponseModel>> postInvestDepositeRequest(
    InvestTransferRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/InvestTrading/InvestWallet/transfer-to-investwallet',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(InvestTransferResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, InvestTransferResponseModel>> postInvestWithdrawRequest(
    InvestTransferRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/InvestTrading/InvestWallet/transfer-to-spotwallet',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(InvestTransferResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  // Prepaid card
  Future<DC<ServerRejectException, BuyPrepaidCardIntentionDtoListResponseModel>> postGetPurchaseListRequest(
    GetPurchaseCardListRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/mobile-gift-card/get-purchase-list',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<List>(responseData);

        return DC.data(BuyPrepaidCardIntentionDtoListResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, CardCountriesResponseModel>> postCardGetCountriesRequest() async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/mobile-gift-card/get-countries',
        data: {},
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(CardCountriesResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, PurchaseCardBrandDtoListResponseModel>> postGetBrandsRequest(
    GetPurchaseCardBrandsRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/mobile-gift-card/get-brands',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<List>(responseData);

        return DC.data(PurchaseCardBrandDtoListResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, BuyPurchaseCardResponseModel>> postBuyPrepaidCardPreviewRequest(
    BuyPurchaseCardRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/mobile-gift-card/preview',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(BuyPurchaseCardResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, PrapaidCardVoucherModel>> postBuyPrepaidCardExecuteRequest(
    BuyPurchaseCardRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/mobile-gift-card/execute-purchase',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(PrapaidCardVoucherModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, BuyPrepaidCardIntentionDtoListResponseModel>> postGetVouncherRequest(
    GetVouncherRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/mobile-gift-card/get-purchase',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<List>(responseData);

        return DC.data(BuyPrepaidCardIntentionDtoListResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  // Banners
  Future<DC<ServerRejectException, bool>> postCloseBannerRequest(
    CloseBannerRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banner/close-banner',
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

  // Simple Coin
  Future<DC<ServerRejectException, void>> postClaimSimplCoinsRequest({
    required List<String> ids,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/smpl/claim',
        data: {
          'ids': ids,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final _ = handleFullResponse<Map>(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postCancelSimplCoinsRequest({
    required List<String> ids,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/smpl/cancel',
        data: {
          'ids': ids,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final _ = handleFullResponse<Map>(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, SimpleCoinHistoryModel>> postSimpleCoinHistoryRequest({
    required String skip,
    required String take,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/smpl/history',
        data: {
          "skip": skip,
          "take": take,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(SimpleCoinHistoryModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  // P2P buy
  Future<DC<ServerRejectException, P2PMethodsResponceModel>> getP2PMethodsRequest() async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/trading/buy/p2p-methods',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(P2PMethodsResponceModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  // GET Jar all list
  Future<DC<ServerRejectException, List<JarResponseModel>>> postJarAllListRequest() async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/jar/list/all',
        data: {},
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final out = <JarResponseModel>[];
        for (final element in responseData['data']) {
          out.add(
            JarResponseModel.fromJson(element as Map<String, dynamic>),
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

  // GET Jar active list
  Future<DC<ServerRejectException, List<JarResponseModel>>> postJarActiveListRequest() async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/jar/list/active',
        data: {},
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final out = <JarResponseModel>[];
        for (final element in responseData['data']) {
          out.add(
            JarResponseModel.fromJson(element as Map<String, dynamic>),
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

  // Post Create jar
  Future<DC<ServerRejectException, JarResponseModel>> postCreateJarRequest({
    required String assetSymbol,
    required String blockchain,
    required int target,
    required String imageUrl,
    required String title,
    required String? description,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/jar/create',
        data: {
          "assetSymbol": assetSymbol,
          "blockchain": blockchain,
          "target": target,
          "imageUrl": imageUrl,
          "title": title,
          "description": description,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(JarResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  // Get jar goal limit
  Future<DC<ServerRejectException, int>> getJarGoalLimit() async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.walletApi}/jar/limit',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        return DC.data(responseData['data']['sizeLimit']);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

// Post Update jar
  Future<DC<ServerRejectException, JarResponseModel>> postUpdateJarRequest({
    required String jarId,
    int? target,
    String? imageUrl,
    String? title,
    String? description,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/jar/update',
        data: {
          "target": target,
          "imageUrl": imageUrl,
          "title": title,
          "description": description,
          "jarId": jarId,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(JarResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

// Post Close jar
  Future<DC<ServerRejectException, JarResponseModel>> postCloseJarRequest({
    required String jarId,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/jar/close',
        data: {
          "jarId": jarId,
        },
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(JarResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

// Post Share jar
  Future<DC<ServerRejectException, String>> postShareJarRequest({
    required String jarId,
    required String lang,
  }) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/jar/share',
        data: {"jarId": jarId, "lang": lang},
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(data['url']);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, FeePreviewRepsonseModel>> postFeeInfoRequest(
    FeePreviewRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/blockchain/fee-info',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(FeePreviewRepsonseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }
}
