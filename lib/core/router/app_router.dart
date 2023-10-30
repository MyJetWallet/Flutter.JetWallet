import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/guards/init_guard.dart';
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
import 'package:jetwallet/features/account/widgets/help_center_web_view.dart';
import 'package:jetwallet/features/add_circle_card/ui/add_circle_card.dart';
import 'package:jetwallet/features/add_circle_card/ui/circle_billing_address/circle_billing_address.dart';
import 'package:jetwallet/features/app/api_selector_screen/api_selector_screen.dart';
import 'package:jetwallet/features/app/init_router/app_init_router.dart';
import 'package:jetwallet/features/auth/biometric/ui/biometric.dart';
import 'package:jetwallet/features/auth/biometric/ui/components/allow_biometric.dart';
import 'package:jetwallet/features/auth/email_verification/ui/email_verification_screen.dart';
import 'package:jetwallet/features/auth/onboarding/ui/onboarding_screen.dart';
import 'package:jetwallet/features/auth/single_sign_in/ui/sing_in.dart';
import 'package:jetwallet/features/auth/splash/splash_screen.dart';
import 'package:jetwallet/features/auth/user_data/ui/user_data_screen.dart';
import 'package:jetwallet/features/auth/verification_reg/verification_screen.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/buy_flow/ui/buy_confrimation_screen.dart';
import 'package:jetwallet/features/buy_flow/ui/sell_confrimation_screen.dart';
import 'package:jetwallet/features/card_coming_soon/card_screen.dart';
import 'package:jetwallet/features/convert/model/preview_convert_input.dart';
import 'package:jetwallet/features/convert/ui/convert.dart';
import 'package:jetwallet/features/convert/ui/preview_convert.dart';
import 'package:jetwallet/features/crypto_deposit/crypto_deposit_screen.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_asset_input.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_unlimint_input.dart';
import 'package:jetwallet/features/currency_buy/ui/curency_buy.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/add_bank_card.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/preview_buy_with_asset.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/preview_buy_with_bank_card.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/preview_buy_with_circle/circle_3d_secure_web_view/circle_3d_secure_web_view.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/preview_buy_with_circle/preview_buy_with_circle/preview_buy_with_circle.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/preview_buy_with_unlimint.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/simplex_web_view.dart';
import 'package:jetwallet/features/currency_sell/model/preview_sell_input.dart';
import 'package:jetwallet/features/currency_sell/ui/currency_sell.dart';
import 'package:jetwallet/features/currency_sell/ui/preview_sell.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/debug_info/debug_info.dart';
import 'package:jetwallet/features/debug_info/signalr_debug_info.dart';
import 'package:jetwallet/features/email_confirmation/ui/email_confirmation_screen.dart';
import 'package:jetwallet/features/home/home_screen.dart';
import 'package:jetwallet/features/iban/iban_add_bank_account_screen.dart';
import 'package:jetwallet/features/iban/iban_send/iban_send_amount/ui/iban_send_amount.dart';
import 'package:jetwallet/features/iban/iban_send/iban_send_confirm/ui/iban_send_confirm.dart';
import 'package:jetwallet/features/kyc/allow_camera/ui/allow_camera_screen.dart';
import 'package:jetwallet/features/kyc/choose_documents/ui/choose_documents.dart';
import 'package:jetwallet/features/kyc/kyc_selfie/ui/kyc_selfie.dart';
import 'package:jetwallet/features/kyc/kyc_selfie/ui/widgets/success_kys_screen.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/ui/kyc_verification.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/ui/kyc_verification_sumsub.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/ui/kyc_verify_your_profile.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/kyc/upload_documents/ui/upload_kyc_documents.dart';
import 'package:jetwallet/features/kyc/upload_documents/ui/widgets/upload_verification_photo.dart';
import 'package:jetwallet/features/market/market_details/ui/market_details.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/about_block/components/pdf_view_screen.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/features/market/ui/market_screen.dart';
import 'package:jetwallet/features/my_wallets/screens/cj_account_label_screen.dart';
import 'package:jetwallet/features/my_wallets/screens/cj_account_screen.dart';
import 'package:jetwallet/features/my_wallets/screens/my_wallets_screen.dart';
import 'package:jetwallet/features/payment_methods/ui/payment_methods.dart';
import 'package:jetwallet/features/phone_verification/ui/phone_verification.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/features/pin_screen/ui/pin_screen.dart';
import 'package:jetwallet/features/receive_gift/progres_screen.dart';
import 'package:jetwallet/features/return_to_wallet/model/preview_return_to_wallet_input.dart';
import 'package:jetwallet/features/return_to_wallet/ui/preview_return_to_wallet.dart';
import 'package:jetwallet/features/return_to_wallet/ui/return_to_wallet.dart';
import 'package:jetwallet/features/rewards/ui/rewards.dart';
import 'package:jetwallet/features/rewards_flow/store/rewards_flow_store.dart';
import 'package:jetwallet/features/rewards_flow/ui/reward_open_screen.dart';
import 'package:jetwallet/features/rewards_flow/ui/rewards_flow_screen.dart';
import 'package:jetwallet/features/send_gift/model/send_gift_info_model.dart';
import 'package:jetwallet/features/set_phone_number/ui/set_phone_number.dart';
import 'package:jetwallet/features/sms_autheticator/sms_authenticator.dart';
import 'package:jetwallet/features/transaction_history/ui/transaction_hisotry_screen.dart';
import 'package:jetwallet/features/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import 'package:jetwallet/features/two_fa_phone/ui/two_fa_phone.dart';
import 'package:jetwallet/features/wallet/ui/create_banking_screen.dart';
import 'package:jetwallet/features/wallet/ui/wallet_screen.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/send_card_detail_screen.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/send_card_payment_method_screen.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/send_globally_amount_screen.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/send_globally_confirm_screen.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_address.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_ammount.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_confirm.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_preview.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_screen.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/info_web_view.dart';
import 'package:jetwallet/widgets/result_screens/failure_screen/failure_screen.dart';
import 'package:jetwallet/widgets/result_screens/success_screen/success_screen.dart';
import 'package:jetwallet/widgets/result_screens/verifying_screen/success_verifying_screen.dart';
import 'package:jetwallet/widgets/result_screens/verifying_screen/verifying_screen.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model.dart';
import 'package:simple_networking/modules/signal_r/models/global_send_methods_model.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/iban_withdrawal/iban_preview_withdrawal_model.dart';
import 'package:simple_networking/modules/wallet_api/models/send_globally/send_to_bank_card_response.dart';
import 'package:simple_networking/modules/wallet_api/models/send_globally/send_to_bank_request_model.dart';

import '../../features/auth/splash/splash_screen_no_animation.dart';
import '../../features/currency_buy/models/preview_buy_with_bank_card_input.dart';
import '../../features/currency_buy/models/preview_buy_with_circle_input.dart';
import '../../features/currency_buy/ui/screens/choose_asset_screen.dart';
import '../../features/currency_buy/ui/screens/payment_method_screen.dart';
import '../../features/debug_info/logs_screen.dart';
import '../../features/iban/iban_screen.dart';
import '../../features/iban/widgets/iban_billing_address.dart';
import '../../features/send_gift/screens/gift_amount.dart';
import '../../features/send_gift/screens/gift_order_summary.dart';
import '../../features/send_gift/screens/gift_receivers_details_screen.dart';
import '../../features/send_gift/screens/gift_select_asset_screen.dart';

part 'app_router.gr.dart';

// ignore_for_file: newline-before-return
// ignore_for_file: prefer-trailing-comma

final sRouter = getIt.get<AppRouter>();

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
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
    /*AutoRoute(
      path: '/',
      page: AppInitRoute.page,
    ),
    */
    AutoRoute(
      path: '/',
      page: SplashRoute.page,
    ),
    AutoRoute(
      path: '/splash',
      page: SplashNoAnimationRoute.page,
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
      path: '/api_selector',
      page: ApiSelectorRouter.page,
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
          path: 'iban',
          page: IBanRouter.page,
        ),
        AutoRoute(
          path: 'card',
          page: CardRouter.page,
        ),
        AutoRoute(
          path: 'rewards',
          page: RewardsFlowRouter.page,
        ),
      ],
    ),
    CustomRoute(
      path: '/verification_screen',
      page: VerificationRouter.page,
      transitionsBuilder: TransitionsBuilders.slideBottom,
    ),
    AutoRoute(
      path: '/kyc_verification',
      page: KycVerificationRouter.page,
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
      path: '/help_center_webview',
      page: HelpCenterWebViewRouter.page,
    ),
    AutoRoute(
      path: '/info_web_view',
      page: InfoWebViewRouter.page,
    ),
    AutoRoute(
      path: '/choose_documents',
      page: ChooseDocumentsRouter.page,
    ),
    AutoRoute(
      path: '/kyc_verification_sumsub',
      page: KycVerificationSumsubRouter.page,
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
      path: '/kyc_verify_your_profile',
      page: KycVerifyYourProfileRouter.page,
    ),
    AutoRoute(
      path: '/currency_buy',
      page: CurrencyBuyRouter.page,
    ),
    AutoRoute(
      path: '/choose_asset',
      page: ChooseAssetRouter.page,
    ),
    AutoRoute(
      path: '/payment_method',
      page: PaymentMethodRouter.page,
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
      path: '/add_circle_card',
      page: AddCircleCardRouter.page,
    ),
    AutoRoute(
      path: '/add_bank_card',
      page: AddUnlimintCardRouter.page,
    ),
    AutoRoute(
      path: '/circle_billing_address',
      page: CircleBillingAddressRouter.page,
    ),
    AutoRoute(
      path: '/iban_address',
      page: IbanAddressRouter.page,
    ),
    AutoRoute(
      path: '/iban_add_account',
      page: IbanAddBankAccountRouter.page,
    ),
    CustomRoute(
      path: '/iban_edit_account',
      page: IbanEditBankAccountRouter.page,
      transitionsBuilder: TransitionsBuilders.slideBottom,
    ),
    AutoRoute(
      path: '/preview_convert',
      page: PreviewConvertRouter.page,
    ),
    AutoRoute(
      path: '/convert',
      page: ConvertRouter.page,
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
      path: '/sms_authenticator',
      page: SmsAuthenticatorRouter.page,
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
      path: '/rewards',
      page: RewardsRouter.page,
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
      path: '/two_fa_phone',
      page: TwoFaPhoneRouter.page,
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
      path: '/currency_sell',
      page: CurrencySellRouter.page,
    ),
    AutoRoute(
      path: '/wallet',
      page: WalletRouter.page,
    ),
    AutoRoute(
      path: '/return_to_wallet',
      page: ReturnToWalletRouter.page,
    ),
    AutoRoute(
      path: '/preview_return_to_wallet',
      page: PreviewReturnToWalletRouter.page,
    ),
    AutoRoute(
      path: '/success_kyc',
      page: SuccessKycScreenRoute.page,
    ),
    AutoRoute(
      path: '/preview_buy_with_bank_card',
      page: PreviewBuyWithBankCardRouter.page,
    ),
    AutoRoute(
      path: '/circle_3d_secure',
      page: Circle3dSecureWebViewRouter.page,
    ),
    AutoRoute(
      path: '/simples_webview',
      page: SimplexWebViewRouter.page,
    ),
    AutoRoute(
      path: '/preview_buy_with_unlimit',
      page: PreviewBuyWithUnlimintRouter.page,
    ),
    AutoRoute(
      path: '/preview_buy_with_asset',
      page: PreviewBuyWithAssetRouter.page,
    ),
    AutoRoute(
      path: '/preview_buy_with_circle',
      page: PreviewBuyWithCircleRouter.page,
    ),
    AutoRoute(
      path: '/preview_sell_router',
      page: PreviewSellRouter.page,
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
    
  ];
}
