// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter({
    GlobalKey<NavigatorState>? navigatorKey,
    required this.initGuard,
  }) : super(navigatorKey);

  final InitGuard initGuard;

  @override
  final Map<String, PageFactory> pagesMap = {
    AppInitRoute.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const AppInitRouter(),
      );
    },
    SplashRoute.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
    SplashNoAnimationRoute.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const SplashScreenNoAnimation(),
      );
    },
    OnboardingRoute.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const OnboardingScreen(),
      );
    },
    SingInRouter.name: (routeData) {
      final args = routeData.argsAs<SingInRouterArgs>(
          orElse: () => const SingInRouterArgs());
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: SingIn(
          key: args.key,
          email: args.email,
        ),
      );
    },
    UserDataScreenRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const UserDataScreen(),
      );
    },
    EmailVerificationRoute.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const EmailVerification(),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const ResetPasswordScreen(),
      );
    },
    AllowCameraRoute.name: (routeData) {
      final args = routeData.argsAs<AllowCameraRouteArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: AllowCameraScreen(
          key: args.key,
          permissionDescription: args.permissionDescription,
          then: args.then,
        ),
      );
    },
    AllowBiometricRoute.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const AllowBiometric(),
      );
    },
    ApiSelectorRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const ApiSelectorScreen(),
      );
    },
    HomeRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    VerificationRouter.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const VerificationScreen(),
        transitionsBuilder: TransitionsBuilders.slideBottom,
        opaque: true,
        barrierDismissible: false,
      );
    },
    AccountRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const AccountScreen(),
      );
    },
    CrispRouter.name: (routeData) {
      final args = routeData.argsAs<CrispRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: Crisp(
          key: args.key,
          welcomeText: args.welcomeText,
        ),
      );
    },
    HelpCenterWebViewRouter.name: (routeData) {
      final args = routeData.argsAs<HelpCenterWebViewRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: HelpCenterWebView(
          key: args.key,
          link: args.link,
        ),
      );
    },
    InfoWebViewRouter.name: (routeData) {
      final args = routeData.argsAs<InfoWebViewRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: InfoWebView(
          key: args.key,
          link: args.link,
          title: args.title,
        ),
      );
    },
    ChooseDocumentsRouter.name: (routeData) {
      final args = routeData.argsAs<ChooseDocumentsRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: ChooseDocuments(
          key: args.key,
          headerTitle: args.headerTitle,
        ),
      );
    },
    UploadKycDocumentsRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const UploadKycDocuments(),
      );
    },
    UploadVerificationPhotoRouter.name: (routeData) {
      final args = routeData.argsAs<UploadVerificationPhotoRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: UploadVerificationPhoto(
          key: args.key,
          isSelfie: args.isSelfie,
          cardId: args.cardId,
          onSuccess: args.onSuccess,
        ),
      );
    },
    KycSelfieRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const KycSelfie(),
      );
    },
    KycVerifyYourProfileRouter.name: (routeData) {
      final args = routeData.argsAs<KycVerifyYourProfileRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: KycVerifyYourProfile(
          key: args.key,
          requiredVerifications: args.requiredVerifications,
        ),
      );
    },
    CurrencyBuyRouter.name: (routeData) {
      final args = routeData.argsAs<CurrencyBuyRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: CurrencyBuy(
          key: args.key,
          recurringBuysType: args.recurringBuysType,
          circleCard: args.circleCard,
          unlimintCard: args.unlimintCard,
          bankCard: args.bankCard,
          newBankCardId: args.newBankCardId,
          newBankCardNumber: args.newBankCardNumber,
          currency: args.currency,
          fromCard: args.fromCard,
          paymentMethod: args.paymentMethod,
        ),
      );
    },
    ChooseAssetRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: ChooseAssetScreen(),
      );
    },
    PaymentMethodRouter.name: (routeData) {
      final args = routeData.argsAs<PaymentMethodRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: PaymentMethodScreen(
          key: args.key,
          currency: args.currency,
        ),
      );
    },
    CryptoDepositRouter.name: (routeData) {
      final args = routeData.argsAs<CryptoDepositRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: CryptoDeposit(
          key: args.key,
          header: args.header,
          currency: args.currency,
        ),
      );
    },
    TransactionHistoryRouter.name: (routeData) {
      final args = routeData.argsAs<TransactionHistoryRouterArgs>(
          orElse: () => const TransactionHistoryRouterArgs());
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: TransactionHistory(
          key: args.key,
          assetName: args.assetName,
          assetSymbol: args.assetSymbol,
          initialIndex: args.initialIndex,
          jwOperationId: args.jwOperationId,
        ),
      );
    },
    RecurringSuccessScreenRouter.name: (routeData) {
      final args = routeData.argsAs<RecurringSuccessScreenRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: RecurringSuccessScreen(
          key: args.key,
          input: args.input,
        ),
      );
    },
    HistoryRecurringBuysRouter.name: (routeData) {
      final args = routeData.argsAs<HistoryRecurringBuysRouterArgs>(
          orElse: () => const HistoryRecurringBuysRouterArgs());
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: HistoryRecurringBuys(
          key: args.key,
          from: args.from,
        ),
      );
    },
    AddCircleCardRouter.name: (routeData) {
      final args = routeData.argsAs<AddCircleCardRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: AddCircleCard(
          key: args.key,
          onCardAdded: args.onCardAdded,
        ),
      );
    },
    AddUnlimintCardRouter.name: (routeData) {
      final args = routeData.argsAs<AddUnlimintCardRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: AddBankCard(
          key: args.key,
          onCardAdded: args.onCardAdded,
          amount: args.amount,
          currency: args.currency,
          isPreview: args.isPreview,
        ),
      );
    },
    CircleBillingAddressRouter.name: (routeData) {
      final args = routeData.argsAs<CircleBillingAddressRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: CircleBillingAddress(
          key: args.key,
          onCardAdded: args.onCardAdded,
          expiryDate: args.expiryDate,
          cardholderName: args.cardholderName,
          cardNumber: args.cardNumber,
          cvv: args.cvv,
        ),
      );
    },
    IbanAddressRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const IbanBillingAddress(),
      );
    },
    PreviewConvertRouter.name: (routeData) {
      final args = routeData.argsAs<PreviewConvertRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: PreviewConvert(
          key: args.key,
          input: args.input,
        ),
      );
    },
    ConvertRouter.name: (routeData) {
      final args = routeData.argsAs<ConvertRouterArgs>(
          orElse: () => const ConvertRouterArgs());
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: Convert(
          key: args.key,
          fromCurrency: args.fromCurrency,
        ),
      );
    },
    SuccessScreenRouter.name: (routeData) {
      final args = routeData.argsAs<SuccessScreenRouterArgs>(
          orElse: () => const SuccessScreenRouterArgs());
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: SuccessScreen(
          key: args.key,
          onSuccess: args.onSuccess,
          onActionButton: args.onActionButton,
          primaryText: args.primaryText,
          secondaryText: args.secondaryText,
          specialTextWidget: args.specialTextWidget,
          showActionButton: args.showActionButton,
          showProgressBar: args.showProgressBar,
          showShareButton: args.showShareButton,
          buttonText: args.buttonText,
          time: args.time,
        ),
      );
    },
    WaitingScreenRouter.name: (routeData) {
      final args = routeData.argsAs<WaitingScreenRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: WaitingScreen(
          key: args.key,
          onSuccess: args.onSuccess,
          primaryText: args.primaryText,
          secondaryText: args.secondaryText,
          specialTextWidget: args.specialTextWidget,
          wasAction: args.wasAction,
          onSkip: args.onSkip,
        ),
      );
    },
    FailureScreenRouter.name: (routeData) {
      final args = routeData.argsAs<FailureScreenRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: FailureScreen(
          key: args.key,
          secondaryText: args.secondaryText,
          secondaryButtonName: args.secondaryButtonName,
          onSecondaryButtonTap: args.onSecondaryButtonTap,
          primaryText: args.primaryText,
          primaryButtonName: args.primaryButtonName,
          onPrimaryButtonTap: args.onPrimaryButtonTap,
        ),
      );
    },
    VerifyingScreenRouter.name: (routeData) {
      final args = routeData.argsAs<VerifyingScreenRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: VerifyingScreen(
          key: args.key,
          cardId: args.cardId,
          onSuccess: args.onSuccess,
        ),
      );
    },
    SuccessVerifyingScreenRouter.name: (routeData) {
      final args = routeData.argsAs<SuccessVerifyingScreenRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: SuccessVerifyingScreen(
          key: args.key,
          onSuccess: args.onSuccess,
        ),
      );
    },
    SmsAuthenticatorRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const SmsAuthenticator(),
      );
    },
    SetPhoneNumberRouter.name: (routeData) {
      final args = routeData.argsAs<SetPhoneNumberRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: SetPhoneNumber(
          key: args.key,
          then: args.then,
          isChangePhone: args.isChangePhone,
          fromRegister: args.fromRegister,
          successText: args.successText,
        ),
      );
    },
    SetNewPasswordRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const SetNewPassword(),
      );
    },
    RewardsRouter.name: (routeData) {
      final args = routeData.argsAs<RewardsRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: Rewards(
          key: args.key,
          actualRewards: args.actualRewards,
        ),
      );
    },
    PhoneVerificationRouter.name: (routeData) {
      final args = routeData.argsAs<PhoneVerificationRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: PhoneVerification(
          key: args.key,
          args: args.args,
        ),
      );
    },
    PaymentMethodsRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const PaymentMethods(),
      );
    },
    PinScreenRoute.name: (routeData) {
      final args = routeData.argsAs<PinScreenRouteArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: PinScreen(
          key: args.key,
          displayHeader: args.displayHeader,
          cannotLeave: args.cannotLeave,
          isChangePhone: args.isChangePhone,
          isChangePin: args.isChangePin,
          fromRegister: args.fromRegister,
          isForgotPassword: args.isForgotPassword,
          onChangePhone: args.onChangePhone,
          union: args.union,
        ),
      );
    },
    TwoFaPhoneRouter.name: (routeData) {
      final args = routeData.argsAs<TwoFaPhoneRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: TwoFaPhone(
          key: args.key,
          trigger: args.trigger,
        ),
      );
    },
    EmailConfirmationRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const EmailConfirmationScreen(),
      );
    },
    BiometricRouter.name: (routeData) {
      final args = routeData.argsAs<BiometricRouterArgs>(
          orElse: () => const BiometricRouterArgs());
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: Biometric(
          key: args.key,
          isAccSettings: args.isAccSettings,
        ),
      );
    },
    ChangePasswordRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const ChangePassword(),
      );
    },
    DeleteProfileRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const DeleteProfile(),
      );
    },
    ProfileDetailsRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const ProfileDetails(),
      );
    },
    AccountSecurityRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const AccountSecurity(),
      );
    },
    AboutUsRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const AboutUs(),
      );
    },
    DebugInfoRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const DebugInfo(),
      );
    },
    ShowRecurringInfoActionRouter.name: (routeData) {
      final args = routeData.argsAs<ShowRecurringInfoActionRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: ShowRecurringInfoAction(
          key: args.key,
          recurringItem: args.recurringItem,
          assetName: args.assetName,
        ),
      );
    },
    SendByPhoneInputRouter.name: (routeData) {
      final args = routeData.argsAs<SendByPhoneInputRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: SendByPhoneInput(
          key: args.key,
          currency: args.currency,
        ),
      );
    },
    CurrencyWithdrawRouter.name: (routeData) {
      final args = routeData.argsAs<CurrencyWithdrawRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: CurrencyWithdraw(
          key: args.key,
          withdrawal: args.withdrawal,
        ),
      );
    },
    CurrencySellRouter.name: (routeData) {
      final args = routeData.argsAs<CurrencySellRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: CurrencySell(
          key: args.key,
          currency: args.currency,
        ),
      );
    },
    EmptyWalletRouter.name: (routeData) {
      final args = routeData.argsAs<EmptyWalletRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: EmptyWallet(
          key: args.key,
          currency: args.currency,
        ),
      );
    },
    WalletRouter.name: (routeData) {
      final args = routeData.argsAs<WalletRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: Wallet(
          key: args.key,
          currency: args.currency,
        ),
      );
    },
    ReturnToWalletRouter.name: (routeData) {
      final args = routeData.argsAs<ReturnToWalletRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: ReturnToWallet(
          key: args.key,
          currency: args.currency,
          earnOffer: args.earnOffer,
        ),
      );
    },
    PreviewReturnToWalletRouter.name: (routeData) {
      final args = routeData.argsAs<PreviewReturnToWalletRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: PreviewReturnToWallet(
          key: args.key,
          input: args.input,
        ),
      );
    },
    SuccessKycScreenRoute.name: (routeData) {
      final args = routeData.argsAs<SuccessKycScreenRouteArgs>(
          orElse: () => const SuccessKycScreenRouteArgs());
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: SuccessKycScreen(
          key: args.key,
          primaryText: args.primaryText,
          secondaryText: args.secondaryText,
          specialTextWidget: args.specialTextWidget,
        ),
      );
    },
    HighYieldBuyRouter.name: (routeData) {
      final args = routeData.argsAs<HighYieldBuyRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: HighYieldBuy(
          key: args.key,
          topUp: args.topUp,
          currency: args.currency,
          earnOffer: args.earnOffer,
        ),
      );
    },
    PreviewHighYieldBuyScreenRouter.name: (routeData) {
      final args = routeData.argsAs<PreviewHighYieldBuyScreenRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: PreviewHighYieldBuyScreen(
          key: args.key,
          input: args.input,
        ),
      );
    },
    PreviewBuyWithBankCardRouter.name: (routeData) {
      final args = routeData.argsAs<PreviewBuyWithBankCardRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: PreviewBuyWithBankCard(
          key: args.key,
          input: args.input,
        ),
      );
    },
    Circle3dSecureWebViewRouter.name: (routeData) {
      final args = routeData.argsAs<Circle3dSecureWebViewRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: Circle3dSecureWebView(
          args.url,
          args.asset,
          args.amount,
          args.onSuccess,
          args.onCancel,
          args.paymentId,
          args.onFailed,
        ),
      );
    },
    SimplexWebViewRouter.name: (routeData) {
      final args = routeData.argsAs<SimplexWebViewRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: SimplexWebView(args.url),
      );
    },
    PreviewBuyWithUnlimintRouter.name: (routeData) {
      final args = routeData.argsAs<PreviewBuyWithUnlimintRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: PreviewBuyWithUnlimint(
          key: args.key,
          input: args.input,
        ),
      );
    },
    PreviewBuyWithAssetRouter.name: (routeData) {
      final args = routeData.argsAs<PreviewBuyWithAssetRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: PreviewBuyWithAsset(
          key: args.key,
          onBackButtonTap: args.onBackButtonTap,
          input: args.input,
        ),
      );
    },
    PreviewBuyWithCircleRouter.name: (routeData) {
      final args = routeData.argsAs<PreviewBuyWithCircleRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: PreviewBuyWithCircle(
          key: args.key,
          input: args.input,
        ),
      );
    },
    PreviewSellRouter.name: (routeData) {
      final args = routeData.argsAs<PreviewSellRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: PreviewSell(
          key: args.key,
          input: args.input,
        ),
      );
    },
    SendByPhoneNotifyRecipientRouter.name: (routeData) {
      final args = routeData.argsAs<SendByPhoneNotifyRecipientRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: SendByPhoneNotifyRecipient(
          key: args.key,
          toPhoneNumber: args.toPhoneNumber,
        ),
      );
    },
    SendByPhoneAmountRouter.name: (routeData) {
      final args = routeData.argsAs<SendByPhoneAmountRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: SendByPhoneAmount(
          key: args.key,
          currency: args.currency,
          pickedContact: args.pickedContact,
          activeDialCode: args.activeDialCode,
        ),
      );
    },
    SendByPhoneConfirmRouter.name: (routeData) {
      final args = routeData.argsAs<SendByPhoneConfirmRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: SendByPhoneConfirm(
          key: args.key,
          currency: args.currency,
          operationId: args.operationId,
          receiverIsRegistered: args.receiverIsRegistered,
          amountStoreAmount: args.amountStoreAmount,
          pickedContact: args.pickedContact,
          activeDialCode: args.activeDialCode,
        ),
      );
    },
    SendByPhonePreviewRouter.name: (routeData) {
      final args = routeData.argsAs<SendByPhonePreviewRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: SendByPhonePreview(
          key: args.key,
          currency: args.currency,
          amountStoreAmount: args.amountStoreAmount,
          pickedContact: args.pickedContact,
          activeDialCode: args.activeDialCode,
        ),
      );
    },
    DeleteReasonsScreenRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const DeleteReasonsScreen(),
      );
    },
    PDFViewScreenRouter.name: (routeData) {
      final args = routeData.argsAs<PDFViewScreenRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: PDFViewScreen(
          key: args.key,
          url: args.url,
        ),
      );
    },
    MarketDetailsRouter.name: (routeData) {
      final args = routeData.argsAs<MarketDetailsRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: MarketDetails(
          key: args.key,
          marketItem: args.marketItem,
        ),
      );
    },
    DefaultAssetChangeRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const DefaultAssetChange(),
      );
    },
    NftCollectionDetailsRouter.name: (routeData) {
      final args = routeData.argsAs<NftCollectionDetailsRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: NftCollectionDetails(
          key: args.key,
          collectionID: args.collectionID,
        ),
      );
    },
    NFTDetailsRouter.name: (routeData) {
      final args = routeData.argsAs<NFTDetailsRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: NFTDetailsScreen(
          key: args.key,
          userNFT: args.userNFT,
          nftSymbol: args.nftSymbol,
        ),
      );
    },
    NFTConfirmRouter.name: (routeData) {
      final args = routeData.argsAs<NFTConfirmRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: NFTConfirmScreen(
          key: args.key,
          nft: args.nft,
        ),
      );
    },
    NFTCollectionSimpleListRouter.name: (routeData) {
      final args = routeData.argsAs<NFTCollectionSimpleListRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: NFTCollectionSimpleListScreen(
          key: args.key,
          collectionID: args.collectionID,
        ),
      );
    },
    NFTSellRouter.name: (routeData) {
      final args = routeData.argsAs<NFTSellRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: NFTSellScreen(
          key: args.key,
          nft: args.nft,
        ),
      );
    },
    NFTPreviewSellRouter.name: (routeData) {
      final args = routeData.argsAs<NFTPreviewSellRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: NFTPreviewSellScreen(
          key: args.key,
          input: args.input,
        ),
      );
    },
    ReceiveNFTRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const ReceiveNFTScreen(),
      );
    },
    LogsRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const LogsScreen(),
      );
    },
    WithdrawRouter.name: (routeData) {
      final args = routeData.argsAs<WithdrawRouterArgs>();
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: WithdrawalScreen(
          key: args.key,
          withdrawal: args.withdrawal,
        ),
      );
    },
    MarketRouter.name: (routeData) {
      final args = routeData.argsAs<MarketRouterArgs>(
          orElse: () => const MarketRouterArgs());
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: MarketScreen(
          key: args.key,
          initIndex: args.initIndex,
        ),
      );
    },
    PortfolioRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const PortfolioScreen(),
      );
    },
    IBanRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const IBanScreen(),
      );
    },
    WithdrawalAddressRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const WithdrawalAddressScreen(),
      );
    },
    WithdrawalAmmountRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const WithdrawalAmmountScreen(),
      );
    },
    WithdrawalConfirmRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const WithdrawalConfirmScreen(),
      );
    },
    WithdrawalPreviewRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const WithdrawalPreviewScreen(),
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/init',
          fullMatch: true,
        ),
        RouteConfig(
          AppInitRoute.name,
          path: '/init',
        ),
        RouteConfig(
          SplashRoute.name,
          path: '/splash',
        ),
        RouteConfig(
          SplashNoAnimationRoute.name,
          path: '/splash_no_animation',
        ),
        RouteConfig(
          OnboardingRoute.name,
          path: '/splash_screen',
        ),
        RouteConfig(
          SingInRouter.name,
          path: '/singin',
        ),
        RouteConfig(
          UserDataScreenRouter.name,
          path: '/user_data',
        ),
        RouteConfig(
          EmailVerificationRoute.name,
          path: '/email_verification',
        ),
        RouteConfig(
          ResetPasswordRoute.name,
          path: '/reset_password',
        ),
        RouteConfig(
          AllowCameraRoute.name,
          path: '/allow_camera',
        ),
        RouteConfig(
          AllowBiometricRoute.name,
          path: '/allow_biometric',
        ),
        RouteConfig(
          ApiSelectorRouter.name,
          path: '/api_selector',
        ),
        RouteConfig(
          HomeRouter.name,
          path: '/home',
          guards: [initGuard],
          children: [
            RouteConfig(
              MarketRouter.name,
              path: 'market',
              parent: HomeRouter.name,
            ),
            RouteConfig(
              PortfolioRouter.name,
              path: 'portfolio',
              parent: HomeRouter.name,
            ),
            RouteConfig(
              IBanRouter.name,
              path: 'iban',
              parent: HomeRouter.name,
            ),
          ],
        ),
        RouteConfig(
          VerificationRouter.name,
          path: '/verification_screen',
        ),
        RouteConfig(
          AccountRouter.name,
          path: '/account',
        ),
        RouteConfig(
          CrispRouter.name,
          path: '/crisp',
        ),
        RouteConfig(
          HelpCenterWebViewRouter.name,
          path: '/help_center_webview',
        ),
        RouteConfig(
          InfoWebViewRouter.name,
          path: '/info_web_view',
        ),
        RouteConfig(
          ChooseDocumentsRouter.name,
          path: '/choose_documents',
        ),
        RouteConfig(
          UploadKycDocumentsRouter.name,
          path: '/upload_kyc_documents',
        ),
        RouteConfig(
          UploadVerificationPhotoRouter.name,
          path: '/upload_verification_photo',
        ),
        RouteConfig(
          KycSelfieRouter.name,
          path: '/kyc_selfie',
        ),
        RouteConfig(
          KycVerifyYourProfileRouter.name,
          path: '/kyc_verify_your_profile',
        ),
        RouteConfig(
          CurrencyBuyRouter.name,
          path: '/currency_buy',
        ),
        RouteConfig(
          ChooseAssetRouter.name,
          path: '/choose_asset',
        ),
        RouteConfig(
          PaymentMethodRouter.name,
          path: '/payment_method',
        ),
        RouteConfig(
          CryptoDepositRouter.name,
          path: '/crypto_deposit',
        ),
        RouteConfig(
          TransactionHistoryRouter.name,
          path: '/transaction_history',
        ),
        RouteConfig(
          RecurringSuccessScreenRouter.name,
          path: '/recurring_success',
        ),
        RouteConfig(
          HistoryRecurringBuysRouter.name,
          path: '/history_recurring_buys',
        ),
        RouteConfig(
          AddCircleCardRouter.name,
          path: '/add_circle_card',
        ),
        RouteConfig(
          AddUnlimintCardRouter.name,
          path: '/add_bank_card',
        ),
        RouteConfig(
          CircleBillingAddressRouter.name,
          path: '/circle_billing_address',
        ),
        RouteConfig(
          IbanAddressRouter.name,
          path: '/iban_address',
        ),
        RouteConfig(
          PreviewConvertRouter.name,
          path: '/preview_convert',
        ),
        RouteConfig(
          ConvertRouter.name,
          path: '/convert',
        ),
        RouteConfig(
          SuccessScreenRouter.name,
          path: '/success_screen',
        ),
        RouteConfig(
          WaitingScreenRouter.name,
          path: '/waiting_screen',
        ),
        RouteConfig(
          FailureScreenRouter.name,
          path: '/failure_screen',
        ),
        RouteConfig(
          VerifyingScreenRouter.name,
          path: '/verifying_screen',
        ),
        RouteConfig(
          SuccessVerifyingScreenRouter.name,
          path: '/verifying_success_screen',
        ),
        RouteConfig(
          SmsAuthenticatorRouter.name,
          path: '/sms_authenticator',
        ),
        RouteConfig(
          SetPhoneNumberRouter.name,
          path: '/set_phone_number',
        ),
        RouteConfig(
          SetNewPasswordRouter.name,
          path: '/set_new_password',
        ),
        RouteConfig(
          RewardsRouter.name,
          path: '/rewards',
        ),
        RouteConfig(
          PhoneVerificationRouter.name,
          path: '/phone_verification',
        ),
        RouteConfig(
          PaymentMethodsRouter.name,
          path: '/payments_methods',
        ),
        RouteConfig(
          PinScreenRoute.name,
          path: '/pin_screen',
        ),
        RouteConfig(
          TwoFaPhoneRouter.name,
          path: '/two_fa_phone',
        ),
        RouteConfig(
          EmailConfirmationRouter.name,
          path: '/email_confirmation',
        ),
        RouteConfig(
          BiometricRouter.name,
          path: '/biometric',
        ),
        RouteConfig(
          ChangePasswordRouter.name,
          path: '/change_password',
        ),
        RouteConfig(
          DeleteProfileRouter.name,
          path: '/delete_profile',
        ),
        RouteConfig(
          ProfileDetailsRouter.name,
          path: '/profile_details',
        ),
        RouteConfig(
          AccountSecurityRouter.name,
          path: '/account_sercurity',
        ),
        RouteConfig(
          AboutUsRouter.name,
          path: '/about_us',
        ),
        RouteConfig(
          DebugInfoRouter.name,
          path: '/debug_info',
        ),
        RouteConfig(
          ShowRecurringInfoActionRouter.name,
          path: '/show_recurring_info_action',
        ),
        RouteConfig(
          SendByPhoneInputRouter.name,
          path: '/send_by_phone_input',
        ),
        RouteConfig(
          CurrencyWithdrawRouter.name,
          path: '/currency_withdraw',
        ),
        RouteConfig(
          CurrencySellRouter.name,
          path: '/currency_sell',
        ),
        RouteConfig(
          EmptyWalletRouter.name,
          path: '/emptry_wallet',
        ),
        RouteConfig(
          WalletRouter.name,
          path: '/wallet',
        ),
        RouteConfig(
          ReturnToWalletRouter.name,
          path: '/return_to_wallet',
        ),
        RouteConfig(
          PreviewReturnToWalletRouter.name,
          path: '/preview_return_to_wallet',
        ),
        RouteConfig(
          SuccessKycScreenRoute.name,
          path: '/success_kyc',
        ),
        RouteConfig(
          HighYieldBuyRouter.name,
          path: '/high_yield_buy',
        ),
        RouteConfig(
          PreviewHighYieldBuyScreenRouter.name,
          path: '/preview_high_yield_buy',
        ),
        RouteConfig(
          PreviewBuyWithBankCardRouter.name,
          path: '/preview_buy_with_bank_card',
        ),
        RouteConfig(
          Circle3dSecureWebViewRouter.name,
          path: '/circle_3d_secure',
        ),
        RouteConfig(
          SimplexWebViewRouter.name,
          path: '/simples_webview',
        ),
        RouteConfig(
          PreviewBuyWithUnlimintRouter.name,
          path: '/preview_buy_with_unlimit',
        ),
        RouteConfig(
          PreviewBuyWithAssetRouter.name,
          path: '/preview_buy_with_asset',
        ),
        RouteConfig(
          PreviewBuyWithCircleRouter.name,
          path: '/preview_buy_with_circle',
        ),
        RouteConfig(
          PreviewSellRouter.name,
          path: '/preview_sell_router',
        ),
        RouteConfig(
          SendByPhoneNotifyRecipientRouter.name,
          path: '/send_by_phone_notify_recipient',
        ),
        RouteConfig(
          SendByPhoneAmountRouter.name,
          path: '/send_by_phone_amount',
        ),
        RouteConfig(
          SendByPhoneConfirmRouter.name,
          path: '/send_by_phone_confirm',
        ),
        RouteConfig(
          SendByPhonePreviewRouter.name,
          path: '/send_by_phone_preview',
        ),
        RouteConfig(
          DeleteReasonsScreenRouter.name,
          path: '/delete_reasons_screen',
        ),
        RouteConfig(
          PDFViewScreenRouter.name,
          path: '/pdf_view_screen',
        ),
        RouteConfig(
          MarketDetailsRouter.name,
          path: '/market_details',
        ),
        RouteConfig(
          DefaultAssetChangeRouter.name,
          path: '/change_base_asset',
        ),
        RouteConfig(
          NftCollectionDetailsRouter.name,
          path: '/nft_collection',
        ),
        RouteConfig(
          NFTDetailsRouter.name,
          path: '/nft_details',
        ),
        RouteConfig(
          NFTConfirmRouter.name,
          path: '/nft_confirm',
        ),
        RouteConfig(
          NFTCollectionSimpleListRouter.name,
          path: '/nft_collection_simple_list_router',
        ),
        RouteConfig(
          NFTSellRouter.name,
          path: '/nft_sell',
        ),
        RouteConfig(
          NFTPreviewSellRouter.name,
          path: '/nft_preview_sell',
        ),
        RouteConfig(
          ReceiveNFTRouter.name,
          path: '/nft_receive',
        ),
        RouteConfig(
          LogsRouter.name,
          path: '/logs_debug',
        ),
        RouteConfig(
          WithdrawRouter.name,
          path: '/withdrawal',
          children: [
            RouteConfig(
              '#redirect',
              path: '',
              parent: WithdrawRouter.name,
              redirectTo: 'withdrawal_address',
              fullMatch: true,
            ),
            RouteConfig(
              WithdrawalAddressRouter.name,
              path: 'withdrawal_address',
              parent: WithdrawRouter.name,
            ),
            RouteConfig(
              WithdrawalAmmountRouter.name,
              path: 'withdrawal_ammount',
              parent: WithdrawRouter.name,
            ),
            RouteConfig(
              WithdrawalConfirmRouter.name,
              path: 'withdrawal_confirm',
              parent: WithdrawRouter.name,
            ),
            RouteConfig(
              WithdrawalPreviewRouter.name,
              path: 'withdrawal_preview',
              parent: WithdrawRouter.name,
            ),
          ],
        ),
      ];
}

/// generated route for
/// [AppInitRouter]
class AppInitRoute extends PageRouteInfo<void> {
  const AppInitRoute()
      : super(
          AppInitRoute.name,
          path: '/init',
        );

  static const String name = 'AppInitRoute';
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/splash',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [SplashScreenNoAnimation]
class SplashNoAnimationRoute extends PageRouteInfo<void> {
  const SplashNoAnimationRoute()
      : super(
          SplashNoAnimationRoute.name,
          path: '/splash_no_animation',
        );

  static const String name = 'SplashNoAnimationRoute';
}

/// generated route for
/// [OnboardingScreen]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute()
      : super(
          OnboardingRoute.name,
          path: '/splash_screen',
        );

  static const String name = 'OnboardingRoute';
}

/// generated route for
/// [SingIn]
class SingInRouter extends PageRouteInfo<SingInRouterArgs> {
  SingInRouter({
    Key? key,
    String? email,
  }) : super(
          SingInRouter.name,
          path: '/singin',
          args: SingInRouterArgs(
            key: key,
            email: email,
          ),
        );

  static const String name = 'SingInRouter';
}

class SingInRouterArgs {
  const SingInRouterArgs({
    this.key,
    this.email,
  });

  final Key? key;

  final String? email;

  @override
  String toString() {
    return 'SingInRouterArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [UserDataScreen]
class UserDataScreenRouter extends PageRouteInfo<void> {
  const UserDataScreenRouter()
      : super(
          UserDataScreenRouter.name,
          path: '/user_data',
        );

  static const String name = 'UserDataScreenRouter';
}

/// generated route for
/// [EmailVerification]
class EmailVerificationRoute extends PageRouteInfo<void> {
  const EmailVerificationRoute()
      : super(
          EmailVerificationRoute.name,
          path: '/email_verification',
        );

  static const String name = 'EmailVerificationRoute';
}

/// generated route for
/// [ResetPasswordScreen]
class ResetPasswordRoute extends PageRouteInfo<void> {
  const ResetPasswordRoute()
      : super(
          ResetPasswordRoute.name,
          path: '/reset_password',
        );

  static const String name = 'ResetPasswordRoute';
}

/// generated route for
/// [AllowCameraScreen]
class AllowCameraRoute extends PageRouteInfo<AllowCameraRouteArgs> {
  AllowCameraRoute({
    Key? key,
    required String permissionDescription,
    required void Function() then,
  }) : super(
          AllowCameraRoute.name,
          path: '/allow_camera',
          args: AllowCameraRouteArgs(
            key: key,
            permissionDescription: permissionDescription,
            then: then,
          ),
        );

  static const String name = 'AllowCameraRoute';
}

class AllowCameraRouteArgs {
  const AllowCameraRouteArgs({
    this.key,
    required this.permissionDescription,
    required this.then,
  });

  final Key? key;

  final String permissionDescription;

  final void Function() then;

  @override
  String toString() {
    return 'AllowCameraRouteArgs{key: $key, permissionDescription: $permissionDescription, then: $then}';
  }
}

/// generated route for
/// [AllowBiometric]
class AllowBiometricRoute extends PageRouteInfo<void> {
  const AllowBiometricRoute()
      : super(
          AllowBiometricRoute.name,
          path: '/allow_biometric',
        );

  static const String name = 'AllowBiometricRoute';
}

/// generated route for
/// [ApiSelectorScreen]
class ApiSelectorRouter extends PageRouteInfo<void> {
  const ApiSelectorRouter()
      : super(
          ApiSelectorRouter.name,
          path: '/api_selector',
        );

  static const String name = 'ApiSelectorRouter';
}

/// generated route for
/// [HomeScreen]
class HomeRouter extends PageRouteInfo<void> {
  const HomeRouter({List<PageRouteInfo>? children})
      : super(
          HomeRouter.name,
          path: '/home',
          initialChildren: children,
        );

  static const String name = 'HomeRouter';
}

/// generated route for
/// [VerificationScreen]
class VerificationRouter extends PageRouteInfo<void> {
  const VerificationRouter()
      : super(
          VerificationRouter.name,
          path: '/verification_screen',
        );

  static const String name = 'VerificationRouter';
}

/// generated route for
/// [AccountScreen]
class AccountRouter extends PageRouteInfo<void> {
  const AccountRouter()
      : super(
          AccountRouter.name,
          path: '/account',
        );

  static const String name = 'AccountRouter';
}

/// generated route for
/// [Crisp]
class CrispRouter extends PageRouteInfo<CrispRouterArgs> {
  CrispRouter({
    Key? key,
    required String welcomeText,
  }) : super(
          CrispRouter.name,
          path: '/crisp',
          args: CrispRouterArgs(
            key: key,
            welcomeText: welcomeText,
          ),
        );

  static const String name = 'CrispRouter';
}

class CrispRouterArgs {
  const CrispRouterArgs({
    this.key,
    required this.welcomeText,
  });

  final Key? key;

  final String welcomeText;

  @override
  String toString() {
    return 'CrispRouterArgs{key: $key, welcomeText: $welcomeText}';
  }
}

/// generated route for
/// [HelpCenterWebView]
class HelpCenterWebViewRouter
    extends PageRouteInfo<HelpCenterWebViewRouterArgs> {
  HelpCenterWebViewRouter({
    Key? key,
    required String link,
  }) : super(
          HelpCenterWebViewRouter.name,
          path: '/help_center_webview',
          args: HelpCenterWebViewRouterArgs(
            key: key,
            link: link,
          ),
        );

  static const String name = 'HelpCenterWebViewRouter';
}

class HelpCenterWebViewRouterArgs {
  const HelpCenterWebViewRouterArgs({
    this.key,
    required this.link,
  });

  final Key? key;

  final String link;

  @override
  String toString() {
    return 'HelpCenterWebViewRouterArgs{key: $key, link: $link}';
  }
}

/// generated route for
/// [InfoWebView]
class InfoWebViewRouter extends PageRouteInfo<InfoWebViewRouterArgs> {
  InfoWebViewRouter({
    Key? key,
    required String link,
    required String title,
  }) : super(
          InfoWebViewRouter.name,
          path: '/info_web_view',
          args: InfoWebViewRouterArgs(
            key: key,
            link: link,
            title: title,
          ),
        );

  static const String name = 'InfoWebViewRouter';
}

class InfoWebViewRouterArgs {
  const InfoWebViewRouterArgs({
    this.key,
    required this.link,
    required this.title,
  });

  final Key? key;

  final String link;

  final String title;

  @override
  String toString() {
    return 'InfoWebViewRouterArgs{key: $key, link: $link, title: $title}';
  }
}

/// generated route for
/// [ChooseDocuments]
class ChooseDocumentsRouter extends PageRouteInfo<ChooseDocumentsRouterArgs> {
  ChooseDocumentsRouter({
    Key? key,
    required String headerTitle,
  }) : super(
          ChooseDocumentsRouter.name,
          path: '/choose_documents',
          args: ChooseDocumentsRouterArgs(
            key: key,
            headerTitle: headerTitle,
          ),
        );

  static const String name = 'ChooseDocumentsRouter';
}

class ChooseDocumentsRouterArgs {
  const ChooseDocumentsRouterArgs({
    this.key,
    required this.headerTitle,
  });

  final Key? key;

  final String headerTitle;

  @override
  String toString() {
    return 'ChooseDocumentsRouterArgs{key: $key, headerTitle: $headerTitle}';
  }
}

/// generated route for
/// [UploadKycDocuments]
class UploadKycDocumentsRouter extends PageRouteInfo<void> {
  const UploadKycDocumentsRouter()
      : super(
          UploadKycDocumentsRouter.name,
          path: '/upload_kyc_documents',
        );

  static const String name = 'UploadKycDocumentsRouter';
}

/// generated route for
/// [UploadVerificationPhoto]
class UploadVerificationPhotoRouter
    extends PageRouteInfo<UploadVerificationPhotoRouterArgs> {
  UploadVerificationPhotoRouter({
    Key? key,
    bool isSelfie = false,
    required String cardId,
    required dynamic Function() onSuccess,
  }) : super(
          UploadVerificationPhotoRouter.name,
          path: '/upload_verification_photo',
          args: UploadVerificationPhotoRouterArgs(
            key: key,
            isSelfie: isSelfie,
            cardId: cardId,
            onSuccess: onSuccess,
          ),
        );

  static const String name = 'UploadVerificationPhotoRouter';
}

class UploadVerificationPhotoRouterArgs {
  const UploadVerificationPhotoRouterArgs({
    this.key,
    this.isSelfie = false,
    required this.cardId,
    required this.onSuccess,
  });

  final Key? key;

  final bool isSelfie;

  final String cardId;

  final dynamic Function() onSuccess;

  @override
  String toString() {
    return 'UploadVerificationPhotoRouterArgs{key: $key, isSelfie: $isSelfie, cardId: $cardId, onSuccess: $onSuccess}';
  }
}

/// generated route for
/// [KycSelfie]
class KycSelfieRouter extends PageRouteInfo<void> {
  const KycSelfieRouter()
      : super(
          KycSelfieRouter.name,
          path: '/kyc_selfie',
        );

  static const String name = 'KycSelfieRouter';
}

/// generated route for
/// [KycVerifyYourProfile]
class KycVerifyYourProfileRouter
    extends PageRouteInfo<KycVerifyYourProfileRouterArgs> {
  KycVerifyYourProfileRouter({
    Key? key,
    required List<RequiredVerified> requiredVerifications,
  }) : super(
          KycVerifyYourProfileRouter.name,
          path: '/kyc_verify_your_profile',
          args: KycVerifyYourProfileRouterArgs(
            key: key,
            requiredVerifications: requiredVerifications,
          ),
        );

  static const String name = 'KycVerifyYourProfileRouter';
}

class KycVerifyYourProfileRouterArgs {
  const KycVerifyYourProfileRouterArgs({
    this.key,
    required this.requiredVerifications,
  });

  final Key? key;

  final List<RequiredVerified> requiredVerifications;

  @override
  String toString() {
    return 'KycVerifyYourProfileRouterArgs{key: $key, requiredVerifications: $requiredVerifications}';
  }
}

/// generated route for
/// [CurrencyBuy]
class CurrencyBuyRouter extends PageRouteInfo<CurrencyBuyRouterArgs> {
  CurrencyBuyRouter({
    Key? key,
    RecurringBuysType? recurringBuysType,
    CircleCard? circleCard,
    CircleCard? unlimintCard,
    CircleCard? bankCard,
    String? newBankCardId,
    String? newBankCardNumber,
    required CurrencyModel currency,
    required bool fromCard,
    required PaymentMethodType paymentMethod,
  }) : super(
          CurrencyBuyRouter.name,
          path: '/currency_buy',
          args: CurrencyBuyRouterArgs(
            key: key,
            recurringBuysType: recurringBuysType,
            circleCard: circleCard,
            unlimintCard: unlimintCard,
            bankCard: bankCard,
            newBankCardId: newBankCardId,
            newBankCardNumber: newBankCardNumber,
            currency: currency,
            fromCard: fromCard,
            paymentMethod: paymentMethod,
          ),
        );

  static const String name = 'CurrencyBuyRouter';
}

class CurrencyBuyRouterArgs {
  const CurrencyBuyRouterArgs({
    this.key,
    this.recurringBuysType,
    this.circleCard,
    this.unlimintCard,
    this.bankCard,
    this.newBankCardId,
    this.newBankCardNumber,
    required this.currency,
    required this.fromCard,
    required this.paymentMethod,
  });

  final Key? key;

  final RecurringBuysType? recurringBuysType;

  final CircleCard? circleCard;

  final CircleCard? unlimintCard;

  final CircleCard? bankCard;

  final String? newBankCardId;

  final String? newBankCardNumber;

  final CurrencyModel currency;

  final bool fromCard;

  final PaymentMethodType paymentMethod;

  @override
  String toString() {
    return 'CurrencyBuyRouterArgs{key: $key, recurringBuysType: $recurringBuysType, circleCard: $circleCard, unlimintCard: $unlimintCard, bankCard: $bankCard, newBankCardId: $newBankCardId, newBankCardNumber: $newBankCardNumber, currency: $currency, fromCard: $fromCard, paymentMethod: $paymentMethod}';
  }
}

/// generated route for
/// [ChooseAssetScreen]
class ChooseAssetRouter extends PageRouteInfo<void> {
  const ChooseAssetRouter()
      : super(
          ChooseAssetRouter.name,
          path: '/choose_asset',
        );

  static const String name = 'ChooseAssetRouter';
}

/// generated route for
/// [PaymentMethodScreen]
class PaymentMethodRouter extends PageRouteInfo<PaymentMethodRouterArgs> {
  PaymentMethodRouter({
    Key? key,
    required CurrencyModel currency,
  }) : super(
          PaymentMethodRouter.name,
          path: '/payment_method',
          args: PaymentMethodRouterArgs(
            key: key,
            currency: currency,
          ),
        );

  static const String name = 'PaymentMethodRouter';
}

class PaymentMethodRouterArgs {
  const PaymentMethodRouterArgs({
    this.key,
    required this.currency,
  });

  final Key? key;

  final CurrencyModel currency;

  @override
  String toString() {
    return 'PaymentMethodRouterArgs{key: $key, currency: $currency}';
  }
}

/// generated route for
/// [CryptoDeposit]
class CryptoDepositRouter extends PageRouteInfo<CryptoDepositRouterArgs> {
  CryptoDepositRouter({
    Key? key,
    required String header,
    required CurrencyModel currency,
  }) : super(
          CryptoDepositRouter.name,
          path: '/crypto_deposit',
          args: CryptoDepositRouterArgs(
            key: key,
            header: header,
            currency: currency,
          ),
        );

  static const String name = 'CryptoDepositRouter';
}

class CryptoDepositRouterArgs {
  const CryptoDepositRouterArgs({
    this.key,
    required this.header,
    required this.currency,
  });

  final Key? key;

  final String header;

  final CurrencyModel currency;

  @override
  String toString() {
    return 'CryptoDepositRouterArgs{key: $key, header: $header, currency: $currency}';
  }
}

/// generated route for
/// [TransactionHistory]
class TransactionHistoryRouter
    extends PageRouteInfo<TransactionHistoryRouterArgs> {
  TransactionHistoryRouter({
    Key? key,
    String? assetName,
    String? assetSymbol,
    int initialIndex = 0,
    String? jwOperationId,
  }) : super(
          TransactionHistoryRouter.name,
          path: '/transaction_history',
          args: TransactionHistoryRouterArgs(
            key: key,
            assetName: assetName,
            assetSymbol: assetSymbol,
            initialIndex: initialIndex,
            jwOperationId: jwOperationId,
          ),
        );

  static const String name = 'TransactionHistoryRouter';
}

class TransactionHistoryRouterArgs {
  const TransactionHistoryRouterArgs({
    this.key,
    this.assetName,
    this.assetSymbol,
    this.initialIndex = 0,
    this.jwOperationId,
  });

  final Key? key;

  final String? assetName;

  final String? assetSymbol;

  final int initialIndex;

  final String? jwOperationId;

  @override
  String toString() {
    return 'TransactionHistoryRouterArgs{key: $key, assetName: $assetName, assetSymbol: $assetSymbol, initialIndex: $initialIndex, jwOperationId: $jwOperationId}';
  }
}

/// generated route for
/// [RecurringSuccessScreen]
class RecurringSuccessScreenRouter
    extends PageRouteInfo<RecurringSuccessScreenRouterArgs> {
  RecurringSuccessScreenRouter({
    Key? key,
    required PreviewBuyWithAssetInput input,
  }) : super(
          RecurringSuccessScreenRouter.name,
          path: '/recurring_success',
          args: RecurringSuccessScreenRouterArgs(
            key: key,
            input: input,
          ),
        );

  static const String name = 'RecurringSuccessScreenRouter';
}

class RecurringSuccessScreenRouterArgs {
  const RecurringSuccessScreenRouterArgs({
    this.key,
    required this.input,
  });

  final Key? key;

  final PreviewBuyWithAssetInput input;

  @override
  String toString() {
    return 'RecurringSuccessScreenRouterArgs{key: $key, input: $input}';
  }
}

/// generated route for
/// [HistoryRecurringBuys]
class HistoryRecurringBuysRouter
    extends PageRouteInfo<HistoryRecurringBuysRouterArgs> {
  HistoryRecurringBuysRouter({
    Key? key,
    Source? from,
  }) : super(
          HistoryRecurringBuysRouter.name,
          path: '/history_recurring_buys',
          args: HistoryRecurringBuysRouterArgs(
            key: key,
            from: from,
          ),
        );

  static const String name = 'HistoryRecurringBuysRouter';
}

class HistoryRecurringBuysRouterArgs {
  const HistoryRecurringBuysRouterArgs({
    this.key,
    this.from,
  });

  final Key? key;

  final Source? from;

  @override
  String toString() {
    return 'HistoryRecurringBuysRouterArgs{key: $key, from: $from}';
  }
}

/// generated route for
/// [AddCircleCard]
class AddCircleCardRouter extends PageRouteInfo<AddCircleCardRouterArgs> {
  AddCircleCardRouter({
    Key? key,
    required dynamic Function(CircleCard) onCardAdded,
  }) : super(
          AddCircleCardRouter.name,
          path: '/add_circle_card',
          args: AddCircleCardRouterArgs(
            key: key,
            onCardAdded: onCardAdded,
          ),
        );

  static const String name = 'AddCircleCardRouter';
}

class AddCircleCardRouterArgs {
  const AddCircleCardRouterArgs({
    this.key,
    required this.onCardAdded,
  });

  final Key? key;

  final dynamic Function(CircleCard) onCardAdded;

  @override
  String toString() {
    return 'AddCircleCardRouterArgs{key: $key, onCardAdded: $onCardAdded}';
  }
}

/// generated route for
/// [AddBankCard]
class AddUnlimintCardRouter extends PageRouteInfo<AddUnlimintCardRouterArgs> {
  AddUnlimintCardRouter({
    Key? key,
    required dynamic Function() onCardAdded,
    required String amount,
    CurrencyModel? currency,
    bool isPreview = false,
  }) : super(
          AddUnlimintCardRouter.name,
          path: '/add_bank_card',
          args: AddUnlimintCardRouterArgs(
            key: key,
            onCardAdded: onCardAdded,
            amount: amount,
            currency: currency,
            isPreview: isPreview,
          ),
        );

  static const String name = 'AddUnlimintCardRouter';
}

class AddUnlimintCardRouterArgs {
  const AddUnlimintCardRouterArgs({
    this.key,
    required this.onCardAdded,
    required this.amount,
    this.currency,
    this.isPreview = false,
  });

  final Key? key;

  final dynamic Function() onCardAdded;

  final String amount;

  final CurrencyModel? currency;

  final bool isPreview;

  @override
  String toString() {
    return 'AddUnlimintCardRouterArgs{key: $key, onCardAdded: $onCardAdded, amount: $amount, currency: $currency, isPreview: $isPreview}';
  }
}

/// generated route for
/// [CircleBillingAddress]
class CircleBillingAddressRouter
    extends PageRouteInfo<CircleBillingAddressRouterArgs> {
  CircleBillingAddressRouter({
    Key? key,
    required dynamic Function(CircleCard) onCardAdded,
    required String expiryDate,
    required String cardholderName,
    required String cardNumber,
    required String cvv,
  }) : super(
          CircleBillingAddressRouter.name,
          path: '/circle_billing_address',
          args: CircleBillingAddressRouterArgs(
            key: key,
            onCardAdded: onCardAdded,
            expiryDate: expiryDate,
            cardholderName: cardholderName,
            cardNumber: cardNumber,
            cvv: cvv,
          ),
        );

  static const String name = 'CircleBillingAddressRouter';
}

class CircleBillingAddressRouterArgs {
  const CircleBillingAddressRouterArgs({
    this.key,
    required this.onCardAdded,
    required this.expiryDate,
    required this.cardholderName,
    required this.cardNumber,
    required this.cvv,
  });

  final Key? key;

  final dynamic Function(CircleCard) onCardAdded;

  final String expiryDate;

  final String cardholderName;

  final String cardNumber;

  final String cvv;

  @override
  String toString() {
    return 'CircleBillingAddressRouterArgs{key: $key, onCardAdded: $onCardAdded, expiryDate: $expiryDate, cardholderName: $cardholderName, cardNumber: $cardNumber, cvv: $cvv}';
  }
}

/// generated route for
/// [IbanBillingAddress]
class IbanAddressRouter extends PageRouteInfo<void> {
  const IbanAddressRouter()
      : super(
          IbanAddressRouter.name,
          path: '/iban_address',
        );

  static const String name = 'IbanAddressRouter';
}

/// generated route for
/// [PreviewConvert]
class PreviewConvertRouter extends PageRouteInfo<PreviewConvertRouterArgs> {
  PreviewConvertRouter({
    Key? key,
    required PreviewConvertInput input,
  }) : super(
          PreviewConvertRouter.name,
          path: '/preview_convert',
          args: PreviewConvertRouterArgs(
            key: key,
            input: input,
          ),
        );

  static const String name = 'PreviewConvertRouter';
}

class PreviewConvertRouterArgs {
  const PreviewConvertRouterArgs({
    this.key,
    required this.input,
  });

  final Key? key;

  final PreviewConvertInput input;

  @override
  String toString() {
    return 'PreviewConvertRouterArgs{key: $key, input: $input}';
  }
}

/// generated route for
/// [Convert]
class ConvertRouter extends PageRouteInfo<ConvertRouterArgs> {
  ConvertRouter({
    Key? key,
    CurrencyModel? fromCurrency,
  }) : super(
          ConvertRouter.name,
          path: '/convert',
          args: ConvertRouterArgs(
            key: key,
            fromCurrency: fromCurrency,
          ),
        );

  static const String name = 'ConvertRouter';
}

class ConvertRouterArgs {
  const ConvertRouterArgs({
    this.key,
    this.fromCurrency,
  });

  final Key? key;

  final CurrencyModel? fromCurrency;

  @override
  String toString() {
    return 'ConvertRouterArgs{key: $key, fromCurrency: $fromCurrency}';
  }
}

/// generated route for
/// [SuccessScreen]
class SuccessScreenRouter extends PageRouteInfo<SuccessScreenRouterArgs> {
  SuccessScreenRouter({
    Key? key,
    dynamic Function(BuildContext)? onSuccess,
    dynamic Function()? onActionButton,
    String? primaryText,
    String? secondaryText,
    Widget? specialTextWidget,
    bool showActionButton = false,
    bool showProgressBar = false,
    bool showShareButton = false,
    String? buttonText,
    int time = 3,
  }) : super(
          SuccessScreenRouter.name,
          path: '/success_screen',
          args: SuccessScreenRouterArgs(
            key: key,
            onSuccess: onSuccess,
            onActionButton: onActionButton,
            primaryText: primaryText,
            secondaryText: secondaryText,
            specialTextWidget: specialTextWidget,
            showActionButton: showActionButton,
            showProgressBar: showProgressBar,
            showShareButton: showShareButton,
            buttonText: buttonText,
            time: time,
          ),
        );

  static const String name = 'SuccessScreenRouter';
}

class SuccessScreenRouterArgs {
  const SuccessScreenRouterArgs({
    this.key,
    this.onSuccess,
    this.onActionButton,
    this.primaryText,
    this.secondaryText,
    this.specialTextWidget,
    this.showActionButton = false,
    this.showProgressBar = false,
    this.showShareButton = false,
    this.buttonText,
    this.time = 3,
  });

  final Key? key;

  final dynamic Function(BuildContext)? onSuccess;

  final dynamic Function()? onActionButton;

  final String? primaryText;

  final String? secondaryText;

  final Widget? specialTextWidget;

  final bool showActionButton;

  final bool showProgressBar;

  final bool showShareButton;

  final String? buttonText;

  final int time;

  @override
  String toString() {
    return 'SuccessScreenRouterArgs{key: $key, onSuccess: $onSuccess, onActionButton: $onActionButton, primaryText: $primaryText, secondaryText: $secondaryText, specialTextWidget: $specialTextWidget, showActionButton: $showActionButton, showProgressBar: $showProgressBar, showShareButton: $showShareButton, buttonText: $buttonText, time: $time}';
  }
}

/// generated route for
/// [WaitingScreen]
class WaitingScreenRouter extends PageRouteInfo<WaitingScreenRouterArgs> {
  WaitingScreenRouter({
    Key? key,
    dynamic Function(BuildContext)? onSuccess,
    String? primaryText,
    String? secondaryText,
    Widget? specialTextWidget,
    bool wasAction = false,
    required dynamic Function() onSkip,
  }) : super(
          WaitingScreenRouter.name,
          path: '/waiting_screen',
          args: WaitingScreenRouterArgs(
            key: key,
            onSuccess: onSuccess,
            primaryText: primaryText,
            secondaryText: secondaryText,
            specialTextWidget: specialTextWidget,
            wasAction: wasAction,
            onSkip: onSkip,
          ),
        );

  static const String name = 'WaitingScreenRouter';
}

class WaitingScreenRouterArgs {
  const WaitingScreenRouterArgs({
    this.key,
    this.onSuccess,
    this.primaryText,
    this.secondaryText,
    this.specialTextWidget,
    this.wasAction = false,
    required this.onSkip,
  });

  final Key? key;

  final dynamic Function(BuildContext)? onSuccess;

  final String? primaryText;

  final String? secondaryText;

  final Widget? specialTextWidget;

  final bool wasAction;

  final dynamic Function() onSkip;

  @override
  String toString() {
    return 'WaitingScreenRouterArgs{key: $key, onSuccess: $onSuccess, primaryText: $primaryText, secondaryText: $secondaryText, specialTextWidget: $specialTextWidget, wasAction: $wasAction, onSkip: $onSkip}';
  }
}

/// generated route for
/// [FailureScreen]
class FailureScreenRouter extends PageRouteInfo<FailureScreenRouterArgs> {
  FailureScreenRouter({
    Key? key,
    String? secondaryText,
    String? secondaryButtonName,
    dynamic Function()? onSecondaryButtonTap,
    required String primaryText,
    required String primaryButtonName,
    required dynamic Function() onPrimaryButtonTap,
  }) : super(
          FailureScreenRouter.name,
          path: '/failure_screen',
          args: FailureScreenRouterArgs(
            key: key,
            secondaryText: secondaryText,
            secondaryButtonName: secondaryButtonName,
            onSecondaryButtonTap: onSecondaryButtonTap,
            primaryText: primaryText,
            primaryButtonName: primaryButtonName,
            onPrimaryButtonTap: onPrimaryButtonTap,
          ),
        );

  static const String name = 'FailureScreenRouter';
}

class FailureScreenRouterArgs {
  const FailureScreenRouterArgs({
    this.key,
    this.secondaryText,
    this.secondaryButtonName,
    this.onSecondaryButtonTap,
    required this.primaryText,
    required this.primaryButtonName,
    required this.onPrimaryButtonTap,
  });

  final Key? key;

  final String? secondaryText;

  final String? secondaryButtonName;

  final dynamic Function()? onSecondaryButtonTap;

  final String primaryText;

  final String primaryButtonName;

  final dynamic Function() onPrimaryButtonTap;

  @override
  String toString() {
    return 'FailureScreenRouterArgs{key: $key, secondaryText: $secondaryText, secondaryButtonName: $secondaryButtonName, onSecondaryButtonTap: $onSecondaryButtonTap, primaryText: $primaryText, primaryButtonName: $primaryButtonName, onPrimaryButtonTap: $onPrimaryButtonTap}';
  }
}

/// generated route for
/// [VerifyingScreen]
class VerifyingScreenRouter extends PageRouteInfo<VerifyingScreenRouterArgs> {
  VerifyingScreenRouter({
    Key? key,
    required String cardId,
    required dynamic Function() onSuccess,
  }) : super(
          VerifyingScreenRouter.name,
          path: '/verifying_screen',
          args: VerifyingScreenRouterArgs(
            key: key,
            cardId: cardId,
            onSuccess: onSuccess,
          ),
        );

  static const String name = 'VerifyingScreenRouter';
}

class VerifyingScreenRouterArgs {
  const VerifyingScreenRouterArgs({
    this.key,
    required this.cardId,
    required this.onSuccess,
  });

  final Key? key;

  final String cardId;

  final dynamic Function() onSuccess;

  @override
  String toString() {
    return 'VerifyingScreenRouterArgs{key: $key, cardId: $cardId, onSuccess: $onSuccess}';
  }
}

/// generated route for
/// [SuccessVerifyingScreen]
class SuccessVerifyingScreenRouter
    extends PageRouteInfo<SuccessVerifyingScreenRouterArgs> {
  SuccessVerifyingScreenRouter({
    Key? key,
    required dynamic Function() onSuccess,
  }) : super(
          SuccessVerifyingScreenRouter.name,
          path: '/verifying_success_screen',
          args: SuccessVerifyingScreenRouterArgs(
            key: key,
            onSuccess: onSuccess,
          ),
        );

  static const String name = 'SuccessVerifyingScreenRouter';
}

class SuccessVerifyingScreenRouterArgs {
  const SuccessVerifyingScreenRouterArgs({
    this.key,
    required this.onSuccess,
  });

  final Key? key;

  final dynamic Function() onSuccess;

  @override
  String toString() {
    return 'SuccessVerifyingScreenRouterArgs{key: $key, onSuccess: $onSuccess}';
  }
}

/// generated route for
/// [SmsAuthenticator]
class SmsAuthenticatorRouter extends PageRouteInfo<void> {
  const SmsAuthenticatorRouter()
      : super(
          SmsAuthenticatorRouter.name,
          path: '/sms_authenticator',
        );

  static const String name = 'SmsAuthenticatorRouter';
}

/// generated route for
/// [SetPhoneNumber]
class SetPhoneNumberRouter extends PageRouteInfo<SetPhoneNumberRouterArgs> {
  SetPhoneNumberRouter({
    Key? key,
    dynamic Function()? then,
    bool isChangePhone = false,
    bool fromRegister = false,
    required String successText,
  }) : super(
          SetPhoneNumberRouter.name,
          path: '/set_phone_number',
          args: SetPhoneNumberRouterArgs(
            key: key,
            then: then,
            isChangePhone: isChangePhone,
            fromRegister: fromRegister,
            successText: successText,
          ),
        );

  static const String name = 'SetPhoneNumberRouter';
}

class SetPhoneNumberRouterArgs {
  const SetPhoneNumberRouterArgs({
    this.key,
    this.then,
    this.isChangePhone = false,
    this.fromRegister = false,
    required this.successText,
  });

  final Key? key;

  final dynamic Function()? then;

  final bool isChangePhone;

  final bool fromRegister;

  final String successText;

  @override
  String toString() {
    return 'SetPhoneNumberRouterArgs{key: $key, then: $then, isChangePhone: $isChangePhone, fromRegister: $fromRegister, successText: $successText}';
  }
}

/// generated route for
/// [SetNewPassword]
class SetNewPasswordRouter extends PageRouteInfo<void> {
  const SetNewPasswordRouter()
      : super(
          SetNewPasswordRouter.name,
          path: '/set_new_password',
        );

  static const String name = 'SetNewPasswordRouter';
}

/// generated route for
/// [Rewards]
class RewardsRouter extends PageRouteInfo<RewardsRouterArgs> {
  RewardsRouter({
    Key? key,
    required List<String> actualRewards,
  }) : super(
          RewardsRouter.name,
          path: '/rewards',
          args: RewardsRouterArgs(
            key: key,
            actualRewards: actualRewards,
          ),
        );

  static const String name = 'RewardsRouter';
}

class RewardsRouterArgs {
  const RewardsRouterArgs({
    this.key,
    required this.actualRewards,
  });

  final Key? key;

  final List<String> actualRewards;

  @override
  String toString() {
    return 'RewardsRouterArgs{key: $key, actualRewards: $actualRewards}';
  }
}

/// generated route for
/// [PhoneVerification]
class PhoneVerificationRouter
    extends PageRouteInfo<PhoneVerificationRouterArgs> {
  PhoneVerificationRouter({
    Key? key,
    required PhoneVerificationArgs args,
  }) : super(
          PhoneVerificationRouter.name,
          path: '/phone_verification',
          args: PhoneVerificationRouterArgs(
            key: key,
            args: args,
          ),
        );

  static const String name = 'PhoneVerificationRouter';
}

class PhoneVerificationRouterArgs {
  const PhoneVerificationRouterArgs({
    this.key,
    required this.args,
  });

  final Key? key;

  final PhoneVerificationArgs args;

  @override
  String toString() {
    return 'PhoneVerificationRouterArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [PaymentMethods]
class PaymentMethodsRouter extends PageRouteInfo<void> {
  const PaymentMethodsRouter()
      : super(
          PaymentMethodsRouter.name,
          path: '/payments_methods',
        );

  static const String name = 'PaymentMethodsRouter';
}

/// generated route for
/// [PinScreen]
class PinScreenRoute extends PageRouteInfo<PinScreenRouteArgs> {
  PinScreenRoute({
    Key? key,
    bool displayHeader = true,
    bool cannotLeave = false,
    bool isChangePhone = false,
    bool isChangePin = false,
    bool fromRegister = true,
    bool isForgotPassword = false,
    dynamic Function(String)? onChangePhone,
    required PinFlowUnion union,
  }) : super(
          PinScreenRoute.name,
          path: '/pin_screen',
          args: PinScreenRouteArgs(
            key: key,
            displayHeader: displayHeader,
            cannotLeave: cannotLeave,
            isChangePhone: isChangePhone,
            isChangePin: isChangePin,
            fromRegister: fromRegister,
            isForgotPassword: isForgotPassword,
            onChangePhone: onChangePhone,
            union: union,
          ),
        );

  static const String name = 'PinScreenRoute';
}

class PinScreenRouteArgs {
  const PinScreenRouteArgs({
    this.key,
    this.displayHeader = true,
    this.cannotLeave = false,
    this.isChangePhone = false,
    this.isChangePin = false,
    this.fromRegister = true,
    this.isForgotPassword = false,
    this.onChangePhone,
    required this.union,
  });

  final Key? key;

  final bool displayHeader;

  final bool cannotLeave;

  final bool isChangePhone;

  final bool isChangePin;

  final bool fromRegister;

  final bool isForgotPassword;

  final dynamic Function(String)? onChangePhone;

  final PinFlowUnion union;

  @override
  String toString() {
    return 'PinScreenRouteArgs{key: $key, displayHeader: $displayHeader, cannotLeave: $cannotLeave, isChangePhone: $isChangePhone, isChangePin: $isChangePin, fromRegister: $fromRegister, isForgotPassword: $isForgotPassword, onChangePhone: $onChangePhone, union: $union}';
  }
}

/// generated route for
/// [TwoFaPhone]
class TwoFaPhoneRouter extends PageRouteInfo<TwoFaPhoneRouterArgs> {
  TwoFaPhoneRouter({
    Key? key,
    required TwoFaPhoneTriggerUnion trigger,
  }) : super(
          TwoFaPhoneRouter.name,
          path: '/two_fa_phone',
          args: TwoFaPhoneRouterArgs(
            key: key,
            trigger: trigger,
          ),
        );

  static const String name = 'TwoFaPhoneRouter';
}

class TwoFaPhoneRouterArgs {
  const TwoFaPhoneRouterArgs({
    this.key,
    required this.trigger,
  });

  final Key? key;

  final TwoFaPhoneTriggerUnion trigger;

  @override
  String toString() {
    return 'TwoFaPhoneRouterArgs{key: $key, trigger: $trigger}';
  }
}

/// generated route for
/// [EmailConfirmationScreen]
class EmailConfirmationRouter extends PageRouteInfo<void> {
  const EmailConfirmationRouter()
      : super(
          EmailConfirmationRouter.name,
          path: '/email_confirmation',
        );

  static const String name = 'EmailConfirmationRouter';
}

/// generated route for
/// [Biometric]
class BiometricRouter extends PageRouteInfo<BiometricRouterArgs> {
  BiometricRouter({
    Key? key,
    bool isAccSettings = false,
  }) : super(
          BiometricRouter.name,
          path: '/biometric',
          args: BiometricRouterArgs(
            key: key,
            isAccSettings: isAccSettings,
          ),
        );

  static const String name = 'BiometricRouter';
}

class BiometricRouterArgs {
  const BiometricRouterArgs({
    this.key,
    this.isAccSettings = false,
  });

  final Key? key;

  final bool isAccSettings;

  @override
  String toString() {
    return 'BiometricRouterArgs{key: $key, isAccSettings: $isAccSettings}';
  }
}

/// generated route for
/// [ChangePassword]
class ChangePasswordRouter extends PageRouteInfo<void> {
  const ChangePasswordRouter()
      : super(
          ChangePasswordRouter.name,
          path: '/change_password',
        );

  static const String name = 'ChangePasswordRouter';
}

/// generated route for
/// [DeleteProfile]
class DeleteProfileRouter extends PageRouteInfo<void> {
  const DeleteProfileRouter()
      : super(
          DeleteProfileRouter.name,
          path: '/delete_profile',
        );

  static const String name = 'DeleteProfileRouter';
}

/// generated route for
/// [ProfileDetails]
class ProfileDetailsRouter extends PageRouteInfo<void> {
  const ProfileDetailsRouter()
      : super(
          ProfileDetailsRouter.name,
          path: '/profile_details',
        );

  static const String name = 'ProfileDetailsRouter';
}

/// generated route for
/// [AccountSecurity]
class AccountSecurityRouter extends PageRouteInfo<void> {
  const AccountSecurityRouter()
      : super(
          AccountSecurityRouter.name,
          path: '/account_sercurity',
        );

  static const String name = 'AccountSecurityRouter';
}

/// generated route for
/// [AboutUs]
class AboutUsRouter extends PageRouteInfo<void> {
  const AboutUsRouter()
      : super(
          AboutUsRouter.name,
          path: '/about_us',
        );

  static const String name = 'AboutUsRouter';
}

/// generated route for
/// [DebugInfo]
class DebugInfoRouter extends PageRouteInfo<void> {
  const DebugInfoRouter()
      : super(
          DebugInfoRouter.name,
          path: '/debug_info',
        );

  static const String name = 'DebugInfoRouter';
}

/// generated route for
/// [ShowRecurringInfoAction]
class ShowRecurringInfoActionRouter
    extends PageRouteInfo<ShowRecurringInfoActionRouterArgs> {
  ShowRecurringInfoActionRouter({
    Key? key,
    required RecurringBuysModel recurringItem,
    required String assetName,
  }) : super(
          ShowRecurringInfoActionRouter.name,
          path: '/show_recurring_info_action',
          args: ShowRecurringInfoActionRouterArgs(
            key: key,
            recurringItem: recurringItem,
            assetName: assetName,
          ),
        );

  static const String name = 'ShowRecurringInfoActionRouter';
}

class ShowRecurringInfoActionRouterArgs {
  const ShowRecurringInfoActionRouterArgs({
    this.key,
    required this.recurringItem,
    required this.assetName,
  });

  final Key? key;

  final RecurringBuysModel recurringItem;

  final String assetName;

  @override
  String toString() {
    return 'ShowRecurringInfoActionRouterArgs{key: $key, recurringItem: $recurringItem, assetName: $assetName}';
  }
}

/// generated route for
/// [SendByPhoneInput]
class SendByPhoneInputRouter extends PageRouteInfo<SendByPhoneInputRouterArgs> {
  SendByPhoneInputRouter({
    Key? key,
    required CurrencyModel currency,
  }) : super(
          SendByPhoneInputRouter.name,
          path: '/send_by_phone_input',
          args: SendByPhoneInputRouterArgs(
            key: key,
            currency: currency,
          ),
        );

  static const String name = 'SendByPhoneInputRouter';
}

class SendByPhoneInputRouterArgs {
  const SendByPhoneInputRouterArgs({
    this.key,
    required this.currency,
  });

  final Key? key;

  final CurrencyModel currency;

  @override
  String toString() {
    return 'SendByPhoneInputRouterArgs{key: $key, currency: $currency}';
  }
}

/// generated route for
/// [CurrencyWithdraw]
class CurrencyWithdrawRouter extends PageRouteInfo<CurrencyWithdrawRouterArgs> {
  CurrencyWithdrawRouter({
    Key? key,
    required WithdrawalModel withdrawal,
  }) : super(
          CurrencyWithdrawRouter.name,
          path: '/currency_withdraw',
          args: CurrencyWithdrawRouterArgs(
            key: key,
            withdrawal: withdrawal,
          ),
        );

  static const String name = 'CurrencyWithdrawRouter';
}

class CurrencyWithdrawRouterArgs {
  const CurrencyWithdrawRouterArgs({
    this.key,
    required this.withdrawal,
  });

  final Key? key;

  final WithdrawalModel withdrawal;

  @override
  String toString() {
    return 'CurrencyWithdrawRouterArgs{key: $key, withdrawal: $withdrawal}';
  }
}

/// generated route for
/// [CurrencySell]
class CurrencySellRouter extends PageRouteInfo<CurrencySellRouterArgs> {
  CurrencySellRouter({
    Key? key,
    required CurrencyModel currency,
  }) : super(
          CurrencySellRouter.name,
          path: '/currency_sell',
          args: CurrencySellRouterArgs(
            key: key,
            currency: currency,
          ),
        );

  static const String name = 'CurrencySellRouter';
}

class CurrencySellRouterArgs {
  const CurrencySellRouterArgs({
    this.key,
    required this.currency,
  });

  final Key? key;

  final CurrencyModel currency;

  @override
  String toString() {
    return 'CurrencySellRouterArgs{key: $key, currency: $currency}';
  }
}

/// generated route for
/// [EmptyWallet]
class EmptyWalletRouter extends PageRouteInfo<EmptyWalletRouterArgs> {
  EmptyWalletRouter({
    Key? key,
    required CurrencyModel currency,
  }) : super(
          EmptyWalletRouter.name,
          path: '/emptry_wallet',
          args: EmptyWalletRouterArgs(
            key: key,
            currency: currency,
          ),
        );

  static const String name = 'EmptyWalletRouter';
}

class EmptyWalletRouterArgs {
  const EmptyWalletRouterArgs({
    this.key,
    required this.currency,
  });

  final Key? key;

  final CurrencyModel currency;

  @override
  String toString() {
    return 'EmptyWalletRouterArgs{key: $key, currency: $currency}';
  }
}

/// generated route for
/// [Wallet]
class WalletRouter extends PageRouteInfo<WalletRouterArgs> {
  WalletRouter({
    Key? key,
    required CurrencyModel currency,
  }) : super(
          WalletRouter.name,
          path: '/wallet',
          args: WalletRouterArgs(
            key: key,
            currency: currency,
          ),
        );

  static const String name = 'WalletRouter';
}

class WalletRouterArgs {
  const WalletRouterArgs({
    this.key,
    required this.currency,
  });

  final Key? key;

  final CurrencyModel currency;

  @override
  String toString() {
    return 'WalletRouterArgs{key: $key, currency: $currency}';
  }
}

/// generated route for
/// [ReturnToWallet]
class ReturnToWalletRouter extends PageRouteInfo<ReturnToWalletRouterArgs> {
  ReturnToWalletRouter({
    Key? key,
    required CurrencyModel currency,
    required EarnOfferModel earnOffer,
  }) : super(
          ReturnToWalletRouter.name,
          path: '/return_to_wallet',
          args: ReturnToWalletRouterArgs(
            key: key,
            currency: currency,
            earnOffer: earnOffer,
          ),
        );

  static const String name = 'ReturnToWalletRouter';
}

class ReturnToWalletRouterArgs {
  const ReturnToWalletRouterArgs({
    this.key,
    required this.currency,
    required this.earnOffer,
  });

  final Key? key;

  final CurrencyModel currency;

  final EarnOfferModel earnOffer;

  @override
  String toString() {
    return 'ReturnToWalletRouterArgs{key: $key, currency: $currency, earnOffer: $earnOffer}';
  }
}

/// generated route for
/// [PreviewReturnToWallet]
class PreviewReturnToWalletRouter
    extends PageRouteInfo<PreviewReturnToWalletRouterArgs> {
  PreviewReturnToWalletRouter({
    Key? key,
    required PreviewReturnToWalletInput input,
  }) : super(
          PreviewReturnToWalletRouter.name,
          path: '/preview_return_to_wallet',
          args: PreviewReturnToWalletRouterArgs(
            key: key,
            input: input,
          ),
        );

  static const String name = 'PreviewReturnToWalletRouter';
}

class PreviewReturnToWalletRouterArgs {
  const PreviewReturnToWalletRouterArgs({
    this.key,
    required this.input,
  });

  final Key? key;

  final PreviewReturnToWalletInput input;

  @override
  String toString() {
    return 'PreviewReturnToWalletRouterArgs{key: $key, input: $input}';
  }
}

/// generated route for
/// [SuccessKycScreen]
class SuccessKycScreenRoute extends PageRouteInfo<SuccessKycScreenRouteArgs> {
  SuccessKycScreenRoute({
    Key? key,
    String? primaryText,
    String? secondaryText,
    Widget? specialTextWidget,
  }) : super(
          SuccessKycScreenRoute.name,
          path: '/success_kyc',
          args: SuccessKycScreenRouteArgs(
            key: key,
            primaryText: primaryText,
            secondaryText: secondaryText,
            specialTextWidget: specialTextWidget,
          ),
        );

  static const String name = 'SuccessKycScreenRoute';
}

class SuccessKycScreenRouteArgs {
  const SuccessKycScreenRouteArgs({
    this.key,
    this.primaryText,
    this.secondaryText,
    this.specialTextWidget,
  });

  final Key? key;

  final String? primaryText;

  final String? secondaryText;

  final Widget? specialTextWidget;

  @override
  String toString() {
    return 'SuccessKycScreenRouteArgs{key: $key, primaryText: $primaryText, secondaryText: $secondaryText, specialTextWidget: $specialTextWidget}';
  }
}

/// generated route for
/// [HighYieldBuy]
class HighYieldBuyRouter extends PageRouteInfo<HighYieldBuyRouterArgs> {
  HighYieldBuyRouter({
    Key? key,
    bool topUp = false,
    required CurrencyModel currency,
    required EarnOfferModel earnOffer,
  }) : super(
          HighYieldBuyRouter.name,
          path: '/high_yield_buy',
          args: HighYieldBuyRouterArgs(
            key: key,
            topUp: topUp,
            currency: currency,
            earnOffer: earnOffer,
          ),
        );

  static const String name = 'HighYieldBuyRouter';
}

class HighYieldBuyRouterArgs {
  const HighYieldBuyRouterArgs({
    this.key,
    this.topUp = false,
    required this.currency,
    required this.earnOffer,
  });

  final Key? key;

  final bool topUp;

  final CurrencyModel currency;

  final EarnOfferModel earnOffer;

  @override
  String toString() {
    return 'HighYieldBuyRouterArgs{key: $key, topUp: $topUp, currency: $currency, earnOffer: $earnOffer}';
  }
}

/// generated route for
/// [PreviewHighYieldBuyScreen]
class PreviewHighYieldBuyScreenRouter
    extends PageRouteInfo<PreviewHighYieldBuyScreenRouterArgs> {
  PreviewHighYieldBuyScreenRouter({
    Key? key,
    required PreviewHighYieldBuyInput input,
  }) : super(
          PreviewHighYieldBuyScreenRouter.name,
          path: '/preview_high_yield_buy',
          args: PreviewHighYieldBuyScreenRouterArgs(
            key: key,
            input: input,
          ),
        );

  static const String name = 'PreviewHighYieldBuyScreenRouter';
}

class PreviewHighYieldBuyScreenRouterArgs {
  const PreviewHighYieldBuyScreenRouterArgs({
    this.key,
    required this.input,
  });

  final Key? key;

  final PreviewHighYieldBuyInput input;

  @override
  String toString() {
    return 'PreviewHighYieldBuyScreenRouterArgs{key: $key, input: $input}';
  }
}

/// generated route for
/// [PreviewBuyWithBankCard]
class PreviewBuyWithBankCardRouter
    extends PageRouteInfo<PreviewBuyWithBankCardRouterArgs> {
  PreviewBuyWithBankCardRouter({
    Key? key,
    required PreviewBuyWithBankCardInput input,
  }) : super(
          PreviewBuyWithBankCardRouter.name,
          path: '/preview_buy_with_bank_card',
          args: PreviewBuyWithBankCardRouterArgs(
            key: key,
            input: input,
          ),
        );

  static const String name = 'PreviewBuyWithBankCardRouter';
}

class PreviewBuyWithBankCardRouterArgs {
  const PreviewBuyWithBankCardRouterArgs({
    this.key,
    required this.input,
  });

  final Key? key;

  final PreviewBuyWithBankCardInput input;

  @override
  String toString() {
    return 'PreviewBuyWithBankCardRouterArgs{key: $key, input: $input}';
  }
}

/// generated route for
/// [Circle3dSecureWebView]
class Circle3dSecureWebViewRouter
    extends PageRouteInfo<Circle3dSecureWebViewRouterArgs> {
  Circle3dSecureWebViewRouter({
    required String url,
    required String asset,
    required String amount,
    required dynamic Function(
      String,
      String,
    )
        onSuccess,
    required dynamic Function(String)? onCancel,
    required String paymentId,
    required dynamic Function(String) onFailed,
  }) : super(
          Circle3dSecureWebViewRouter.name,
          path: '/circle_3d_secure',
          args: Circle3dSecureWebViewRouterArgs(
            url: url,
            asset: asset,
            amount: amount,
            onSuccess: onSuccess,
            onCancel: onCancel,
            paymentId: paymentId,
            onFailed: onFailed,
          ),
        );

  static const String name = 'Circle3dSecureWebViewRouter';
}

class Circle3dSecureWebViewRouterArgs {
  const Circle3dSecureWebViewRouterArgs({
    required this.url,
    required this.asset,
    required this.amount,
    required this.onSuccess,
    required this.onCancel,
    required this.paymentId,
    required this.onFailed,
  });

  final String url;

  final String asset;

  final String amount;

  final dynamic Function(
    String,
    String,
  ) onSuccess;

  final dynamic Function(String)? onCancel;

  final String paymentId;

  final dynamic Function(String) onFailed;

  @override
  String toString() {
    return 'Circle3dSecureWebViewRouterArgs{url: $url, asset: $asset, amount: $amount, onSuccess: $onSuccess, onCancel: $onCancel, paymentId: $paymentId, onFailed: $onFailed}';
  }
}

/// generated route for
/// [SimplexWebView]
class SimplexWebViewRouter extends PageRouteInfo<SimplexWebViewRouterArgs> {
  SimplexWebViewRouter({required String url})
      : super(
          SimplexWebViewRouter.name,
          path: '/simples_webview',
          args: SimplexWebViewRouterArgs(url: url),
        );

  static const String name = 'SimplexWebViewRouter';
}

class SimplexWebViewRouterArgs {
  const SimplexWebViewRouterArgs({required this.url});

  final String url;

  @override
  String toString() {
    return 'SimplexWebViewRouterArgs{url: $url}';
  }
}

/// generated route for
/// [PreviewBuyWithUnlimint]
class PreviewBuyWithUnlimintRouter
    extends PageRouteInfo<PreviewBuyWithUnlimintRouterArgs> {
  PreviewBuyWithUnlimintRouter({
    Key? key,
    required PreviewBuyWithUnlimintInput input,
  }) : super(
          PreviewBuyWithUnlimintRouter.name,
          path: '/preview_buy_with_unlimit',
          args: PreviewBuyWithUnlimintRouterArgs(
            key: key,
            input: input,
          ),
        );

  static const String name = 'PreviewBuyWithUnlimintRouter';
}

class PreviewBuyWithUnlimintRouterArgs {
  const PreviewBuyWithUnlimintRouterArgs({
    this.key,
    required this.input,
  });

  final Key? key;

  final PreviewBuyWithUnlimintInput input;

  @override
  String toString() {
    return 'PreviewBuyWithUnlimintRouterArgs{key: $key, input: $input}';
  }
}

/// generated route for
/// [PreviewBuyWithAsset]
class PreviewBuyWithAssetRouter
    extends PageRouteInfo<PreviewBuyWithAssetRouterArgs> {
  PreviewBuyWithAssetRouter({
    Key? key,
    void Function()? onBackButtonTap,
    required PreviewBuyWithAssetInput input,
  }) : super(
          PreviewBuyWithAssetRouter.name,
          path: '/preview_buy_with_asset',
          args: PreviewBuyWithAssetRouterArgs(
            key: key,
            onBackButtonTap: onBackButtonTap,
            input: input,
          ),
        );

  static const String name = 'PreviewBuyWithAssetRouter';
}

class PreviewBuyWithAssetRouterArgs {
  const PreviewBuyWithAssetRouterArgs({
    this.key,
    this.onBackButtonTap,
    required this.input,
  });

  final Key? key;

  final void Function()? onBackButtonTap;

  final PreviewBuyWithAssetInput input;

  @override
  String toString() {
    return 'PreviewBuyWithAssetRouterArgs{key: $key, onBackButtonTap: $onBackButtonTap, input: $input}';
  }
}

/// generated route for
/// [PreviewBuyWithCircle]
class PreviewBuyWithCircleRouter
    extends PageRouteInfo<PreviewBuyWithCircleRouterArgs> {
  PreviewBuyWithCircleRouter({
    Key? key,
    required PreviewBuyWithCircleInput input,
  }) : super(
          PreviewBuyWithCircleRouter.name,
          path: '/preview_buy_with_circle',
          args: PreviewBuyWithCircleRouterArgs(
            key: key,
            input: input,
          ),
        );

  static const String name = 'PreviewBuyWithCircleRouter';
}

class PreviewBuyWithCircleRouterArgs {
  const PreviewBuyWithCircleRouterArgs({
    this.key,
    required this.input,
  });

  final Key? key;

  final PreviewBuyWithCircleInput input;

  @override
  String toString() {
    return 'PreviewBuyWithCircleRouterArgs{key: $key, input: $input}';
  }
}

/// generated route for
/// [PreviewSell]
class PreviewSellRouter extends PageRouteInfo<PreviewSellRouterArgs> {
  PreviewSellRouter({
    Key? key,
    required PreviewSellInput input,
  }) : super(
          PreviewSellRouter.name,
          path: '/preview_sell_router',
          args: PreviewSellRouterArgs(
            key: key,
            input: input,
          ),
        );

  static const String name = 'PreviewSellRouter';
}

class PreviewSellRouterArgs {
  const PreviewSellRouterArgs({
    this.key,
    required this.input,
  });

  final Key? key;

  final PreviewSellInput input;

  @override
  String toString() {
    return 'PreviewSellRouterArgs{key: $key, input: $input}';
  }
}

/// generated route for
/// [SendByPhoneNotifyRecipient]
class SendByPhoneNotifyRecipientRouter
    extends PageRouteInfo<SendByPhoneNotifyRecipientRouterArgs> {
  SendByPhoneNotifyRecipientRouter({
    Key? key,
    required String toPhoneNumber,
  }) : super(
          SendByPhoneNotifyRecipientRouter.name,
          path: '/send_by_phone_notify_recipient',
          args: SendByPhoneNotifyRecipientRouterArgs(
            key: key,
            toPhoneNumber: toPhoneNumber,
          ),
        );

  static const String name = 'SendByPhoneNotifyRecipientRouter';
}

class SendByPhoneNotifyRecipientRouterArgs {
  const SendByPhoneNotifyRecipientRouterArgs({
    this.key,
    required this.toPhoneNumber,
  });

  final Key? key;

  final String toPhoneNumber;

  @override
  String toString() {
    return 'SendByPhoneNotifyRecipientRouterArgs{key: $key, toPhoneNumber: $toPhoneNumber}';
  }
}

/// generated route for
/// [SendByPhoneAmount]
class SendByPhoneAmountRouter
    extends PageRouteInfo<SendByPhoneAmountRouterArgs> {
  SendByPhoneAmountRouter({
    Key? key,
    required CurrencyModel currency,
    ContactModel? pickedContact,
    SPhoneNumber? activeDialCode,
  }) : super(
          SendByPhoneAmountRouter.name,
          path: '/send_by_phone_amount',
          args: SendByPhoneAmountRouterArgs(
            key: key,
            currency: currency,
            pickedContact: pickedContact,
            activeDialCode: activeDialCode,
          ),
        );

  static const String name = 'SendByPhoneAmountRouter';
}

class SendByPhoneAmountRouterArgs {
  const SendByPhoneAmountRouterArgs({
    this.key,
    required this.currency,
    this.pickedContact,
    this.activeDialCode,
  });

  final Key? key;

  final CurrencyModel currency;

  final ContactModel? pickedContact;

  final SPhoneNumber? activeDialCode;

  @override
  String toString() {
    return 'SendByPhoneAmountRouterArgs{key: $key, currency: $currency, pickedContact: $pickedContact, activeDialCode: $activeDialCode}';
  }
}

/// generated route for
/// [SendByPhoneConfirm]
class SendByPhoneConfirmRouter
    extends PageRouteInfo<SendByPhoneConfirmRouterArgs> {
  SendByPhoneConfirmRouter({
    Key? key,
    required CurrencyModel currency,
    required String operationId,
    required bool receiverIsRegistered,
    required String amountStoreAmount,
    required ContactModel pickedContact,
    required SPhoneNumber activeDialCode,
  }) : super(
          SendByPhoneConfirmRouter.name,
          path: '/send_by_phone_confirm',
          args: SendByPhoneConfirmRouterArgs(
            key: key,
            currency: currency,
            operationId: operationId,
            receiverIsRegistered: receiverIsRegistered,
            amountStoreAmount: amountStoreAmount,
            pickedContact: pickedContact,
            activeDialCode: activeDialCode,
          ),
        );

  static const String name = 'SendByPhoneConfirmRouter';
}

class SendByPhoneConfirmRouterArgs {
  const SendByPhoneConfirmRouterArgs({
    this.key,
    required this.currency,
    required this.operationId,
    required this.receiverIsRegistered,
    required this.amountStoreAmount,
    required this.pickedContact,
    required this.activeDialCode,
  });

  final Key? key;

  final CurrencyModel currency;

  final String operationId;

  final bool receiverIsRegistered;

  final String amountStoreAmount;

  final ContactModel pickedContact;

  final SPhoneNumber activeDialCode;

  @override
  String toString() {
    return 'SendByPhoneConfirmRouterArgs{key: $key, currency: $currency, operationId: $operationId, receiverIsRegistered: $receiverIsRegistered, amountStoreAmount: $amountStoreAmount, pickedContact: $pickedContact, activeDialCode: $activeDialCode}';
  }
}

/// generated route for
/// [SendByPhonePreview]
class SendByPhonePreviewRouter
    extends PageRouteInfo<SendByPhonePreviewRouterArgs> {
  SendByPhonePreviewRouter({
    Key? key,
    required CurrencyModel currency,
    required String amountStoreAmount,
    required ContactModel pickedContact,
    required SPhoneNumber activeDialCode,
  }) : super(
          SendByPhonePreviewRouter.name,
          path: '/send_by_phone_preview',
          args: SendByPhonePreviewRouterArgs(
            key: key,
            currency: currency,
            amountStoreAmount: amountStoreAmount,
            pickedContact: pickedContact,
            activeDialCode: activeDialCode,
          ),
        );

  static const String name = 'SendByPhonePreviewRouter';
}

class SendByPhonePreviewRouterArgs {
  const SendByPhonePreviewRouterArgs({
    this.key,
    required this.currency,
    required this.amountStoreAmount,
    required this.pickedContact,
    required this.activeDialCode,
  });

  final Key? key;

  final CurrencyModel currency;

  final String amountStoreAmount;

  final ContactModel pickedContact;

  final SPhoneNumber activeDialCode;

  @override
  String toString() {
    return 'SendByPhonePreviewRouterArgs{key: $key, currency: $currency, amountStoreAmount: $amountStoreAmount, pickedContact: $pickedContact, activeDialCode: $activeDialCode}';
  }
}

/// generated route for
/// [DeleteReasonsScreen]
class DeleteReasonsScreenRouter extends PageRouteInfo<void> {
  const DeleteReasonsScreenRouter()
      : super(
          DeleteReasonsScreenRouter.name,
          path: '/delete_reasons_screen',
        );

  static const String name = 'DeleteReasonsScreenRouter';
}

/// generated route for
/// [PDFViewScreen]
class PDFViewScreenRouter extends PageRouteInfo<PDFViewScreenRouterArgs> {
  PDFViewScreenRouter({
    Key? key,
    required String url,
  }) : super(
          PDFViewScreenRouter.name,
          path: '/pdf_view_screen',
          args: PDFViewScreenRouterArgs(
            key: key,
            url: url,
          ),
        );

  static const String name = 'PDFViewScreenRouter';
}

class PDFViewScreenRouterArgs {
  const PDFViewScreenRouterArgs({
    this.key,
    required this.url,
  });

  final Key? key;

  final String url;

  @override
  String toString() {
    return 'PDFViewScreenRouterArgs{key: $key, url: $url}';
  }
}

/// generated route for
/// [MarketDetails]
class MarketDetailsRouter extends PageRouteInfo<MarketDetailsRouterArgs> {
  MarketDetailsRouter({
    Key? key,
    required MarketItemModel marketItem,
  }) : super(
          MarketDetailsRouter.name,
          path: '/market_details',
          args: MarketDetailsRouterArgs(
            key: key,
            marketItem: marketItem,
          ),
        );

  static const String name = 'MarketDetailsRouter';
}

class MarketDetailsRouterArgs {
  const MarketDetailsRouterArgs({
    this.key,
    required this.marketItem,
  });

  final Key? key;

  final MarketItemModel marketItem;

  @override
  String toString() {
    return 'MarketDetailsRouterArgs{key: $key, marketItem: $marketItem}';
  }
}

/// generated route for
/// [DefaultAssetChange]
class DefaultAssetChangeRouter extends PageRouteInfo<void> {
  const DefaultAssetChangeRouter()
      : super(
          DefaultAssetChangeRouter.name,
          path: '/change_base_asset',
        );

  static const String name = 'DefaultAssetChangeRouter';
}

/// generated route for
/// [NftCollectionDetails]
class NftCollectionDetailsRouter
    extends PageRouteInfo<NftCollectionDetailsRouterArgs> {
  NftCollectionDetailsRouter({
    Key? key,
    required String collectionID,
  }) : super(
          NftCollectionDetailsRouter.name,
          path: '/nft_collection',
          args: NftCollectionDetailsRouterArgs(
            key: key,
            collectionID: collectionID,
          ),
        );

  static const String name = 'NftCollectionDetailsRouter';
}

class NftCollectionDetailsRouterArgs {
  const NftCollectionDetailsRouterArgs({
    this.key,
    required this.collectionID,
  });

  final Key? key;

  final String collectionID;

  @override
  String toString() {
    return 'NftCollectionDetailsRouterArgs{key: $key, collectionID: $collectionID}';
  }
}

/// generated route for
/// [NFTDetailsScreen]
class NFTDetailsRouter extends PageRouteInfo<NFTDetailsRouterArgs> {
  NFTDetailsRouter({
    Key? key,
    bool userNFT = false,
    required String nftSymbol,
  }) : super(
          NFTDetailsRouter.name,
          path: '/nft_details',
          args: NFTDetailsRouterArgs(
            key: key,
            userNFT: userNFT,
            nftSymbol: nftSymbol,
          ),
        );

  static const String name = 'NFTDetailsRouter';
}

class NFTDetailsRouterArgs {
  const NFTDetailsRouterArgs({
    this.key,
    this.userNFT = false,
    required this.nftSymbol,
  });

  final Key? key;

  final bool userNFT;

  final String nftSymbol;

  @override
  String toString() {
    return 'NFTDetailsRouterArgs{key: $key, userNFT: $userNFT, nftSymbol: $nftSymbol}';
  }
}

/// generated route for
/// [NFTConfirmScreen]
class NFTConfirmRouter extends PageRouteInfo<NFTConfirmRouterArgs> {
  NFTConfirmRouter({
    Key? key,
    required NftMarket nft,
  }) : super(
          NFTConfirmRouter.name,
          path: '/nft_confirm',
          args: NFTConfirmRouterArgs(
            key: key,
            nft: nft,
          ),
        );

  static const String name = 'NFTConfirmRouter';
}

class NFTConfirmRouterArgs {
  const NFTConfirmRouterArgs({
    this.key,
    required this.nft,
  });

  final Key? key;

  final NftMarket nft;

  @override
  String toString() {
    return 'NFTConfirmRouterArgs{key: $key, nft: $nft}';
  }
}

/// generated route for
/// [NFTCollectionSimpleListScreen]
class NFTCollectionSimpleListRouter
    extends PageRouteInfo<NFTCollectionSimpleListRouterArgs> {
  NFTCollectionSimpleListRouter({
    Key? key,
    required String collectionID,
  }) : super(
          NFTCollectionSimpleListRouter.name,
          path: '/nft_collection_simple_list_router',
          args: NFTCollectionSimpleListRouterArgs(
            key: key,
            collectionID: collectionID,
          ),
        );

  static const String name = 'NFTCollectionSimpleListRouter';
}

class NFTCollectionSimpleListRouterArgs {
  const NFTCollectionSimpleListRouterArgs({
    this.key,
    required this.collectionID,
  });

  final Key? key;

  final String collectionID;

  @override
  String toString() {
    return 'NFTCollectionSimpleListRouterArgs{key: $key, collectionID: $collectionID}';
  }
}

/// generated route for
/// [NFTSellScreen]
class NFTSellRouter extends PageRouteInfo<NFTSellRouterArgs> {
  NFTSellRouter({
    Key? key,
    required NftMarket nft,
  }) : super(
          NFTSellRouter.name,
          path: '/nft_sell',
          args: NFTSellRouterArgs(
            key: key,
            nft: nft,
          ),
        );

  static const String name = 'NFTSellRouter';
}

class NFTSellRouterArgs {
  const NFTSellRouterArgs({
    this.key,
    required this.nft,
  });

  final Key? key;

  final NftMarket nft;

  @override
  String toString() {
    return 'NFTSellRouterArgs{key: $key, nft: $nft}';
  }
}

/// generated route for
/// [NFTPreviewSellScreen]
class NFTPreviewSellRouter extends PageRouteInfo<NFTPreviewSellRouterArgs> {
  NFTPreviewSellRouter({
    Key? key,
    required NftSellInput input,
  }) : super(
          NFTPreviewSellRouter.name,
          path: '/nft_preview_sell',
          args: NFTPreviewSellRouterArgs(
            key: key,
            input: input,
          ),
        );

  static const String name = 'NFTPreviewSellRouter';
}

class NFTPreviewSellRouterArgs {
  const NFTPreviewSellRouterArgs({
    this.key,
    required this.input,
  });

  final Key? key;

  final NftSellInput input;

  @override
  String toString() {
    return 'NFTPreviewSellRouterArgs{key: $key, input: $input}';
  }
}

/// generated route for
/// [ReceiveNFTScreen]
class ReceiveNFTRouter extends PageRouteInfo<void> {
  const ReceiveNFTRouter()
      : super(
          ReceiveNFTRouter.name,
          path: '/nft_receive',
        );

  static const String name = 'ReceiveNFTRouter';
}

/// generated route for
/// [LogsScreen]
class LogsRouter extends PageRouteInfo<void> {
  const LogsRouter()
      : super(
          LogsRouter.name,
          path: '/logs_debug',
        );

  static const String name = 'LogsRouter';
}

/// generated route for
/// [WithdrawalScreen]
class WithdrawRouter extends PageRouteInfo<WithdrawRouterArgs> {
  WithdrawRouter({
    Key? key,
    required WithdrawalModel withdrawal,
    List<PageRouteInfo>? children,
  }) : super(
          WithdrawRouter.name,
          path: '/withdrawal',
          args: WithdrawRouterArgs(
            key: key,
            withdrawal: withdrawal,
          ),
          initialChildren: children,
        );

  static const String name = 'WithdrawRouter';
}

class WithdrawRouterArgs {
  const WithdrawRouterArgs({
    this.key,
    required this.withdrawal,
  });

  final Key? key;

  final WithdrawalModel withdrawal;

  @override
  String toString() {
    return 'WithdrawRouterArgs{key: $key, withdrawal: $withdrawal}';
  }
}

/// generated route for
/// [MarketScreen]
class MarketRouter extends PageRouteInfo<MarketRouterArgs> {
  MarketRouter({
    Key? key,
    int initIndex = 0,
  }) : super(
          MarketRouter.name,
          path: 'market',
          args: MarketRouterArgs(
            key: key,
            initIndex: initIndex,
          ),
        );

  static const String name = 'MarketRouter';
}

class MarketRouterArgs {
  const MarketRouterArgs({
    this.key,
    this.initIndex = 0,
  });

  final Key? key;

  final int initIndex;

  @override
  String toString() {
    return 'MarketRouterArgs{key: $key, initIndex: $initIndex}';
  }
}

/// generated route for
/// [PortfolioScreen]
class PortfolioRouter extends PageRouteInfo<void> {
  const PortfolioRouter()
      : super(
          PortfolioRouter.name,
          path: 'portfolio',
        );

  static const String name = 'PortfolioRouter';
}

/// generated route for
/// [IBanScreen]
class IBanRouter extends PageRouteInfo<void> {
  const IBanRouter()
      : super(
          IBanRouter.name,
          path: 'iban',
        );

  static const String name = 'IBanRouter';
}

/// generated route for
/// [WithdrawalAddressScreen]
class WithdrawalAddressRouter extends PageRouteInfo<void> {
  const WithdrawalAddressRouter()
      : super(
          WithdrawalAddressRouter.name,
          path: 'withdrawal_address',
        );

  static const String name = 'WithdrawalAddressRouter';
}

/// generated route for
/// [WithdrawalAmmountScreen]
class WithdrawalAmmountRouter extends PageRouteInfo<void> {
  const WithdrawalAmmountRouter()
      : super(
          WithdrawalAmmountRouter.name,
          path: 'withdrawal_ammount',
        );

  static const String name = 'WithdrawalAmmountRouter';
}

/// generated route for
/// [WithdrawalConfirmScreen]
class WithdrawalConfirmRouter extends PageRouteInfo<void> {
  const WithdrawalConfirmRouter()
      : super(
          WithdrawalConfirmRouter.name,
          path: 'withdrawal_confirm',
        );

  static const String name = 'WithdrawalConfirmRouter';
}

/// generated route for
/// [WithdrawalPreviewScreen]
class WithdrawalPreviewRouter extends PageRouteInfo<void> {
  const WithdrawalPreviewRouter()
      : super(
          WithdrawalPreviewRouter.name,
          path: 'withdrawal_preview',
        );

  static const String name = 'WithdrawalPreviewRouter';
}
