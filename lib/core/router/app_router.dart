import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/guards/init_guard.dart';
import 'package:jetwallet/core/services/anchors/models/convert_confirmation_model/convert_confirmation_model.dart';
import 'package:jetwallet/core/services/anchors/models/crypto_deposit/crypto_deposit_model.dart';
import 'package:jetwallet/features/account/about_us/about_us.dart';
import 'package:jetwallet/features/account/account_screen.dart';
import 'package:jetwallet/features/account/account_security/ui/account_security_screen.dart';
import 'package:jetwallet/features/account/crisp/crisp.dart';
import 'package:jetwallet/features/account/delete_profile/ui/delete_profile.dart';
import 'package:jetwallet/features/account/delete_profile/ui/delete_reasons_screen.dart';
import 'package:jetwallet/features/account/profile_details/ui/profile_details.dart';
import 'package:jetwallet/features/account/profile_details/ui/widgets/change_password.dart';
import 'package:jetwallet/features/account/profile_details/ui/widgets/default_asset_change.dart';
import 'package:jetwallet/features/account/profile_details/ui/widgets/set_new_password.dart';
import 'package:jetwallet/features/auth/biometric/ui/biometric.dart';
import 'package:jetwallet/features/auth/biometric/ui/components/allow_biometric.dart';
import 'package:jetwallet/features/auth/email_verification/ui/email_verification_screen.dart';
import 'package:jetwallet/features/auth/onboarding/ui/onboarding_screen.dart';
import 'package:jetwallet/features/auth/push_permission/push_permission_screen.dart';
import 'package:jetwallet/features/auth/single_sign_in/ui/sing_in.dart';
import 'package:jetwallet/features/auth/user_data/ui/user_data_screen.dart';
import 'package:jetwallet/features/auth/verification_reg/verification_screen.dart';
import 'package:jetwallet/features/buy_flow/store/payment_method_store.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/buy_flow/ui/buy_confrimation_screen.dart';
import 'package:jetwallet/features/card_coming_soon/card_screen.dart';
import 'package:jetwallet/features/change_email/screen/change_email_screen.dart';
import 'package:jetwallet/features/change_email/screen/change_email_verification_screen.dart';
import 'package:jetwallet/features/cj_banking_accounts/screens/cj_account_label_screen.dart';
import 'package:jetwallet/features/cj_banking_accounts/screens/cj_account_screen.dart';
import 'package:jetwallet/features/convert_flow/screens/convetr_confrimation_screen.dart';
import 'package:jetwallet/features/crypto_deposit/crypto_deposit_screen.dart';
import 'package:jetwallet/features/crypto_jar/ui/all_jars_screen.dart';
import 'package:jetwallet/features/crypto_jar/ui/create_new_jar_screen.dart';
import 'package:jetwallet/features/crypto_jar/ui/enter_jar_description_screen.dart';
import 'package:jetwallet/features/crypto_jar/ui/enter_jar_goal_screen.dart';
import 'package:jetwallet/features/crypto_jar/ui/enter_jar_name_screen.dart';
import 'package:jetwallet/features/crypto_jar/ui/jar_closed_confirmation_screen.dart';
import 'package:jetwallet/features/crypto_jar/ui/jar_screen.dart';
import 'package:jetwallet/features/crypto_jar/ui/jar_share_screen.dart';
import 'package:jetwallet/features/crypto_jar/ui/jar_transaction_history_screen.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/add_bank_card.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/pay_with_bottom_sheet.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/debug_info/debug_history.dart';
import 'package:jetwallet/features/debug_info/debug_info.dart';
import 'package:jetwallet/features/debug_info/invest_ui_kit.dart';
import 'package:jetwallet/features/debug_info/signalr_debug_info.dart';
import 'package:jetwallet/features/earn/screens/earn_deposit_screen.dart';
import 'package:jetwallet/features/earn/screens/earn_details_screen.dart';
import 'package:jetwallet/features/earn/screens/earn_position_active_screen.dart';
import 'package:jetwallet/features/earn/screens/earn_screen.dart';
import 'package:jetwallet/features/earn/screens/earn_top_up_amount_screen.dart';
import 'package:jetwallet/features/earn/screens/earn_top_up_order_summary_screen.dart';
import 'package:jetwallet/features/earn/screens/earn_withdraw_order_summary_screen.dart';
import 'package:jetwallet/features/earn/screens/earn_withdrawal_amount_screen.dart';
import 'package:jetwallet/features/earn/screens/earn_withdrawn_type_screen.dart';
import 'package:jetwallet/features/earn/screens/earns_archive_screen.dart';
import 'package:jetwallet/features/earn/screens/offer_order_summary.dart';
import 'package:jetwallet/features/earn/screens/offers_screen.dart';
import 'package:jetwallet/features/email_confirmation/ui/email_confirmation_screen.dart';
import 'package:jetwallet/features/face_check/ui/face_check_screen.dart';
import 'package:jetwallet/features/home/home_screen.dart';
import 'package:jetwallet/features/iban/get_personal_iban_screen.dart';
import 'package:jetwallet/features/iban/iban_add_bank_account_screen.dart';
import 'package:jetwallet/features/iban/iban_send/iban_send_amount/ui/iban_send_amount.dart';
import 'package:jetwallet/features/iban/iban_send/iban_send_confirm/ui/iban_send_confirm.dart';
import 'package:jetwallet/features/iban_address_book/ui/address_book_simple_screen.dart';
import 'package:jetwallet/features/iban_address_book/ui/address_book_unlimit_screen.dart';
import 'package:jetwallet/features/invest/ui/instrument_screen.dart';
import 'package:jetwallet/features/invest/ui/new_invest_confirmation_screen.dart';
import 'package:jetwallet/features/invest/ui/pending_invest_manage_screen.dart';
import 'package:jetwallet/features/invest_transfer/screens/invest_deposite_confrimation_screen.dart';
import 'package:jetwallet/features/invest_transfer/screens/invest_transfer_screen.dart';
import 'package:jetwallet/features/invest_transfer/screens/invest_withdraw_confrimation_screen.dart';
import 'package:jetwallet/features/kyc/allow_camera/ui/allow_camera_screen.dart';
import 'package:jetwallet/features/kyc/choose_documents/ui/choose_documents.dart';
import 'package:jetwallet/features/kyc/kyc_selfie/ui/kyc_selfie.dart';
import 'package:jetwallet/features/kyc/kyc_selfie/ui/widgets/success_kys_screen.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/ui/kyc_aid_choose_country_screen.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/ui/kyc_aid_webview_screen.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/ui/kyc_verification.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/kyc/upload_documents/ui/upload_kyc_documents.dart';
import 'package:jetwallet/features/kyc/upload_documents/ui/widgets/upload_verification_photo.dart';
import 'package:jetwallet/features/market/market_details/ui/market_details.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/about_block/components/pdf_view_screen.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/features/market/screens/market_screen.dart';
import 'package:jetwallet/features/market/screens/market_sector_details_screen.dart';
import 'package:jetwallet/features/my_wallets/screens/my_wallets_screen.dart';
import 'package:jetwallet/features/p2p_buy/screens/buy_p2p_confrimation_screen.dart';
import 'package:jetwallet/features/p2p_buy/screens/buy_p2p_peyment_method_screen.dart';
import 'package:jetwallet/features/p2p_buy/screens/p2p_buy_amount_screen.dart';
import 'package:jetwallet/features/p2p_buy/screens/payment_currence_buy_screen.dart';
import 'package:jetwallet/features/payment_methods/ui/payment_methods.dart';
import 'package:jetwallet/features/phone_verification/ui/phone_verification.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/features/pin_screen/ui/pin_screen.dart';
import 'package:jetwallet/features/prepaid_card/screens/buy_vouncher_amount_screen.dart';
import 'package:jetwallet/features/prepaid_card/screens/pre_buy_tabs_screen.dart';
import 'package:jetwallet/features/prepaid_card/screens/prepaid_card_details_screen.dart';
import 'package:jetwallet/features/prepaid_card/screens/prepaid_card_service_screen.dart';
import 'package:jetwallet/features/receive_gift/progres_screen.dart';
import 'package:jetwallet/features/rewards_flow/store/rewards_flow_store.dart';
import 'package:jetwallet/features/rewards_flow/ui/reward_open_screen.dart';
import 'package:jetwallet/features/rewards_flow/ui/rewards_flow_screen.dart';
import 'package:jetwallet/features/sell_flow/screens/sell_confrimation_screen.dart';
import 'package:jetwallet/features/send_gift/model/send_gift_info_model.dart';
import 'package:jetwallet/features/set_phone_number/ui/set_phone_number.dart';
import 'package:jetwallet/features/simple_card/ui/simple_card_label_screen.dart';
import 'package:jetwallet/features/simple_card/ui/simple_card_limits_screen.dart';
import 'package:jetwallet/features/simple_card/ui/simple_card_screen.dart';
import 'package:jetwallet/features/simple_coin/screens/my_simple_coins_screen.dart';
import 'package:jetwallet/features/simple_coin/screens/simple_coin_transaction_history_screen.dart';
import 'package:jetwallet/features/transaction_history/screens/transaction_hisotry_screen.dart';
import 'package:jetwallet/features/transfer_flow/screens/transfer_confrimation_screen.dart';
import 'package:jetwallet/features/wallet/screens/asset_transaction_history.dart';
import 'package:jetwallet/features/wallet/screens/create_banking_screen.dart';
import 'package:jetwallet/features/wallet/screens/wallet_screen.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/send_card_detail_screen.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/send_card_payment_method_screen.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/send_globally_amount_screen.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/send_globally_confirm_screen.dart';
import 'package:jetwallet/features/withdrawal/ui/scanner_screen.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_address.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_ammount.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_confirm.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_preview.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_screen.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/result_screens/failure_screen/failure_screen.dart';
import 'package:jetwallet/widgets/result_screens/success_screen/success_screen.dart';
import 'package:jetwallet/widgets/result_screens/verifying_screen/success_verifying_screen.dart';
import 'package:jetwallet/widgets/result_screens/verifying_screen/verifying_screen.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:jetwallet/widgets/web_view/screens/web_view_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:simple_kit/modules/account/phone_number/simple_number.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';
import 'package:simple_networking/modules/signal_r/models/global_send_methods_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/market_sectors_message_model.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';
import 'package:simple_networking/modules/wallet_api/models/banking_withdrawal/banking_withdrawal_preview_model.dart';
import 'package:simple_networking/modules/wallet_api/models/banking_withdrawal/banking_withdrawal_preview_response.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/p2p_methods/p2p_methods_responce_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/buy_prepaid_card_intention_dto_list_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/purchase_card_brand_list_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/sell/get_crypto_sell_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/send_globally/send_to_bank_card_response.dart';
import 'package:simple_networking/modules/wallet_api/models/send_globally/send_to_bank_request_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../features/auth/splash/splash_screen.dart';
import '../../features/currency_buy/ui/screens/choose_asset_screen.dart';
import '../../features/debug_info/install_conversion_data_screen.dart';
import '../../features/debug_info/logs_screen.dart';
import '../../features/iban/widgets/iban_billing_address.dart';
import '../../features/invest/invest_screen.dart';
import '../../features/invest/ui/active_invest_manage_screen.dart';
import '../../features/invest/ui/invest_history_screen.dart';
import '../../features/invest/ui/new_invest_screen.dart';
import '../../features/prepaid_card/screens/buy_vouncher_confirmation_screen.dart';
import '../../features/send_gift/screens/gift_amount.dart';
import '../../features/send_gift/screens/gift_order_summary.dart';
import '../../features/send_gift/screens/gift_receivers_details_screen.dart';
import '../../features/send_gift/screens/gift_select_asset_screen.dart';
import '../../features/simple_card/ui/widgets/get_simple_card_screen.dart';

part 'app_router.gr.dart';

// ignore_for_file: newline-before-return
// ignore_for_file: prefer-trailing-comma

final sRouter = getIt.get<AppRouter>();

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  /*
  @override
  RouteType get defaultRouteType => const RouteType.custom(
        transitionsBuilder: TransitionsBuilders.slideLeft,
        durationInMilliseconds: 250,
      );
  */
  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  final List<AutoRoute> routes = [
    AutoRoute(
      path: '/',
      page: SplashRoute.page,
    ),
    AutoRoute(
      path: '/splash_screen',
      page: OnboardingRoute.page,
    ),
    AutoRoute(
      path: '/singin',
      page: SingInRouter.page,
    ),
    AutoRoute(
      path: '/user_data',
      page: UserDataScreenRouter.page,
    ),
    AutoRoute(
      path: '/email_verification',
      page: EmailVerificationRoute.page,
    ),
    AutoRoute(
      path: '/allow_camera',
      page: AllowCameraRoute.page,
    ),
    AutoRoute(
      path: '/allow_biometric',
      page: AllowBiometricRoute.page,
    ),
    AutoRoute(
      // initial: true,
      guards: [InitGuard()],
      path: '/home',
      page: HomeRouter.page,
      children: [
        AutoRoute(
          path: 'market',
          page: MarketRouter.page,
          //initial: true,
        ),
        AutoRoute(
          path: 'my_wallets',
          page: MyWalletsRouter.page,
        ),
        AutoRoute(
          path: 'card',
          page: CardRouter.page,
        ),
        AutoRoute(
          path: 'rewards',
          page: RewardsFlowRouter.page,
        ),
        AutoRoute(
          path: 'invest',
          page: InvestPageRouter.page,
        ),
        AutoRoute(
          path: 'earn',
          page: EarnRouter.page,
        ),
      ],
    ),
    AutoRoute(
      path: '/earn_positon',
      page: EarnPositionActiveRouter.page,
    ),
    AutoRoute(
      path: '/offers',
      page: OffersRouter.page,
    ),
    AutoRoute(
      path: '/earns_arcive',
      page: EarnsArchiveRouter.page,
    ),
    AutoRoute(
      path: '/earns_details',
      page: EarnsDetailsRouter.page,
    ),
    AutoRoute(
      path: '/earns_deposit',
      page: EarnDepositScreenRouter.page,
    ),
    AutoRoute(
      path: '/offer_order_summary',
      page: OfferOrderSummaryRouter.page,
    ),
    CustomRoute(
      path: '/verification_screen',
      page: VerificationRouter.page,
      transitionsBuilder: TransitionsBuilders.slideBottom,
    ),
    AutoRoute(
      path: '/kyc_verification',
      page: KycVerificationRouter.page,
      fullscreenDialog: true,
    ),
    AutoRoute(
      path: '/account',
      page: AccountRouter.page,
    ),
    AutoRoute(
      path: '/crisp',
      page: CrispRouter.page,
    ),
    AutoRoute(
      path: '/choose_documents',
      page: ChooseDocumentsRouter.page,
    ),
    AutoRoute(
      path: '/upload_kyc_documents',
      page: UploadKycDocumentsRouter.page,
    ),
    AutoRoute(
      path: '/upload_verification_photo',
      page: UploadVerificationPhotoRouter.page,
    ),
    AutoRoute(
      path: '/kyc_selfie',
      page: KycSelfieRouter.page,
    ),
    AutoRoute(
      path: '/choose_asset',
      page: ChooseAssetRouter.page,
    ),
    AutoRoute(
      path: '/crypto_deposit',
      page: CryptoDepositRouter.page,
    ),
    AutoRoute(
      path: '/transaction_history',
      page: TransactionHistoryRouter.page,
    ),
    AutoRoute(
      path: '/add_bank_card',
      page: AddUnlimintCardRouter.page,
    ),
    AutoRoute(
      path: '/iban_address',
      page: IbanAddressRouter.page,
    ),
    AutoRoute(
      path: '/iban_add_account',
      page: IbanAddBankAccountRouter.page,
    ),
    AutoRoute(
      path: '/iban_add_account_simpe',
      page: IbanAdressBookSimpleRoute.page,
    ),
    AutoRoute(
      path: '/iban_add_account_unlimit',
      page: IbanAdressBookUnlimitRoute.page,
    ),
    CustomRoute(
      path: '/iban_edit_account',
      page: IbanEditBankAccountRouter.page,
      transitionsBuilder: TransitionsBuilders.slideBottom,
    ),
    AutoRoute(
      path: '/success_screen',
      page: SuccessScreenRouter.page,
    ),
    AutoRoute(
      path: '/waiting_screen',
      page: WaitingScreenRouter.page,
    ),
    AutoRoute(
      path: '/failure_screen',
      page: FailureScreenRouter.page,
    ),
    AutoRoute(
      path: '/verifying_screen',
      page: VerifyingScreenRouter.page,
    ),
    AutoRoute(
      path: '/verifying_success_screen',
      page: SuccessVerifyingScreenRouter.page,
    ),
    AutoRoute(
      path: '/set_phone_number',
      page: SetPhoneNumberRouter.page,
    ),
    AutoRoute(
      path: '/set_new_password',
      page: SetNewPasswordRouter.page,
    ),
    AutoRoute(
      path: '/phone_verification',
      page: PhoneVerificationRouter.page,
    ),
    AutoRoute(
      path: '/payments_methods',
      page: PaymentMethodsRouter.page,
    ),
    AutoRoute(
      path: '/pin_screen',
      page: PinScreenRoute.page,
    ),
    AutoRoute(
      path: '/email_confirmation',
      page: EmailConfirmationRouter.page,
    ),
    AutoRoute(
      path: '/biometric',
      page: BiometricRouter.page,
    ),
    AutoRoute(
      path: '/change_password',
      page: ChangePasswordRouter.page,
    ),
    AutoRoute(
      path: '/delete_profile',
      page: DeleteProfileRouter.page,
    ),
    AutoRoute(
      path: '/profile_details',
      page: ProfileDetailsRouter.page,
    ),
    AutoRoute(
      path: '/account_sercurity',
      page: AccountSecurityRouter.page,
    ),
    AutoRoute(
      path: '/about_us',
      page: AboutUsRouter.page,
    ),
    AutoRoute(
      path: '/debug_info',
      page: DebugInfoRouter.page,
    ),
    AutoRoute(
      path: '/signalr_info',
      page: SignalrDebugInfoRouter.page,
    ),
    AutoRoute(
      path: '/invest_kit',
      page: InvestUIKITRouter.page,
    ),
    AutoRoute(
      path: '/wallet',
      page: WalletRouter.page,
    ),
    AutoRoute(
      path: '/simple_card',
      page: SimpleCardRouter.page,
    ),
    AutoRoute(
      path: '/success_kyc',
      page: SuccessKycScreenRoute.page,
    ),
    AutoRoute(
      path: '/delete_reasons_screen',
      page: DeleteReasonsScreenRouter.page,
    ),
    AutoRoute(
      path: '/pdf_view_screen',
      page: PDFViewScreenRouter.page,
    ),
    AutoRoute(
      path: '/market_details',
      page: MarketDetailsRouter.page,
    ),
    AutoRoute(
      path: '/change_base_asset',
      page: DefaultAssetChangeRouter.page,
    ),
    AutoRoute(
      path: '/logs_debug',
      page: LogsRouter.page,
    ),
    AutoRoute(
      path: '/install_conversion_data',
      page: InstallConversionDataRouter.page,
    ),
    AutoRoute(
      path: '/withdrawal',
      page: WithdrawRouter.page,
      children: [
        AutoRoute(
          path: '',
          page: WithdrawalAddressRouter.page,
        ),
        AutoRoute(
          path: 'withdrawal_ammount',
          page: WithdrawalAmmountRouter.page,
        ),
        AutoRoute(
          path: 'withdrawal_confirm',
          page: WithdrawalConfirmRouter.page,
        ),
        AutoRoute(
          path: 'wiGthdrawal_preview',
          page: WithdrawalPreviewRouter.page,
        ),
      ],
    ),
    AutoRoute(
      path: '/send_card_deetail',
      page: SendCardDetailRouter.page,
    ),
    AutoRoute(
      path: '/send_globally_amount',
      page: SendGloballyAmountRouter.page,
    ),
    AutoRoute(
      path: '/send_globally_confirm',
      page: SendGloballyConfirmRouter.page,
    ),
    AutoRoute(
      path: '/send_iban_amount',
      page: IbanSendAmountRouter.page,
    ),
    AutoRoute(
      path: '/send_iban_confirm',
      page: IbanSendConfirmRouter.page,
    ),
    AutoRoute(
      path: '/global_send_payment_method',
      page: SendCardPaymentMethodRouter.page,
    ),
    AutoRoute(
      path: '/gift_select_asset',
      page: GiftSelectAssetRouter.page,
    ),
    AutoRoute(
      path: '/gift_receivers_details',
      page: GiftReceiversDetailsRouter.page,
    ),
    AutoRoute(
      path: '/gift_amount',
      page: GiftAmountRouter.page,
    ),
    AutoRoute(
      path: '/gift_order_summury',
      page: GiftOrderSummuryRouter.page,
    ),
    AutoRoute(
      path: '/progress_router',
      page: ProgressRouter.page,
    ),
    AutoRoute(
      path: '/flow_amount',
      page: AmountRoute.page,
    ),
    AutoRoute(
      path: '/buy_flow_confirmation',
      page: BuyConfirmationRoute.page,
    ),
    AutoRoute(
      path: '/reward_open',
      page: RewardOpenRouter.page,
    ),
    AutoRoute(
      path: '/cj_account',
      page: CJAccountRouter.page,
    ),
    AutoRoute(
      path: '/cj_label',
      page: CJAccountLabelRouter.page,
    ),
    AutoRoute(
      path: '/create_banking',
      page: CreateBankingRoute.page,
    ),
    AutoRoute(
      path: '/sell_confirmation',
      page: SellConfirmationRoute.page,
    ),
    AutoRoute(
      path: '/convert_confirmation',
      page: ConvertConfirmationRoute.page,
    ),
    AutoRoute(
      path: '/face_check',
      page: FaceCheckRoute.page,
    ),
    AutoRoute(
      path: '/debug_history',
      page: DebugHistoryRouter.page,
    ),
    AutoRoute(
      path: '/scanner_screen',
      page: ScannerRoute.page,
    ),
    AutoRoute(
      path: '/simple_card_limits',
      page: SimpleCardLimitsRouter.page,
    ),
    AutoRoute(
      path: '/push_permission',
      page: PushPermissionRoute.page,
    ),
    AutoRoute(
      path: '/simple_card_label',
      page: SimpleCardLabelRouter.page,
    ),
    AutoRoute(
      path: '/transfer_confirmation',
      page: TransferConfirmationRoute.page,
    ),
    AutoRoute(
      path: '/new_invest',
      page: NewInvestPageRouter.page,
    ),
    AutoRoute(
      path: '/invest_history',
      page: InvestHistoryPageRouter.page,
    ),
    AutoRoute(
      path: '/new_invest_confirmation',
      page: NewInvestConfirmationPageRouter.page,
    ),
    AutoRoute(
      path: '/invest_instrument',
      page: InstrumentPageRouter.page,
    ),
    AutoRoute(
      path: '/active_invest_manage',
      page: ActiveInvestManageRouter.page,
    ),
    AutoRoute(
      path: '/pending_invest_manage',
      page: PendingInvestManageRouter.page,
    ),
    AutoRoute(
      path: '/earn_withdrawn_type',
      page: EarnWithdrawnTypeRouter.page,
    ),
    AutoRoute(
      path: '/earn_withdrawal_amount',
      page: EarnWithdrawalAmountRouter.page,
    ),
    AutoRoute(
      path: '/earn_withdraw_order_summary',
      page: EarnWithdrawOrderSummaryRouter.page,
    ),
    AutoRoute(
      path: '/earn_top_up_amount',
      page: EarnTopUpAmountRouter.page,
    ),
    AutoRoute(
      path: '/earn_top_up_order_summary',
      page: EarnTopUpOrderSummaryRouter.page,
    ),
    AutoRoute(
      path: '/invest_transfer',
      page: InvestTransferRoute.page,
    ),
    AutoRoute(
      path: '/invest_deposite_confrimation',
      page: InvestDepositeConfrimationRoute.page,
    ),
    AutoRoute(
      path: '/invest_withdraw_confrimation',
      page: InvestWithdrawConfrimationRoute.page,
    ),
    AutoRoute(
      path: '/prepaid_card_service',
      page: PrepaidCardServiceRouter.page,
    ),
    AutoRoute(
      path: '/prepaid_card_pre_buy_tabs',
      page: PrepaidCardPreBuyTabsRouter.page,
      fullscreenDialog: true,
    ),
    AutoRoute(
      path: '/buy_vouncher_amount',
      page: BuyVouncherAmountRouter.page,
    ),
    AutoRoute(
      path: '/prepaid_card_details',
      page: PrepaidCardDetailsRouter.page,
      fullscreenDialog: true,
    ),
    AutoRoute(
      path: '/buy_vouncher_confirmation',
      page: BuyVouncherConfirmationRoute.page,
    ),
    AutoRoute(
      path: '/my_simple_coins',
      page: MySimpleCoinsRouter.page,
    ),
    AutoRoute(
      path: '/simple_coin_transaction_history',
      page: SimpleCoinTransactionHistoryRoute.page,
    ),
    AutoRoute(
      path: '/pay_with_screen',
      page: PayWithScreenRouter.page,
    ),
    AutoRoute(
      path: '/payment_currence_buy',
      page: PaymentCurrenceBuyRouter.page,
    ),
    AutoRoute(
      path: '/buy_p2p_meyment_method',
      page: BuyP2pPeymentMethodRouter.page,
    ),
    AutoRoute(
      path: '/p2p_buy_amount',
      page: P2PBuyAmountRouter.page,
    ),
    AutoRoute(
      path: '/buy_p2p_confirmation',
      page: BuyP2PConfirmationRoute.page,
    ),
    AutoRoute(
      path: '/get_simple_card',
      page: GetSimpleCardRouter.page,
      fullscreenDialog: true,
    ),
    AutoRoute(
      path: '/asset_transaction_history',
      page: AssetTransactionHistoryRouter.page,
    ),
    AutoRoute(
      path: '/jar_transaction_history',
      page: JarTransactionHistoryRouter.page,
    ),
    AutoRoute(
      path: '/kyc_aid_web_view',
      page: KycAidWebViewRouter.page,
    ),
    AutoRoute(
      path: '/kyc_aid_choose_country',
      page: KycAidChooseCountryRouter.page,
    ),
    AutoRoute(
      path: '/market_sector_details',
      page: MarketSectorDetailsRouter.page,
    ),
    AutoRoute(
      path: '/enter_jar_name',
      page: EnterJarNameRouter.page,
    ),
    AutoRoute(
      path: '/enter_jar_goal',
      page: EnterJarGoalRouter.page,
    ),
    AutoRoute(
      path: '/enter_jar_description',
      page: EnterJarDescriptionRouter.page,
    ),
    AutoRoute(
      path: '/create_new_jar',
      page: CreateNewJarRouter.page,
    ),
    AutoRoute(
      path: '/jar',
      page: JarRouter.page,
    ),
    AutoRoute(
      path: '/all-jars',
      page: AllJarsRouter.page,
    ),
    AutoRoute(
      path: '/jar_closed_confirmation',
      page: JarClosedConfirmationRouter.page,
    ),
    AutoRoute(
      path: '/jar_share',
      page: JarShareRouter.page,
    ),
    AutoRoute(
      path: '/change_email',
      page: ChangeEmailRouter.page,
    ),
    AutoRoute(
      path: '/change_email_verification',
      page: ChangeEmailVerificationRouter.page,
    ),
    AutoRoute(
      path: '/get_personal_iban',
      page: GetPersonalIbanRouter.page,
    ),
    AutoRoute(
      path: '/web_view',
      page: WebViewRouter.page,
    ),
  ];
}
