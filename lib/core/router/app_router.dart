import 'package:auto_route/auto_route.dart';
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
import 'package:jetwallet/features/actions/action_recurring_info/action_recurring_info.dart';
import 'package:jetwallet/features/add_circle_card/ui/add_circle_card.dart';
import 'package:jetwallet/features/add_circle_card/ui/circle_billing_address/circle_billing_address.dart';
import 'package:jetwallet/features/app/api_selector_screen/api_selector_screen.dart';
import 'package:jetwallet/features/app/init_router/app_init_router.dart';
import 'package:jetwallet/features/auth/biometric/ui/biometric.dart';
import 'package:jetwallet/features/auth/biometric/ui/components/allow_biometric.dart';
import 'package:jetwallet/features/auth/email_verification/ui/email_verification_screen.dart';
import 'package:jetwallet/features/auth/onboarding/ui/onboarding_screen.dart';
import 'package:jetwallet/features/auth/reset_password/ui/reset_password_screen.dart';
import 'package:jetwallet/features/auth/single_sign_in/ui/sing_in.dart';
import 'package:jetwallet/features/auth/splash/splash_screen.dart';
import 'package:jetwallet/features/auth/user_data/ui/user_data_screen.dart';
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
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_address_store.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_amount_store.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_preview_store.dart';
import 'package:jetwallet/features/currency_withdraw/ui/currency_withdraw.dart';
import 'package:jetwallet/features/currency_withdraw/ui/widgets/withdrawal_amount.dart';
import 'package:jetwallet/features/currency_withdraw/ui/widgets/withdrawal_confirm.dart';
import 'package:jetwallet/features/currency_withdraw/ui/widgets/withdrawal_preview.dart';
import 'package:jetwallet/features/debug_info/debug_info.dart';
import 'package:jetwallet/features/earn/earn_screen.dart';
import 'package:jetwallet/features/email_confirmation/ui/email_confirmation_screen.dart';
import 'package:jetwallet/features/high_yield_buy/model/preview_high_yield_buy_input.dart';
import 'package:jetwallet/features/high_yield_buy/ui/high_yield_buy.dart';
import 'package:jetwallet/features/high_yield_buy/ui/preview_high_yield_buy.dart';
import 'package:jetwallet/features/home/home_screen.dart';
import 'package:jetwallet/features/kyc/allow_camera/ui/allow_camera_screen.dart';
import 'package:jetwallet/features/kyc/choose_documents/ui/choose_documents.dart';
import 'package:jetwallet/features/kyc/kyc_selfie/ui/kyc_selfie.dart';
import 'package:jetwallet/features/kyc/kyc_selfie/ui/widgets/success_kys_screen.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/ui/kyc_verify_your_profile.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/kyc/upload_documents/ui/upload_kyc_documents.dart';
import 'package:jetwallet/features/kyc/upload_documents/ui/widgets/upload_verification_photo.dart';
import 'package:jetwallet/features/market/market_details/ui/market_details.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/about_block/components/pdf_view_screen.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/features/nft/nft_collection_details/ui/nft_collection_details_screen.dart';
import 'package:jetwallet/features/nft/nft_collection_simple_list/ui/nft_collection_simple_list_screen.dart';
import 'package:jetwallet/features/nft/nft_confirm/ui/nft_confirm_screen.dart';
import 'package:jetwallet/features/nft/nft_details/ui/nft_details_screen.dart';
import 'package:jetwallet/features/market/ui/market_screen.dart';
import 'package:jetwallet/features/nft/nft_receive/ui/nft_receive_screen.dart';
import 'package:jetwallet/features/nft/nft_sell/model/nft_sell_input.dart';
import 'package:jetwallet/features/nft/nft_sell/ui/nft_preview_sell_screen.dart';
import 'package:jetwallet/features/nft/nft_sell/ui/nft_sell_screen.dart';
import 'package:jetwallet/features/payment_methods/ui/payment_methods.dart';
import 'package:jetwallet/features/phone_verification/ui/phone_verification.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/features/pin_screen/ui/pin_screen.dart';
import 'package:jetwallet/features/portfolio/portfolio_screen.dart';
import 'package:jetwallet/features/reccurring/ui/widgets/recurring_success_screen.dart';
import 'package:jetwallet/features/return_to_wallet/model/preview_return_to_wallet_input.dart';
import 'package:jetwallet/features/return_to_wallet/ui/preview_return_to_wallet.dart';
import 'package:jetwallet/features/return_to_wallet/ui/return_to_wallet.dart';
import 'package:jetwallet/features/rewards/ui/rewards.dart';
import 'package:jetwallet/features/send_by_phone/model/contact_model.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_amount_store.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_preview_store.dart';
import 'package:jetwallet/features/send_by_phone/ui/send_by_phone_amount.dart';
import 'package:jetwallet/features/send_by_phone/ui/send_by_phone_confirm.dart';
import 'package:jetwallet/features/send_by_phone/ui/send_by_phone_input/send_by_phone_input.dart';
import 'package:jetwallet/features/send_by_phone/ui/send_by_phone_notify_recipient.dart';
import 'package:jetwallet/features/send_by_phone/ui/send_by_phone_preview.dart';
import 'package:jetwallet/features/set_phone_number/ui/set_phone_number.dart';
import 'package:jetwallet/features/sms_autheticator/sms_authenticator.dart';
import 'package:jetwallet/features/transaction_history/ui/transaction_hisotry_screen.dart';
import 'package:jetwallet/features/transaction_history/ui/widgets/history_recurring_buys.dart';
import 'package:jetwallet/features/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import 'package:jetwallet/features/two_fa_phone/ui/two_fa_phone.dart';
import 'package:jetwallet/features/auth/verification_reg/verification_screen.dart';
import 'package:jetwallet/features/wallet/ui/empty_wallet.dart';
import 'package:jetwallet/features/wallet/ui/wallet_screen.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_address.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_ammount.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_confirm.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_preview.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_screen.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/utils/models/nft_model.dart';
import 'package:jetwallet/widgets/info_web_view.dart';
import 'package:jetwallet/widgets/result_screens/failure_screen/failure_screen.dart';
import 'package:jetwallet/widgets/result_screens/success_screen/success_screen.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:jetwallet/widgets/result_screens/verifying_screen/verifying_screen.dart';
import 'package:jetwallet/widgets/result_screens/verifying_screen/success_verifying_screen.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/account/phone_number/simple_number.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';

import '../../features/auth/splash/splash_screen_no_animation.dart';
import '../../features/currency_buy/models/preview_buy_with_bank_card_input.dart';
import '../../features/currency_buy/models/preview_buy_with_circle_input.dart';
import '../../features/currency_buy/ui/screens/choose_asset_screen.dart';
import '../../features/currency_buy/ui/screens/payment_method_screen.dart';
import '../../features/debug_info/logs_screen.dart';

part 'app_router.gr.dart';

// ignore_for_file: newline-before-return
// ignore_for_file: prefer-trailing-comma

final sRouter = getIt.get<AppRouter>();

@CupertinoAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(
      initial: true,
      path: '/init',
      name: 'AppInitRoute',
      page: AppInitRouter,
    ),
    AutoRoute(
      path: '/splash',
      name: 'SplashRoute',
      page: SplashScreen,
    ),
    AutoRoute(
      path: '/splash_no_animation',
      name: 'SplashNoAnimationRoute',
      page: SplashScreenNoAnimation,
    ),
    AutoRoute(
      path: '/splash_screen',
      name: 'OnboardingRoute',
      page: OnboardingScreen,
    ),
    AutoRoute(
      path: '/singin',
      name: 'SingInRouter',
      page: SingIn,
    ),
    AutoRoute(
      path: '/user_data',
      name: 'UserDataScreenRouter',
      page: UserDataScreen,
    ),
    AutoRoute(
      path: '/email_verification',
      name: 'EmailVerificationRoute',
      page: EmailVerification,
    ),
    AutoRoute(
      path: '/reset_password',
      name: 'ResetPasswordRoute',
      page: ResetPasswordScreen,
    ),
    AutoRoute(
      path: '/allow_camera',
      name: 'AllowCameraRoute',
      page: AllowCameraScreen,
    ),
    AutoRoute(
      path: '/allow_biometric',
      name: 'AllowBiometricRoute',
      page: AllowBiometric,
    ),
    AutoRoute(
      path: '/api_selector',
      name: 'ApiSelectorRouter',
      page: ApiSelectorScreen,
    ),
    AutoRoute(
      // initial: true,
      guards: [InitGuard],
      path: '/home',
      name: 'HomeRouter',
      page: HomeScreen,
      children: [
        AutoRoute(
          path: 'market',
          name: 'MarketRouter',
          page: MarketScreen,
          //initial: true,
        ),
        AutoRoute(
          path: 'portfolio',
          name: 'PortfolioRouter',
          page: PortfolioScreen,
        ),
      ],
    ),
    CustomRoute(
      path: '/verification_screen',
      name: 'VerificationRouter',
      page: VerificationScreen,
      transitionsBuilder: TransitionsBuilders.slideBottom,
    ),
    AutoRoute(
      path: '/account',
      name: 'AccountRouter',
      page: AccountScreen,
    ),
    AutoRoute(
      path: '/crisp',
      name: 'CrispRouter',
      page: Crisp,
    ),
    AutoRoute(
      path: '/help_center_webview',
      name: 'HelpCenterWebViewRouter',
      page: HelpCenterWebView,
    ),
    AutoRoute(
      path: '/info_web_view',
      name: 'InfoWebViewRouter',
      page: InfoWebView,
    ),
    AutoRoute(
      path: '/choose_documents',
      name: 'ChooseDocumentsRouter',
      page: ChooseDocuments,
    ),
    AutoRoute(
      path: '/upload_kyc_documents',
      name: 'UploadKycDocumentsRouter',
      page: UploadKycDocuments,
    ),
    AutoRoute(
      path: '/upload_verification_photo',
      name: 'UploadVerificationPhotoRouter',
      page: UploadVerificationPhoto,
    ),
    AutoRoute(
      path: '/kyc_selfie',
      name: 'KycSelfieRouter',
      page: KycSelfie,
    ),
    AutoRoute(
      path: '/kyc_verify_your_profile',
      name: 'KycVerifyYourProfileRouter',
      page: KycVerifyYourProfile,
    ),
    AutoRoute(
      path: '/currency_buy',
      name: 'CurrencyBuyRouter',
      page: CurrencyBuy,
    ),
    AutoRoute(
      path: '/choose_asset',
      name: 'ChooseAssetRouter',
      page: ChooseAssetScreen,
    ),
    AutoRoute(
      path: '/payment_method',
      name: 'PaymentMethodRouter',
      page: PaymentMethodScreen,
    ),
    AutoRoute(
      path: '/crypto_deposit',
      name: 'CryptoDepositRouter',
      page: CryptoDeposit,
    ),
    AutoRoute(
      path: '/transaction_history',
      name: 'TransactionHistoryRouter',
      page: TransactionHistory,
    ),
    AutoRoute(
      path: '/recurring_success',
      name: 'RecurringSuccessScreenRouter',
      page: RecurringSuccessScreen,
    ),
    AutoRoute(
      path: '/history_recurring_buys',
      name: 'HistoryRecurringBuysRouter',
      page: HistoryRecurringBuys,
    ),
    AutoRoute(
      path: '/add_circle_card',
      name: 'AddCircleCardRouter',
      page: AddCircleCard,
    ),
    AutoRoute(
      path: '/add_bank_card',
      name: 'AddUnlimintCardRouter',
      page: AddBankCard,
    ),
    AutoRoute(
      path: '/circle_billing_address',
      name: 'CircleBillingAddressRouter',
      page: CircleBillingAddress,
    ),
    AutoRoute(
      path: '/preview_convert',
      name: 'PreviewConvertRouter',
      page: PreviewConvert,
    ),
    AutoRoute(
      path: '/convert',
      name: 'ConvertRouter',
      page: Convert,
    ),
    AutoRoute(
      path: '/success_screen',
      name: 'SuccessScreenRouter',
      page: SuccessScreen,
    ),
    AutoRoute(
      path: '/waiting_screen',
      name: 'WaitingScreenRouter',
      page: WaitingScreen,
    ),
    AutoRoute(
      path: '/failure_screen',
      name: 'FailureScreenRouter',
      page: FailureScreen,
    ),
    AutoRoute(
      path: '/verifying_screen',
      name: 'VerifyingScreenRouter',
      page: VerifyingScreen,
    ),
    AutoRoute(
      path: '/verifying_success_screen',
      name: 'SuccessVerifyingScreenRouter',
      page: SuccessVerifyingScreen,
    ),
    AutoRoute(
      path: '/sms_authenticator',
      name: 'SmsAuthenticatorRouter',
      page: SmsAuthenticator,
    ),
    AutoRoute(
      path: '/set_phone_number',
      name: 'SetPhoneNumberRouter',
      page: SetPhoneNumber,
    ),
    AutoRoute(
      path: '/set_new_password',
      name: 'SetNewPasswordRouter',
      page: SetNewPassword,
    ),
    AutoRoute(
      path: '/rewards',
      name: 'RewardsRouter',
      page: Rewards,
    ),
    AutoRoute(
      path: '/phone_verification',
      name: 'PhoneVerificationRouter',
      page: PhoneVerification,
    ),
    AutoRoute(
      path: '/payments_methods',
      name: 'PaymentMethodsRouter',
      page: PaymentMethods,
    ),
    AutoRoute(
      path: '/pin_screen',
      name: 'PinScreenRoute',
      page: PinScreen,
    ),
    AutoRoute(
      path: '/two_fa_phone',
      name: 'TwoFaPhoneRouter',
      page: TwoFaPhone,
    ),
    AutoRoute(
      path: '/email_confirmation',
      name: 'EmailConfirmationRouter',
      page: EmailConfirmationScreen,
    ),
    AutoRoute(
      path: '/biometric',
      name: 'BiometricRouter',
      page: Biometric,
    ),
    AutoRoute(
      path: '/change_password',
      name: 'ChangePasswordRouter',
      page: ChangePassword,
    ),
    AutoRoute(
      path: '/delete_profile',
      name: 'DeleteProfileRouter',
      page: DeleteProfile,
    ),
    AutoRoute(
      path: '/profile_details',
      name: 'ProfileDetailsRouter',
      page: ProfileDetails,
    ),
    AutoRoute(
      path: '/account_sercurity',
      name: 'AccountSecurityRouter',
      page: AccountSecurity,
    ),
    AutoRoute(
      path: '/about_us',
      name: 'AboutUsRouter',
      page: AboutUs,
    ),
    AutoRoute(
      path: '/debug_info',
      name: 'DebugInfoRouter',
      page: DebugInfo,
    ),
    AutoRoute(
      path: '/show_recurring_info_action',
      name: 'ShowRecurringInfoActionRouter',
      page: ShowRecurringInfoAction,
    ),
    AutoRoute(
      path: '/send_by_phone_input',
      name: 'SendByPhoneInputRouter',
      page: SendByPhoneInput,
    ),
    AutoRoute(
      path: '/currency_withdraw',
      name: 'CurrencyWithdrawRouter',
      page: CurrencyWithdraw,
    ),
    AutoRoute(
      path: '/currency_sell',
      name: 'CurrencySellRouter',
      page: CurrencySell,
    ),
    AutoRoute(
      path: '/emptry_wallet',
      name: 'EmptyWalletRouter',
      page: EmptyWallet,
    ),
    AutoRoute(
      path: '/wallet',
      name: 'WalletRouter',
      page: Wallet,
    ),
    AutoRoute(
      path: '/return_to_wallet',
      name: 'ReturnToWalletRouter',
      page: ReturnToWallet,
    ),
    AutoRoute(
      path: '/preview_return_to_wallet',
      name: 'PreviewReturnToWalletRouter',
      page: PreviewReturnToWallet,
    ),
    AutoRoute(
      path: '/success_kyc',
      name: 'SuccessKycScreenRoute',
      page: SuccessKycScreen,
    ),
    AutoRoute(
      path: '/high_yield_buy',
      name: 'HighYieldBuyRouter',
      page: HighYieldBuy,
    ),
    AutoRoute(
      path: '/preview_high_yield_buy',
      name: 'PreviewHighYieldBuyScreenRouter',
      page: PreviewHighYieldBuyScreen,
    ),
    AutoRoute(
      path: '/preview_buy_with_bank_card',
      name: 'PreviewBuyWithBankCardRouter',
      page: PreviewBuyWithBankCard,
    ),
    AutoRoute(
      path: '/circle_3d_secure',
      name: 'Circle3dSecureWebViewRouter',
      page: Circle3dSecureWebView,
    ),
    AutoRoute(
      path: '/simples_webview',
      name: 'SimplexWebViewRouter',
      page: SimplexWebView,
    ),
    AutoRoute(
      path: '/preview_buy_with_unlimit',
      name: 'PreviewBuyWithUnlimintRouter',
      page: PreviewBuyWithUnlimint,
    ),
    AutoRoute(
      path: '/preview_buy_with_asset',
      name: 'PreviewBuyWithAssetRouter',
      page: PreviewBuyWithAsset,
    ),
    AutoRoute(
      path: '/preview_buy_with_circle',
      name: 'PreviewBuyWithCircleRouter',
      page: PreviewBuyWithCircle,
    ),
    AutoRoute(
      path: '/preview_sell_router',
      name: 'PreviewSellRouter',
      page: PreviewSell,
    ),
    AutoRoute(
      path: '/send_by_phone_notify_recipient',
      name: 'SendByPhoneNotifyRecipientRouter',
      page: SendByPhoneNotifyRecipient,
    ),
    AutoRoute(
      path: '/send_by_phone_amount',
      name: 'SendByPhoneAmountRouter',
      page: SendByPhoneAmount,
    ),
    AutoRoute(
      path: '/send_by_phone_confirm',
      name: 'SendByPhoneConfirmRouter',
      page: SendByPhoneConfirm,
    ),
    AutoRoute(
      path: '/send_by_phone_preview',
      name: 'SendByPhonePreviewRouter',
      page: SendByPhonePreview,
    ),
    AutoRoute(
      path: '/delete_reasons_screen',
      name: 'DeleteReasonsScreenRouter',
      page: DeleteReasonsScreen,
    ),
    AutoRoute(
      path: '/pdf_view_screen',
      name: 'PDFViewScreenRouter',
      page: PDFViewScreen,
    ),
    AutoRoute(
      path: '/market_details',
      name: 'MarketDetailsRouter',
      page: MarketDetails,
    ),
    AutoRoute(
      path: '/change_base_asset',
      name: 'DefaultAssetChangeRouter',
      page: DefaultAssetChange,
    ),
    AutoRoute(
      path: '/nft_collection',
      name: 'NftCollectionDetailsRouter',
      page: NftCollectionDetails,
    ),
    AutoRoute(
      path: '/nft_details',
      name: 'NFTDetailsRouter',
      page: NFTDetailsScreen,
    ),
    AutoRoute(
      path: '/nft_confirm',
      name: 'NFTConfirmRouter',
      page: NFTConfirmScreen,
    ),
    AutoRoute(
      path: '/nft_collection_simple_list_router',
      name: 'NFTCollectionSimpleListRouter',
      page: NFTCollectionSimpleListScreen,
    ),
    AutoRoute(
      path: '/nft_sell',
      name: 'NFTSellRouter',
      page: NFTSellScreen,
    ),
    AutoRoute(
      path: '/nft_preview_sell',
      name: 'NFTPreviewSellRouter',
      page: NFTPreviewSellScreen,
    ),
    AutoRoute(
      path: '/nft_receive',
      name: 'ReceiveNFTRouter',
      page: ReceiveNFTScreen,
    ),
    AutoRoute(
      path: '/logs_debug',
      name: 'LogsRouter',
      page: LogsScreen,
    ),
    AutoRoute(
      path: '/withdrawal',
      name: 'WithdrawRouter',
      page: WithdrawalScreen,
      children: [
        AutoRoute(
          path: 'withdrawal_address',
          name: 'WithdrawalAddressRouter',
          page: WithdrawalAddressScreen,
          initial: true,
        ),
        AutoRoute(
          path: 'withdrawal_ammount',
          name: 'WithdrawalAmmountRouter',
          page: WithdrawalAmmountScreen,
        ),
        AutoRoute(
          path: 'withdrawal_confirm',
          name: 'WithdrawalConfirmRouter',
          page: WithdrawalConfirmScreen,
        ),
        AutoRoute(
          path: 'withdrawal_preview',
          name: 'WithdrawalPreviewRouter',
          page: WithdrawalPreviewScreen,
        ),
      ],
    )
  ],
)
class AppRouter extends _$AppRouter {
  //AppRouter();
  AppRouter({required super.initGuard});
}
