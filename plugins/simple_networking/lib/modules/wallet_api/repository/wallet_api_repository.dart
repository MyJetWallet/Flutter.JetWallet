import 'package:data_channel/data_channel.dart';
import 'package:dio/dio.dart';
import 'package:simple_networking/api_client/api_client.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/auth_api/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/create_banking_account_simple_response.dart';
import 'package:simple_networking/modules/signal_r/models/earn_audit_history_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/rewards_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/simple_coin_history_model.dart';
import 'package:simple_networking/modules/wallet_api/data_sources/wallet_api_data_sources.dart';
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
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/google_pay/google_pay_confirm_model.dart';
import 'package:simple_networking/modules/wallet_api/models/iban_withdrawal/iban_preview_withdrawal_model.dart';
import 'package:simple_networking/modules/wallet_api/models/iban_withdrawal/iban_withdrawal_model.dart';
import 'package:simple_networking/modules/wallet_api/models/invest/new_invest_request_model.dart';
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
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/get_purchase_card_brands_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/get_purchase_card_list_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/get_vouncher_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/purchase_card_brand_list_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/profile/profile_delete_reasons_model.dart';
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
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_limits_request.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_limits_responce.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_terminate_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simplex/simplex_payment_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simplex/simplex_payment_response_model.dart';
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
import 'package:simple_networking/modules/wallet_api/models/withdraw/withdraw_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdraw/withdraw_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdrawal_info/withdrawal_info_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdrawal_info/withdrawal_info_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdrawal_resend/withdrawal_resend_request.dart';

import '../../../simple_networking.dart';
import '../models/iban_info/iban_info_response_model.dart';
import '../models/prepaid_card/card_countries_response_model.dart';
import '../models/profile/profile_set_address_request.dart';
import '../models/simple_card/simple_card_create_request.dart';
import '../models/simple_card/simple_card_create_response.dart';
import '../models/simple_card/simple_card_remind_pin_response.dart';
import '../models/simple_card/simple_card_sensitive_request.dart';
import '../models/simple_card/simple_card_set_password_request.dart';
import '../models/simple_card/simple_card_sevsitive_response.dart';

class WalletApiRepository {
  WalletApiRepository(this._apiClient) {
    _walletApiDataSources = WalletApiDataSources(_apiClient);
  }

  final ApiClient _apiClient;
  late final WalletApiDataSources _walletApiDataSources;

  Future<DC<ServerRejectException, DepositAddressResponseModel>> postDepositAddress(
    DepositAddressRequestModel model,
  ) async {
    return _walletApiDataSources.postDepositAddressRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, DepositAddressResponseModel>> postDepositNFTAddress() async {
    return _walletApiDataSources.postDepositNFTAddressRequest();
  }

  Future<DC<ServerRejectException, ValidateAddressResponseModel>> postValidateAddress(
    ValidateAddressRequestModel model,
  ) async {
    return _walletApiDataSources.postValidateAddressRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, WithdrawResponseModel>> postWithdraw(
    WithdrawRequestModel model,
  ) async {
    return _walletApiDataSources.postWithdrawRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, WithdrawResponseModel>> postWithdrawJar(
    WithdrawJarRequestModel model,
  ) async {
    return _walletApiDataSources.postWithdrawJarRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, WithdrawJarLimitResponseModel>> postWithdrawJarLimitRequest(
    Map<String, dynamic> body,
  ) async {
    return _walletApiDataSources.postWithdrawJarLimitRequest(
      body,
    );
  }

  Future<DC<ServerRejectException, WithdrawalInfoResponseModel>> postWithdrawalInfo(
    WithdrawalInfoRequestModel model,
  ) async {
    return _walletApiDataSources.postWithdrawalInfoRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, bool>> postWithdrawalResend(
    WithdrawalResendRequestModel model,
  ) async {
    return _walletApiDataSources.postWithdrawalResendRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, WalletHistoryResponseModel>> getWalletHistory(
    WalletHistoryRequestModel model,
  ) async {
    return _walletApiDataSources.getWalletHistoryRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> setActiveAssets(
    SetActiveAssetsRequestModel model,
  ) async {
    return _walletApiDataSources.setActiveAssetslRequest(model);
  }

  /// Circle API
  Future<DC<ServerRejectException, CircleCard>> postAddCard(
    AddCardRequestModel model,
  ) async {
    return _walletApiDataSources.postAddCardRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, AllCardsResponseModel>> getAllCards() async {
    return _walletApiDataSources.getAllCardsRequest();
  }

  Future<DC<ServerRejectException, CircleCard>> postCard(
    CardRequestModel model,
  ) async {
    return _walletApiDataSources.postCardRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, CreatePaymentResponseModel>> postCreatePayment(
    CreatePaymentRequestModel model,
  ) async {
    return _walletApiDataSources.postCreatePaymentRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, DeleteCardResponseModel>> postDeleteCard(
    DeleteCardRequestModel model,
  ) async {
    return _walletApiDataSources.postDeleteCardRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, EncryptionKeyResponseModel>> getEncryptionKey() async {
    return _walletApiDataSources.getEncryptionKeyRequest();
  }

  Future<DC<ServerRejectException, PaymentInfoResponseModel>> getPaymentInfo(
    PaymentInfoRequestModel model,
  ) async {
    return _walletApiDataSources.getPaymentInfoRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, PaymentPreviewResponseModel>> postPaymentPreview(
    PaymentPreviewRequestModel model,
  ) async {
    return _walletApiDataSources.postPaymentPreviewRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, WireCountriesResponseModel>> getWireCountries() async {
    return _walletApiDataSources.getWireCountriesRequest();
  }

  Future<DC<ServerRejectException, SessionInfoResponseModel>> getSessionInfo() async {
    return _walletApiDataSources.getSessionInfoRequest();
  }

  Future<DC<ServerRejectException, ProfileInfoResponseModel>> getProfileInfo() async {
    return _walletApiDataSources.getProfileInfoRequest();
  }

  Future<DC<ServerRejectException, void>> postCardSoon() async {
    return _walletApiDataSources.postCardSoonRequest();
  }

  Future<DC<ServerRejectException, CardBuyCreateResponseModel>> postCardBuyCreate(
    CardBuyCreateRequestModel model,
  ) async {
    return _walletApiDataSources.postCardBuyCreateRequest(model);
  }

  Future<DC<ServerRejectException, GetCryptoSellResponseModel>> postSellCreate(
    GetCryptoSellRequestModel model,
  ) async {
    return _walletApiDataSources.postSellCreateRequest(model);
  }

  Future<DC<ServerRejectException, GetCryptoSellResponseModel>> postSellExecute(
    ExecuteCryptoSellRequestModel model,
  ) async {
    return _walletApiDataSources.postSellExecuteRequest(model);
  }

  Future<DC<ServerRejectException, bool>> postApplePayConfirm(
    String depositId,
    String applePayToken,
  ) async {
    return _walletApiDataSources.postApplePayConfirmRequest(
      depositId,
      applePayToken,
    );
  }

  Future<DC<ServerRejectException, ApplePayResponseModel>> getApplePayInfo(
    String depositId,
  ) async {
    return _walletApiDataSources.getApplePayInfoRequest(
      depositId,
    );
  }

  Future<DC<ServerRejectException, GooglePayConfirmModel>> postGooglePayConfirm(
    String depositId,
    String googlePayToken,
  ) async {
    return _walletApiDataSources.postGooglePayConfirmRequest(
      depositId,
      googlePayToken,
    );
  }

  Future<DC<ServerRejectException, ApplePayResponseModel>> getGooglePayInfo(
    String depositId,
  ) async {
    return _walletApiDataSources.getGooglePayInfoRequest(
      depositId,
    );
  }

  Future<DC<ServerRejectException, bool>> postCardBuyExecute(
    CardBuyExecuteRequestModel model, {
    CancelToken? cancelToken,
  }) async {
    return _walletApiDataSources.postCardBuyExecuteRequest(
      model,
      cancelToken: cancelToken,
    );
  }

  Future<DC<ServerRejectException, CardBuyInfoResponseModel>> postCardBuyInfo(
    CardBuyInfoRequestModel model, {
    CancelToken? cancelToken,
  }) async {
    return _walletApiDataSources.postCardBuyInfoRequest(
      model,
      cancelToken: cancelToken,
    );
  }

  Future<DC<ServerRejectException, DisclaimersResponseModel>> getDisclaimers() async {
    return _walletApiDataSources.getDisclaimersRequest();
  }

  Future<DC<ServerRejectException, DisclaimersResponseModel>> getNftDisclaimers() async {
    return _walletApiDataSources.getNftDisclaimersRequest();
  }

  Future<DC<ServerRejectException, DisclaimersResponseModel>> getHighYieldDisclaimers() async {
    return _walletApiDataSources.getHighYieldDisclaimersRequest();
  }

  Future<DC<ServerRejectException, bool>> postSaveDisclaimer(
    DisclaimersRequestModel model,
  ) async {
    return _walletApiDataSources.postSaveDisclaimerRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, CalculateEarnOfferApyResponseModel>> postCalculateEarnOfferApy(
    CalculateEarnOfferApyRequestModel model,
  ) async {
    return _walletApiDataSources.postCalculateEarnOfferApyRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postEarnOfferDeposit(
    EarnOfferDepositRequestModel model,
  ) async {
    return _walletApiDataSources.postEarnOfferDepositRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postEarnOfferWithdrawal(
    EarnOfferWithdrawalRequestModel model,
  ) async {
    return _walletApiDataSources.postEarnOfferWithdrawalRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postEarnOfferCreatePosition(
    EarnOfferRequestModel model,
  ) async {
    return _walletApiDataSources.postEarnOfferCreatePosition(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postRemoveKeyValue(
    List<String> keys,
  ) async {
    return _walletApiDataSources.postRemoveKeyValueRequest(
      keys,
    );
  }

  Future<DC<ServerRejectException, void>> postSetKeyValue(
    KeyValueRequestModel model,
  ) async {
    return _walletApiDataSources.postSetKeyValueRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, CheckResponseModel>> postKycCheck() async {
    return _walletApiDataSources.postKycCheckRequest();
  }

  Future<DC<ServerRejectException, void>> postKycStart() async {
    return _walletApiDataSources.postKycStartRequest();
  }

  Future<DC<ServerRejectException, String>> postFaceSDKToken(String countryCode) async {
    return _walletApiDataSources.postFaceSDKTokenRequest(countryCode);
  }

  Future<DC<ServerRejectException, int>> postFaceCheckStatus() async {
    return _walletApiDataSources.postFaceCheckStatusRequest();
  }

  Future<DC<ServerRejectException, void>> postUploadDocuments(
    FormData formData,
    int documentType,
    String country,
  ) async {
    return _walletApiDataSources.postUploadDocumentsRequest(
      formData,
      documentType,
      country,
    );
  }

  Future<DC<ServerRejectException, KycPlanResponceModel>> postKycPlan() async {
    return _walletApiDataSources.postKycPlanRequest();
  }

  Future<DC<ServerRejectException, ApplyCountryResponseModel>> postKYCAplyCountry(
    ApplyCountryRequestModel model,
  ) async {
    return _walletApiDataSources.postKYCAplyCountryRequest(model);
  }

  Future<DC<ServerRejectException, MarketInfoResponseModel>> postMarketInfo(
    MarketInfoRequestModel model,
  ) async {
    return _walletApiDataSources.postMarketInfoRequest(model);
  }

  Future<DC<ServerRejectException, IbanInfoResponseModel>> getIbanInfo() async {
    return _walletApiDataSources.getIbanInfoRequest();
  }

  Future<DC<ServerRejectException, MarketNewsResponseModel>> postMarketNews(
    MarketNewsRequestModel model,
  ) async {
    return _walletApiDataSources.postMarketNewsRequest(model);
  }

  Future<DC<ServerRejectException, NewsResponseModel>> postNews(
    NewsRequestModel model,
  ) async {
    return _walletApiDataSources.postNewsRequest(model);
  }

  Future<DC<ServerRejectException, void>> postRegisterToken(
    RegisterTokenRequestModel model,
  ) async {
    return _walletApiDataSources.postRegisterTokenRequest(model);
  }

  Future<DC<ServerRejectException, OperationHistoryResponseModel>> getOperationHistory(
    OperationHistoryRequestModel model,
  ) async {
    return _walletApiDataSources.getOperationHistoryRequest(model);
  }

  Future<DC<ServerRejectException, OperationHistoryItem>> getOperationHistoryOperationID(
    String operationId,
  ) async {
    return _walletApiDataSources.getOperationHistoryOperationIDRequest(operationId);
  }

  Future<DC<ServerRejectException, List<ProfileDeleteReasonsModel>>> postProfileDeleteReasons(
    String localeName,
  ) async {
    return _walletApiDataSources.postProfileDeleteReasonsRequest(localeName);
  }

  Future<DC<ServerRejectException, void>> postProfileDelete(
    String tokenId,
    List<String> deletionReasonIds,
  ) async {
    return _walletApiDataSources.postProfileDeleteRequest(
      tokenId,
      deletionReasonIds,
    );
  }

  Future<DC<ServerRejectException, void>> postSetAddress(
    ProfileSetAddressRequestModel model,
  ) async {
    return _walletApiDataSources.postSetAddressRequest(model);
  }

  Future<DC<ServerRejectException, void>> postProfileReport(
    String messageId,
  ) async {
    return _walletApiDataSources.postProfileReportRequest(
      messageId,
    );
  }

  Future<DC<ServerRejectException, void>> deleteRemoveRecurringBuy(
    RecurringDeleteRequestModel model,
  ) async {
    return _walletApiDataSources.deleteRemoveRecurringBuyRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postSwitchRecurringStatus(
    RecurringManageRequestModel model,
  ) async {
    return _walletApiDataSources.postSwitchRecurringStatusRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, SimplexPaymentResponseModel>> postSimplexPayment(
    SimplexPaymentRequestModel model,
  ) async {
    return _walletApiDataSources.postSimplexPaymentRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, ExecuteQuoteResponseModel>> postExecuteQuote(
    ExecuteQuoteRequestModel model,
  ) async {
    return _walletApiDataSources.postExecuteQuoteRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, GetQuoteResponseModel>> postGetQuote(
    GetQuoteRequestModel model,
  ) async {
    return _walletApiDataSources.postGetQuoteRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, TransferByPhoneResponseModel>> postTransferByPhone(
    TransferByPhoneRequestModel model,
  ) async {
    return _walletApiDataSources.postTransferByPhoneRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, TransferCancelResponseModel>> postTransferCancel(
    TransferCancelRequestModel model,
  ) async {
    return _walletApiDataSources.postTransferCancelRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, TransferInfoResponseModel>> postTransferInfo(
    TransferInfoRequestModel model,
  ) async {
    return _walletApiDataSources.postTransferInfoRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postTransferResend(
    TransferResendRequestModel model,
  ) async {
    return _walletApiDataSources.postTransferResendRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, ConversionPriceModel>> getConversionPrice(
    String baseAssetSymbol,
    String quotedAssetSymbol,
  ) async {
    return _walletApiDataSources.getConversionPriceRequest(
      baseAssetSymbol,
      quotedAssetSymbol,
    );
  }

  Future<DC<ServerRejectException, AddUnlimintCardResponseModel>> postAddUnlimintCard(
    AddUnlimintCardRequestModel model,
  ) async {
    return _walletApiDataSources.postAddUnlimintCardRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, DeleteUnlimintCardResponseModel>> postDeleteUnlimintCard(
    DeleteUnlimintCardRequestModel model,
  ) async {
    return _walletApiDataSources.postDeleteUnlimintCardRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, CardRemoveResponseModel>> cardRemove(
    CardRemoveRequestModel model,
  ) async {
    return _walletApiDataSources.cardRemove(
      model,
    );
  }

  Future<DC<ServerRejectException, CardAddResponseModel>> cardAdd(
    CardAddRequestModel model,
  ) async {
    return _walletApiDataSources.cardAdd(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> updateCardLabel(
    String cardId,
    String label,
  ) async {
    return _walletApiDataSources.updateCardLabel(
      cardId,
      label,
    );
  }

  Future<DC<ServerRejectException, CardCheckResponseModel>> cardCheck(
    CardCheckRequestModel model,
  ) async {
    return _walletApiDataSources.cardCheck(
      model,
    );
  }

  Future<DC<ServerRejectException, CardCheckResponseModel>> cardStart(
    CardCheckRequestModel model,
  ) async {
    return _walletApiDataSources.cardStart(
      model,
    );
  }

  Future<DC<ServerRejectException, CardVerificationResponseModel>> cardVerification(
    CardVerificationRequestModel model,
  ) async {
    return _walletApiDataSources.cardVerification(
      model,
    );
  }

  Future<DC<ServerRejectException, String>> postSDKToken(String country) async {
    return _walletApiDataSources.postSDKTokenRequest(country);
  }

  Future<DC<ServerRejectException, EncryptionKeyCardResponseModel>> encryptionKey() async {
    return _walletApiDataSources.encryptionKey();
  }

  /// NFT

  Future<DC<ServerRejectException, NftMarketInfoResponseModel>> getNFTMarketInfo(String symbol) async {
    return _walletApiDataSources.getNFTMarketInfoRequest(symbol);
  }

  Future<DC<ServerRejectException, NftMarketIsValidPromoResponseModel>> getNFTMarketIsValidPromo(
      String promocode) async {
    return _walletApiDataSources.getNFTMarketIsValidPromoRequest(promocode);
  }

  Future<DC<ServerRejectException, NftMarketPreviewBuyResponseModel>> getNFTMarketPreviewBuy({
    required String symbol,
    String? promocode,
  }) async {
    return _walletApiDataSources.getNFTMarketPreviewBuyRequest(
      symbol,
      promocode,
    );
  }

  Future<DC<ServerRejectException, NftMarketPreviewSellResponseModel>> getNFTMarketPreviewSell(
      String symbol, String assetSymbol) async {
    return _walletApiDataSources.getNFTMarketPreviewSellRequest(
      symbol,
      assetSymbol,
    );
  }

  Future<DC<ServerRejectException, bool>> postNFTMarketMakeSellOrder(
    NftMarketMakeSellOrderRequestModel model,
  ) async {
    return _walletApiDataSources.postNFTMarketMakeSellOrderRequest(model);
  }

  Future<DC<ServerRejectException, bool>> postNFTMarketCancelSellOrder(
    NftMarketCancelSellOrderRequestModel model,
  ) async {
    return _walletApiDataSources.postNFTMarketCancelSellOrderRequest(model);
  }

  Future<DC<ServerRejectException, bool>> postNFTMarketBuyOrder(
    NftMarketBuyOrderRequestModel model,
  ) async {
    return _walletApiDataSources.postNFTMarketBuyOrderRequest(model);
  }

  /// Base asset

  Future<DC<ServerRejectException, GetBaseAssetsResponseModel>> getBaseAssetsList() async {
    return _walletApiDataSources.getBaseAssetsListRequest();
  }

  Future<DC<ServerRejectException, void>> setBaseAsset(
    SetBaseAssetsRequestModel model,
  ) async {
    return _walletApiDataSources.setBaseAssetRequest(model);
  }

  // Debug Errors

  Future<DC<ServerRejectException, void>> debugError() async {
    return _walletApiDataSources.debugErrorRequest();
  }

  Future<DC<ServerRejectException, void>> debugReject() async {
    return _walletApiDataSources.debugRejectRequest();
  }

  // Send Globally

  Future<DC<ServerRejectException, void>> sendToBankCard(
    SendToBankRequestModel model,
  ) async {
    return _walletApiDataSources.sendToBankCardRequest(model);
  }

  Future<DC<ServerRejectException, SendToBankCardResponse>> sendToBankCardPreview(SendToBankRequestModel model) async {
    return _walletApiDataSources.sendToBankCardPreviewRequest(model);
  }

  // Send gift
  Future<DC<ServerRejectException, void>> sendGiftByEmail(
    SendGiftByEmailRequestModel model,
  ) async {
    return _walletApiDataSources.sendGiftByEmailRequest(model);
  }

  Future<DC<ServerRejectException, void>> sendGiftByPhone(
    SendGiftByPhoneRequestModel model,
  ) async {
    return _walletApiDataSources.sendGiftByPhoneRequest(model);
  }

  Future<DC<ServerRejectException, void>> cancelGift(
    String operationId,
  ) async {
    return _walletApiDataSources.cancelGiftRequest(operationId);
  }

  Future<DC<ServerRejectException, GiftModel>> getGift(
    String id,
  ) async {
    return _walletApiDataSources.getGiftRequest(id);
  }

  Future<DC<ServerRejectException, void>> acceptGift(
    String id,
  ) async {
    return _walletApiDataSources.acceptGiftRequest(id);
  }

  Future<DC<ServerRejectException, void>> declineGift(
    String id,
  ) async {
    return _walletApiDataSources.declineGiftRequest(id);
  }

  // Address book

  Future<DC<ServerRejectException, AddressBookModel>> getAddressBook(
    int accountType,
  ) async {
    return _walletApiDataSources.getAddressBookRequest(accountType);
  }

  Future<DC<ServerRejectException, AddressBookContactModel>> postAddressBookAdd(
    String name,
    String nickname,
    String iban,
    String bic,
  ) async {
    return _walletApiDataSources.postAddressBookAddRequest(
      name,
      nickname,
      iban,
      bic,
    );
  }

  Future<DC<ServerRejectException, AddressBookContactModel>> postAddressBookAddSimple(
    String name,
    String iban,
  ) async {
    return _walletApiDataSources.postAddressBookAddSimpleRequest(name, iban);
  }

  Future<DC<ServerRejectException, AddressBookContactModel>> postAddressBookAddPersonal(
    String name,
    String iban,
    String bic,
    String country,
    String fullName,
  ) async {
    return _walletApiDataSources.postAddressBookAddPersonalRequest(name, iban, bic, country, fullName);
  }

  Future<DC<ServerRejectException, void>> postAddressBookDelete(
    String id,
  ) async {
    return _walletApiDataSources.postAddressBookDeleteRequest(
      id,
    );
  }

  Future<DC<ServerRejectException, void>> postAddressBookEdit(
    AddressBookContactModel model,
  ) async {
    return _walletApiDataSources.postAddressBookEditRequest(
      model,
    );
  }

  // Iban out

  Future<DC<ServerRejectException, void>> postIbanWithdrawal(
    IbanWithdrawalModel model,
  ) async {
    return _walletApiDataSources.postIbanWithdrawalRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, IbanPreviewWithdrawalModel>> postPreviewIbanWithdrawal(
    IbanWithdrawalModel model,
  ) async {
    return _walletApiDataSources.postPreviewIbanWithdrawalRequest(
      model,
    );
  }

  // Rewards

  Future<DC<ServerRejectException, RewardSpinResponse>> postRewardSpin() async {
    return _walletApiDataSources.postRewardSpinRequest();
  }

  Future<DC<ServerRejectException, void>> postRewardClaim({
    required RewardsBalance data,
  }) async {
    return _walletApiDataSources.postRewardClaimRequest(data);
  }

  // Banking

  Future<DC<ServerRejectException, CreateBankingAccountSimpleResponse>> postAccountCreate(String requestId) async {
    return _walletApiDataSources.postAccountCreateRequest(requestId);
  }

  Future<DC<ServerRejectException, CreateBankingAccountSimpleResponse>> postSimpleAccountCreate() async {
    return _walletApiDataSources.postSimpleAccountCreateRequest();
  }

  Future<DC<ServerRejectException, void>> postAccountChangeLabel({
    required String accountId,
    required String label,
  }) async {
    return _walletApiDataSources.postAccountChangeLabelRequest(
      accountId: accountId,
      label: label,
    );
  }

  Future<DC<ServerRejectException, String>> postBankingKycStart() async {
    return _walletApiDataSources.postBankingKycStartRequest();
  }

  Future<DC<ServerRejectException, BankingWithdrawalPreviewResponse>> postBankingWithdrawalPreview(
    BankingWithdrawalPreviewModel request,
  ) async {
    return _walletApiDataSources.postBankingWithdrawalPreviewRequest(request);
  }

  Future<DC<ServerRejectException, String>> postBankingWithdrawal(
    BankingWithdrawalRequest request,
  ) async {
    return _walletApiDataSources.postBankingWithdrawalRequest(request);
  }

  Future<DC<ServerRejectException, BuyLimitsResponseModel>> postBuyLimits(
    BuyLimitsRequestModel request,
  ) async {
    return _walletApiDataSources.postBuyLimitsRequest(request);
  }

  Future<DC<ServerRejectException, SimpleCardLimitsResponceModel>> postCardLimits(
    SimpleCardLimitsRequestModel request,
  ) async {
    return _walletApiDataSources.postCardLimitsRequest(request);
  }

  // simple card
  Future<DC<ServerRejectException, SimpleCardCreateResponse>> postSimpleCardCreate({
    required SimpleCardCreateRequest data,
  }) async {
    return _walletApiDataSources.postSimpleCardCreateRequest(data);
  }

  Future<DC<ServerRejectException, SimpleCardSensitiveResponse>> postSensitiveData({
    required SimpleCardSensitiveRequest data,
  }) async {
    return _walletApiDataSources.postSensitiveDataRequest(data);
  }

  Future<DC<ServerRejectException, SimpleCardRemindPinResponse>> postRemindPinPhone({
    required String cardId,
  }) async {
    return _walletApiDataSources.postRemindPinPhoneRequest(cardId: cardId);
  }

  Future<DC<ServerRejectException, void>> postRemindPin({
    required String cardId,
  }) async {
    return _walletApiDataSources.postRemindPinRequest(cardId: cardId);
  }

  Future<DC<ServerRejectException, void>> postCardSetPassword({
    required SimpleCardSetPasswordRequest data,
  }) async {
    return _walletApiDataSources.postCardSetPasswordRequest(data);
  }

  Future<DC<ServerRejectException, void>> postCardChangePassword({
    required SimpleCardSetPasswordRequest data,
  }) async {
    return _walletApiDataSources.postCardChangePasswordRequest(data);
  }

  Future<DC<ServerRejectException, void>> postCardFreeze({
    required String cardId,
  }) async {
    return _walletApiDataSources.postCardFreezeRequest(cardId: cardId);
  }

  Future<DC<ServerRejectException, void>> postCardUnfreeze({
    required String cardId,
  }) async {
    return _walletApiDataSources.postCardUnfreezeRequest(cardId: cardId);
  }

  Future<DC<ServerRejectException, void>> postCardTerminate({
    required SimpleCardTerminateRequestModel model,
  }) async {
    return _walletApiDataSources.postCardTerminateRequest(model);
  }

  Future<DC<ServerRejectException, SellLimitsResponseModel>> postSellLimits(
    SellLimitsRequestModel request,
  ) async {
    return _walletApiDataSources.postSellLimitsRequest(request);
  }

  Future<DC<ServerRejectException, SwapLimitsResponseModel>> postSwapLimits(
    SwapLimitsRequestModel request,
  ) async {
    return _walletApiDataSources.postSwapLimitsRequest(request);
  }

  // Transfer
  Future<DC<ServerRejectException, AccountTransferPreviewResponseModel>> postTransferPreview(
    AccountTransferPreviewRequestModel request,
  ) async {
    return _walletApiDataSources.postTransferPreviewRequest(request);
  }

  Future<DC<ServerRejectException, AccountTransferResponseModel>> postTransferRequest(
    AccountTransferRequestModel request,
  ) async {
    return _walletApiDataSources.postTransferRequest(request);
  }

  // invest

  Future<DC<ServerRejectException, AssetModelAdm>> getAsset({required String assetId}) async {
    return _walletApiDataSources.getAsset(assetId: assetId);
  }

  Future<DC<ServerRejectException, InvestPositionResponseModel>> createActivePosition(
      NewInvestRequestModel request) async {
    return _walletApiDataSources.createActivePositionRequest(model: request);
  }

  Future<DC<ServerRejectException, InvestPositionResponseModel>> createPendingLimitPosition(
      NewInvestOrderRequestModel request) async {
    return _walletApiDataSources.createPendingLimitPositionRequest(model: request);
  }

  Future<DC<ServerRejectException, InvestPositionResponseModel>> createPendingStopPosition(
      NewInvestOrderRequestModel request) async {
    return _walletApiDataSources.createPendingStopPositionRequest(model: request);
  }

  Future<DC<ServerRejectException, InvestPositionResponseModel>> changePendingPrice({
    required String id,
    required double price,
  }) async {
    return _walletApiDataSources.changePendingPrice(id: id, price: price);
  }

  Future<DC<ServerRejectException, InvestPositionResponseModel>> closeActivePosition({
    required String positionId,
  }) async {
    return _walletApiDataSources.closeActivePositionRequest(positionId: positionId);
  }

  Future<DC<ServerRejectException, InvestPositionResponseModel>> getPosition({
    required String positionId,
  }) async {
    return _walletApiDataSources.getPositionRequest(positionId: positionId);
  }

  Future<DC<ServerRejectException, InvestPositionResponseModel>> cancelPendingPosition({
    required String positionId,
  }) async {
    return _walletApiDataSources.cancelPendingPositionRequest(positionId: positionId);
  }

  Future<DC<ServerRejectException, InvestPositionResponseModel>> setPositionTPSL({
    required TPSLPositionModel data,
  }) async {
    return _walletApiDataSources.setPositionTPSLRequest(data: data);
  }

  Future<DC<ServerRejectException, List<NewInvestJournalModel>>> getPositionHistory({
    required String id,
    required String skip,
    required String take,
  }) async {
    return _walletApiDataSources.getPositionHistoryRequest(id: id, skip: skip, take: take);
  }

  Future<DC<ServerRejectException, List<NewInvestJournalModel>>> getPositionHistoryRollover({
    required String id,
    required String skip,
    required String take,
  }) async {
    return _walletApiDataSources.getPositionHistoryRolloverRequest(id: id, skip: skip, take: take);
  }

  Future<DC<ServerRejectException, List<InvestPositionModel>>> getInvestHistory({
    required String skip,
    required String take,
    String? symbol,
  }) async {
    return _walletApiDataSources.getInvestHistoryRequest(skip: skip, take: take, symbol: symbol);
  }

  Future<DC<ServerRejectException, List<InvestPositionModel>>> getInvestHistoryCanceled({
    required String skip,
    required String take,
    String? symbol,
  }) async {
    return _walletApiDataSources.getInvestHistoryCanceledRequest(skip: skip, take: take, symbol: symbol);
  }

  Future<DC<ServerRejectException, List<InvestSummaryModel>>> getInvestHistorySummary({
    required String dateFrom,
    required String dateTo,
  }) async {
    return _walletApiDataSources.getInvestHistorySummaryRequest(dateFrom: dateFrom, dateTo: dateTo);
  }

  Future<DC<ServerRejectException, List<EarnPositionClientModel>>> getEarnPositionsClosed({
    required String skip,
    required String take,
  }) async {
    return _walletApiDataSources.getEarnPositionsClosed(
      skip: skip,
      take: take,
    );
  }

  Future<DC<ServerRejectException, List<EarnPositionAuditClientModel>>> getEarnAuditPositons({
    required String positionId,
    required String skip,
    required String take,
  }) async {
    return _walletApiDataSources.getEarnAuditPositons(
      positionId: positionId,
      skip: skip,
      take: take,
    );
  }

  Future<DC<ServerRejectException, EarnPositionClientModel>> postEarnWithdrawPosition(
    EarnWithdrawPositionRequestModel model,
  ) async {
    return _walletApiDataSources.postEarnWithdrawPositionRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, EarnPositionClientModel>> postEarnClosePosition(
    EarnColosePositionRequestModel model,
  ) async {
    return _walletApiDataSources.postEarnClosePositionRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, EarnPositionClientModel>> postEarnDepositPosition(
    EarnDepositPositionRequestModel model,
  ) async {
    return _walletApiDataSources.postEarnDepositPositionRequest(
      model,
    );
  }

  //Invest transfer
  Future<DC<ServerRejectException, InvestTransferResponseModel>> postInvestDeposite(
    InvestTransferRequestModel model,
  ) async {
    return _walletApiDataSources.postInvestDepositeRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, InvestTransferResponseModel>> postInvestWithdraw(
    InvestTransferRequestModel model,
  ) async {
    return _walletApiDataSources.postInvestWithdrawRequest(
      model,
    );
  }

  // Prepaid card
  Future<DC<ServerRejectException, BuyPrepaidCardIntentionDtoListResponseModel>> postGetPurchaseList(
    GetPurchaseCardListRequestModel model,
  ) async {
    return _walletApiDataSources.postGetPurchaseListRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, CardCountriesResponseModel>> postCardGetCountries() async {
    return _walletApiDataSources.postCardGetCountriesRequest();
  }

  Future<DC<ServerRejectException, PurchaseCardBrandDtoListResponseModel>> postGetBrands(
    GetPurchaseCardBrandsRequestModel model,
  ) async {
    return _walletApiDataSources.postGetBrandsRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, BuyPurchaseCardResponseModel>> postBuyPrepaidCardPreview(
    BuyPurchaseCardRequestModel model,
  ) async {
    return _walletApiDataSources.postBuyPrepaidCardPreviewRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, PrapaidCardVoucherModel>> postBuyPrepaidCardExecute(
    BuyPurchaseCardRequestModel model,
  ) async {
    return _walletApiDataSources.postBuyPrepaidCardExecuteRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, BuyPrepaidCardIntentionDtoListResponseModel>> postGetVouncher(
    GetVouncherRequestModel model,
  ) async {
    return _walletApiDataSources.postGetVouncherRequest(
      model,
    );
  }

  // Banners
  Future<DC<ServerRejectException, bool>> postCloseBanner(
    CloseBannerRequestModel model,
  ) async {
    return _walletApiDataSources.postCloseBannerRequest(
      model,
    );
  }

  // Simple coins
  Future<DC<ServerRejectException, void>> postClaimSimplCoins({
    required List<String> ids,
  }) async {
    return _walletApiDataSources.postClaimSimplCoinsRequest(ids: ids);
  }

  Future<DC<ServerRejectException, void>> postCancelSimplCoinsRequest({
    required List<String> ids,
  }) async {
    return _walletApiDataSources.postCancelSimplCoinsRequest(ids: ids);
  }

  Future<DC<ServerRejectException, SimpleCoinHistoryModel>> postSimpleCoinHistory({
    required String skip,
    required String take,
  }) async {
    return _walletApiDataSources.postSimpleCoinHistoryRequest(
      skip: skip,
      take: take,
    );
  }

  Future<DC<ServerRejectException, P2PMethodsResponceModel>> getP2PMethods() async {
    return _walletApiDataSources.getP2PMethodsRequest();
  }

  Future<DC<ServerRejectException, List<JarResponseModel>>> postJarAllList() async {
    return _walletApiDataSources.postJarAllListRequest();
  }

  Future<DC<ServerRejectException, List<JarResponseModel>>> postJarActiveList() async {
    return _walletApiDataSources.postJarActiveListRequest();
  }

  Future<DC<ServerRejectException, JarResponseModel>> postCreateJar({
    required String assetSymbol,
    required String blockchain,
    required int target,
    required String imageUrl,
    required String title,
    required String? description,
  }) async {
    return _walletApiDataSources.postCreateJarRequest(
      assetSymbol: assetSymbol,
      blockchain: blockchain,
      target: target,
      imageUrl: imageUrl,
      title: title,
      description: description,
    );
  }

  Future<DC<ServerRejectException, JarResponseModel>> postUpdateJarRequest({
    required String jarId,
    int? target,
    String? imageUrl,
    String? title,
    String? description,
  }) async {
    return _walletApiDataSources.postUpdateJarRequest(
      jarId: jarId,
      target: target,
      imageUrl: imageUrl,
      title: title,
      description: description,
    );
  }

  Future<DC<ServerRejectException, JarResponseModel>> postCloseJarRequest({
    required String jarId,
  }) async {
    return _walletApiDataSources.postCloseJarRequest(
      jarId: jarId,
    );
  }

  Future<DC<ServerRejectException, String>> postShareJarRequest({
    required String jarId,
    required String lang,
  }) async {
    return _walletApiDataSources.postShareJarRequest(
      jarId: jarId,
      lang: lang,
    );
  }
}
