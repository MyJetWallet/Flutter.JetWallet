// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    RecurringSuccessScreenRouter.name: (routeData) {
      final args = routeData.argsAs<RecurringSuccessScreenRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RecurringSuccessScreen(
          key: args.key,
          input: args.input,
        ),
      );
    },
    HomeRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    EmailConfirmationRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const EmailConfirmationScreen(),
      );
    },
    ApiSelectorRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ApiSelectorScreen(),
      );
    },
    AppInitRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AppInitRouter(),
      );
    },
    AllowCameraRoute.name: (routeData) {
      final args = routeData.argsAs<AllowCameraRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AllowCameraScreen(
          key: args.key,
          permissionDescription: args.permissionDescription,
          then: args.then,
        ),
      );
    },
    ChooseDocumentsRouter.name: (routeData) {
      final args = routeData.argsAs<ChooseDocumentsRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChooseDocuments(
          key: args.key,
          headerTitle: args.headerTitle,
        ),
      );
    },
    UploadKycDocumentsRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UploadKycDocuments(),
      );
    },
    UploadVerificationPhotoRouter.name: (routeData) {
      final args = routeData.argsAs<UploadVerificationPhotoRouterArgs>();
      return AutoRoutePage<dynamic>(
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
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const KycSelfie(),
      );
    },
    SuccessKycScreenRoute.name: (routeData) {
      final args = routeData.argsAs<SuccessKycScreenRouteArgs>(
          orElse: () => const SuccessKycScreenRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SuccessKycScreen(
          key: args.key,
          primaryText: args.primaryText,
          secondaryText: args.secondaryText,
          specialTextWidget: args.specialTextWidget,
        ),
      );
    },
    KycVerificationSumsubRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const KycVerificationSumsub(),
      );
    },
    KycVerificationRouter.name: (routeData) {
      final args = routeData.argsAs<KycVerificationRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: KycVerification(
          key: args.key,
          requiredVerifications: args.requiredVerifications,
        ),
      );
    },
    KycVerifyYourProfileRouter.name: (routeData) {
      final args = routeData.argsAs<KycVerifyYourProfileRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: KycVerifyYourProfile(
          key: args.key,
          requiredVerifications: args.requiredVerifications,
        ),
      );
    },
    SignalrDebugInfoRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SignalrDebugInfo(),
      );
    },
    DebugInfoRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DebugInfo(),
      );
    },
    LogsRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LogsScreen(),
      );
    },
    SendByPhoneAmountRouter.name: (routeData) {
      final args = routeData.argsAs<SendByPhoneAmountRouterArgs>();
      return AutoRoutePage<dynamic>(
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
      return AutoRoutePage<dynamic>(
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
      return AutoRoutePage<dynamic>(
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
    SendByPhoneNotifyRecipientRouter.name: (routeData) {
      final args = routeData.argsAs<SendByPhoneNotifyRecipientRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SendByPhoneNotifyRecipient(
          key: args.key,
          toPhoneNumber: args.toPhoneNumber,
        ),
      );
    },
    SendByPhoneInputRouter.name: (routeData) {
      final args = routeData.argsAs<SendByPhoneInputRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SendByPhoneInput(
          key: args.key,
          currency: args.currency,
        ),
      );
    },
    SplashNoAnimationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreenNoAnimation(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
    SingInRouter.name: (routeData) {
      final args = routeData.argsAs<SingInRouterArgs>(
          orElse: () => const SingInRouterArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SingIn(
          key: args.key,
          email: args.email,
        ),
      );
    },
    BiometricRouter.name: (routeData) {
      final args = routeData.argsAs<BiometricRouterArgs>(
          orElse: () => const BiometricRouterArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: Biometric(
          key: args.key,
          isAccSettings: args.isAccSettings,
        ),
      );
    },
    AllowBiometricRoute.name: (routeData) {
      final args = routeData.argsAs<AllowBiometricRouteArgs>(
          orElse: () => const AllowBiometricRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AllowBiometric(
          key: args.key,
          s: args.s,
        ),
      );
    },
    VerificationRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const VerificationScreen(),
      );
    },
    UserDataScreenRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UserDataScreen(),
      );
    },
    EmailVerificationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const EmailVerification(),
      );
    },
    OnboardingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnboardingScreen(),
      );
    },
    WithdrawalAddressRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WithdrawalAddressScreen(),
      );
    },
    WithdrawalAmmountRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WithdrawalAmmountScreen(),
      );
    },
    WithdrawalPreviewRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WithdrawalPreviewScreen(),
      );
    },
    WithdrawalConfirmRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WithdrawalConfirmScreen(),
      );
    },
    WithdrawRouter.name: (routeData) {
      final args = routeData.argsAs<WithdrawRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WithdrawalScreen(
          key: args.key,
          withdrawal: args.withdrawal,
        ),
      );
    },
    SendGloballyConfirmRouter.name: (routeData) {
      final args = routeData.argsAs<SendGloballyConfirmRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SendGloballyConfirmScreen(
          key: args.key,
          data: args.data,
          method: args.method,
        ),
      );
    },
    SendCardDetailRouter.name: (routeData) {
      final args = routeData.argsAs<SendCardDetailRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SendCardDetailScreen(
          key: args.key,
          method: args.method,
          countryCode: args.countryCode,
          currency: args.currency,
        ),
      );
    },
    SendCardPaymentMethodRouter.name: (routeData) {
      final args = routeData.argsAs<SendCardPaymentMethodRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SendCardPaymentMethodScreen(
          key: args.key,
          countryCode: args.countryCode,
          currency: args.currency,
        ),
      );
    },
    SendGloballyAmountRouter.name: (routeData) {
      final args = routeData.argsAs<SendGloballyAmountRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SendGloballyAmountScreen(
          key: args.key,
          data: args.data,
          method: args.method,
        ),
      );
    },
    RewardsRouter.name: (routeData) {
      final args = routeData.argsAs<RewardsRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: Rewards(
          key: args.key,
          actualRewards: args.actualRewards,
        ),
      );
    },
    ReturnToWalletRouter.name: (routeData) {
      final args = routeData.argsAs<ReturnToWalletRouterArgs>();
      return AutoRoutePage<dynamic>(
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
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PreviewReturnToWallet(
          key: args.key,
          input: args.input,
        ),
      );
    },
    IBanRouter.name: (routeData) {
      final args = routeData.argsAs<IBanRouterArgs>(
          orElse: () => const IBanRouterArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: IBanScreen(
          key: args.key,
          initIndex: args.initIndex,
        ),
      );
    },
    IbanAddBankAccountRouter.name: (routeData) {
      final args = routeData.argsAs<IbanAddBankAccountRouterArgs>(
          orElse: () => const IbanAddBankAccountRouterArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: IbanAddBankAccountScreen(
          key: args.key,
          contact: args.contact,
        ),
      );
    },
    IbanEditBankAccountRouter.name: (routeData) {
      final args = routeData.argsAs<IbanEditBankAccountRouterArgs>(
          orElse: () => const IbanEditBankAccountRouterArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: IbanEditBankAccountScreen(
          key: args.key,
          contact: args.contact,
        ),
      );
    },
    IbanAddressRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const IbanBillingAddress(),
      );
    },
    IbanSendConfirmRouter.name: (routeData) {
      final args = routeData.argsAs<IbanSendConfirmRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: IbanSendConfirm(
          key: args.key,
          contact: args.contact,
          data: args.data,
        ),
      );
    },
    IbanSendAmountRouter.name: (routeData) {
      final args = routeData.argsAs<IbanSendAmountRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: IbanSendAmount(
          key: args.key,
          contact: args.contact,
        ),
      );
    },
    CryptoDepositRouter.name: (routeData) {
      final args = routeData.argsAs<CryptoDepositRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CryptoDeposit(
          key: args.key,
          header: args.header,
          currency: args.currency,
        ),
      );
    },
    SmsAuthenticatorRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SmsAuthenticator(),
      );
    },
    SetPhoneNumberRouter.name: (routeData) {
      final args = routeData.argsAs<SetPhoneNumberRouterArgs>();
      return AutoRoutePage<dynamic>(
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
    CircleBillingAddressRouter.name: (routeData) {
      final args = routeData.argsAs<CircleBillingAddressRouterArgs>();
      return AutoRoutePage<dynamic>(
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
    AddCircleCardRouter.name: (routeData) {
      final args = routeData.argsAs<AddCircleCardRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AddCircleCard(
          key: args.key,
          onCardAdded: args.onCardAdded,
        ),
      );
    },
    CurrencySellRouter.name: (routeData) {
      final args = routeData.argsAs<CurrencySellRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CurrencySell(
          key: args.key,
          currency: args.currency,
        ),
      );
    },
    PreviewSellRouter.name: (routeData) {
      final args = routeData.argsAs<PreviewSellRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PreviewSell(
          key: args.key,
          input: args.input,
        ),
      );
    },
    TransactionHistoryRouter.name: (routeData) {
      final args = routeData.argsAs<TransactionHistoryRouterArgs>(
          orElse: () => const TransactionHistoryRouterArgs());
      return AutoRoutePage<dynamic>(
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
    HistoryRecurringBuysRouter.name: (routeData) {
      final args = routeData.argsAs<HistoryRecurringBuysRouterArgs>(
          orElse: () => const HistoryRecurringBuysRouterArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HistoryRecurringBuys(
          key: args.key,
          from: args.from,
        ),
      );
    },
    GiftSelectAssetRouter.name: (routeData) {
      final args = routeData.argsAs<GiftSelectAssetRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: GiftSelectAssetScreen(
          key: args.key,
          assets: args.assets,
        ),
      );
    },
    ShowRecurringInfoActionRouter.name: (routeData) {
      final args = routeData.argsAs<ShowRecurringInfoActionRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ShowRecurringInfoAction(
          key: args.key,
          recurringItem: args.recurringItem,
          assetName: args.assetName,
        ),
      );
    },
    EmptyWalletRouter.name: (routeData) {
      final args = routeData.argsAs<EmptyWalletRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EmptyWallet(
          key: args.key,
          currency: args.currency,
        ),
      );
    },
    WalletRouter.name: (routeData) {
      final args = routeData.argsAs<WalletRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: Wallet(
          key: args.key,
          currency: args.currency,
        ),
      );
    },
    PinScreenRoute.name: (routeData) {
      final args = routeData.argsAs<PinScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
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
    PortfolioRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PortfolioScreen(),
      );
    },
    MarketRouter.name: (routeData) {
      final args = routeData.argsAs<MarketRouterArgs>(
          orElse: () => const MarketRouterArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MarketScreen(
          key: args.key,
          initIndex: args.initIndex,
        ),
      );
    },
    MarketDetailsRouter.name: (routeData) {
      final args = routeData.argsAs<MarketDetailsRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MarketDetails(
          key: args.key,
          marketItem: args.marketItem,
        ),
      );
    },
    PDFViewScreenRouter.name: (routeData) {
      final args = routeData.argsAs<PDFViewScreenRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PDFViewScreen(
          key: args.key,
          url: args.url,
        ),
      );
    },
    PhoneVerificationRouter.name: (routeData) {
      final args = routeData.argsAs<PhoneVerificationRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PhoneVerification(
          key: args.key,
          args: args.args,
        ),
      );
    },
    AddUnlimintCardRouter.name: (routeData) {
      final args = routeData.argsAs<AddUnlimintCardRouterArgs>();
      return AutoRoutePage<dynamic>(
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
    PreviewBuyWithBankCardRouter.name: (routeData) {
      final args = routeData.argsAs<PreviewBuyWithBankCardRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PreviewBuyWithBankCard(
          key: args.key,
          input: args.input,
        ),
      );
    },
    PreviewBuyWithUnlimintRouter.name: (routeData) {
      final args = routeData.argsAs<PreviewBuyWithUnlimintRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PreviewBuyWithUnlimint(
          key: args.key,
          input: args.input,
        ),
      );
    },
    SimplexWebViewRouter.name: (routeData) {
      final args = routeData.argsAs<SimplexWebViewRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SimplexWebView(args.url),
      );
    },
    Circle3dSecureWebViewRouter.name: (routeData) {
      final args = routeData.argsAs<Circle3dSecureWebViewRouterArgs>();
      return AutoRoutePage<dynamic>(
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
    PreviewBuyWithCircleRouter.name: (routeData) {
      final args = routeData.argsAs<PreviewBuyWithCircleRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PreviewBuyWithCircle(
          key: args.key,
          input: args.input,
        ),
      );
    },
    ChooseAssetRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChooseAssetScreen(),
      );
    },
    PreviewBuyWithAssetRouter.name: (routeData) {
      final args = routeData.argsAs<PreviewBuyWithAssetRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PreviewBuyWithAsset(
          key: args.key,
          onBackButtonTap: args.onBackButtonTap,
          input: args.input,
        ),
      );
    },
    PaymentMethodRouter.name: (routeData) {
      final args = routeData.argsAs<PaymentMethodRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PaymentMethodScreen(
          key: args.key,
          currency: args.currency,
        ),
      );
    },
    CurrencyBuyRouter.name: (routeData) {
      final args = routeData.argsAs<CurrencyBuyRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CurrencyBuy(
          key: args.key,
          recurringBuysType: args.recurringBuysType,
          circleCard: args.circleCard,
          unlimintCard: args.unlimintCard,
          bankCard: args.bankCard,
          newBankCardId: args.newBankCardId,
          newBankCardNumber: args.newBankCardNumber,
          showUaAlert: args.showUaAlert,
          currency: args.currency,
          fromCard: args.fromCard,
          paymentMethod: args.paymentMethod,
        ),
      );
    },
    DeleteReasonsScreenRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DeleteReasonsScreen(),
      );
    },
    DeleteProfileRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DeleteProfile(),
      );
    },
    ProfileDetailsRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileDetails(),
      );
    },
    DefaultAssetChangeRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DefaultAssetChange(),
      );
    },
    ChangePasswordRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChangePassword(),
      );
    },
    SetNewPasswordRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SetNewPassword(),
      );
    },
    AccountRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountScreen(),
      );
    },
    CrispRouter.name: (routeData) {
      final args = routeData.argsAs<CrispRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: Crisp(
          key: args.key,
          welcomeText: args.welcomeText,
        ),
      );
    },
    AboutUsRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AboutUs(),
      );
    },
    HelpCenterWebViewRouter.name: (routeData) {
      final args = routeData.argsAs<HelpCenterWebViewRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HelpCenterWebView(
          key: args.key,
          link: args.link,
        ),
      );
    },
    AccountSecurityRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountSecurity(),
      );
    },
    TwoFaPhoneRouter.name: (routeData) {
      final args = routeData.argsAs<TwoFaPhoneRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TwoFaPhone(
          key: args.key,
          trigger: args.trigger,
        ),
      );
    },
    PaymentMethodsRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PaymentMethods(),
      );
    },
    PreviewConvertRouter.name: (routeData) {
      final args = routeData.argsAs<PreviewConvertRouterArgs>();
      return AutoRoutePage<dynamic>(
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
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: Convert(
          key: args.key,
          fromCurrency: args.fromCurrency,
        ),
      );
    },
    WaitingScreenRouter.name: (routeData) {
      final args = routeData.argsAs<WaitingScreenRouterArgs>();
      return AutoRoutePage<dynamic>(
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
      return AutoRoutePage<dynamic>(
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
    SuccessScreenRouter.name: (routeData) {
      final args = routeData.argsAs<SuccessScreenRouterArgs>(
          orElse: () => const SuccessScreenRouterArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SuccessScreen(
          key: args.key,
          onSuccess: args.onSuccess,
          onActionButton: args.onActionButton,
          primaryText: args.primaryText,
          secondaryText: args.secondaryText,
          specialTextWidget: args.specialTextWidget,
          bottomWidget: args.bottomWidget,
          showActionButton: args.showActionButton,
          showProgressBar: args.showProgressBar,
          showShareButton: args.showShareButton,
          showPrimaryButton: args.showPrimaryButton,
          buttonText: args.buttonText,
          time: args.time,
        ),
      );
    },
    VerifyingScreenRouter.name: (routeData) {
      final args = routeData.argsAs<VerifyingScreenRouterArgs>();
      return AutoRoutePage<dynamic>(
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
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SuccessVerifyingScreen(
          key: args.key,
          onSuccess: args.onSuccess,
        ),
      );
    },
    InfoWebViewRouter.name: (routeData) {
      final args = routeData.argsAs<InfoWebViewRouterArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: InfoWebView(
          key: args.key,
          link: args.link,
          title: args.title,
        ),
      );
    },
    GiftReceiversDetailsRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const GiftReceiversDetailsScreen(),
      );
    },
  };
}

/// generated route for
/// [RecurringSuccessScreen]
class RecurringSuccessScreenRouter
    extends PageRouteInfo<RecurringSuccessScreenRouterArgs> {
  RecurringSuccessScreenRouter({
    Key? key,
    required PreviewBuyWithAssetInput input,
    List<PageRouteInfo>? children,
  }) : super(
          RecurringSuccessScreenRouter.name,
          args: RecurringSuccessScreenRouterArgs(
            key: key,
            input: input,
          ),
          initialChildren: children,
        );

  static const String name = 'RecurringSuccessScreenRouter';

  static const PageInfo<RecurringSuccessScreenRouterArgs> page =
      PageInfo<RecurringSuccessScreenRouterArgs>(name);
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
/// [HomeScreen]
class HomeRouter extends PageRouteInfo<void> {
  const HomeRouter({List<PageRouteInfo>? children})
      : super(
          HomeRouter.name,
          initialChildren: children,
        );

  static const String name = 'HomeRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EmailConfirmationScreen]
class EmailConfirmationRouter extends PageRouteInfo<void> {
  const EmailConfirmationRouter({List<PageRouteInfo>? children})
      : super(
          EmailConfirmationRouter.name,
          initialChildren: children,
        );

  static const String name = 'EmailConfirmationRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ApiSelectorScreen]
class ApiSelectorRouter extends PageRouteInfo<void> {
  const ApiSelectorRouter({List<PageRouteInfo>? children})
      : super(
          ApiSelectorRouter.name,
          initialChildren: children,
        );

  static const String name = 'ApiSelectorRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AppInitRouter]
class AppInitRoute extends PageRouteInfo<void> {
  const AppInitRoute({List<PageRouteInfo>? children})
      : super(
          AppInitRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppInitRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AllowCameraScreen]
class AllowCameraRoute extends PageRouteInfo<AllowCameraRouteArgs> {
  AllowCameraRoute({
    Key? key,
    required String permissionDescription,
    required void Function() then,
    List<PageRouteInfo>? children,
  }) : super(
          AllowCameraRoute.name,
          args: AllowCameraRouteArgs(
            key: key,
            permissionDescription: permissionDescription,
            then: then,
          ),
          initialChildren: children,
        );

  static const String name = 'AllowCameraRoute';

  static const PageInfo<AllowCameraRouteArgs> page =
      PageInfo<AllowCameraRouteArgs>(name);
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
/// [ChooseDocuments]
class ChooseDocumentsRouter extends PageRouteInfo<ChooseDocumentsRouterArgs> {
  ChooseDocumentsRouter({
    Key? key,
    required String headerTitle,
    List<PageRouteInfo>? children,
  }) : super(
          ChooseDocumentsRouter.name,
          args: ChooseDocumentsRouterArgs(
            key: key,
            headerTitle: headerTitle,
          ),
          initialChildren: children,
        );

  static const String name = 'ChooseDocumentsRouter';

  static const PageInfo<ChooseDocumentsRouterArgs> page =
      PageInfo<ChooseDocumentsRouterArgs>(name);
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
  const UploadKycDocumentsRouter({List<PageRouteInfo>? children})
      : super(
          UploadKycDocumentsRouter.name,
          initialChildren: children,
        );

  static const String name = 'UploadKycDocumentsRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
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
    List<PageRouteInfo>? children,
  }) : super(
          UploadVerificationPhotoRouter.name,
          args: UploadVerificationPhotoRouterArgs(
            key: key,
            isSelfie: isSelfie,
            cardId: cardId,
            onSuccess: onSuccess,
          ),
          initialChildren: children,
        );

  static const String name = 'UploadVerificationPhotoRouter';

  static const PageInfo<UploadVerificationPhotoRouterArgs> page =
      PageInfo<UploadVerificationPhotoRouterArgs>(name);
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
  const KycSelfieRouter({List<PageRouteInfo>? children})
      : super(
          KycSelfieRouter.name,
          initialChildren: children,
        );

  static const String name = 'KycSelfieRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SuccessKycScreen]
class SuccessKycScreenRoute extends PageRouteInfo<SuccessKycScreenRouteArgs> {
  SuccessKycScreenRoute({
    Key? key,
    String? primaryText,
    String? secondaryText,
    Widget? specialTextWidget,
    List<PageRouteInfo>? children,
  }) : super(
          SuccessKycScreenRoute.name,
          args: SuccessKycScreenRouteArgs(
            key: key,
            primaryText: primaryText,
            secondaryText: secondaryText,
            specialTextWidget: specialTextWidget,
          ),
          initialChildren: children,
        );

  static const String name = 'SuccessKycScreenRoute';

  static const PageInfo<SuccessKycScreenRouteArgs> page =
      PageInfo<SuccessKycScreenRouteArgs>(name);
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
/// [KycVerificationSumsub]
class KycVerificationSumsubRouter extends PageRouteInfo<void> {
  const KycVerificationSumsubRouter({List<PageRouteInfo>? children})
      : super(
          KycVerificationSumsubRouter.name,
          initialChildren: children,
        );

  static const String name = 'KycVerificationSumsubRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [KycVerification]
class KycVerificationRouter extends PageRouteInfo<KycVerificationRouterArgs> {
  KycVerificationRouter({
    Key? key,
    required List<RequiredVerified> requiredVerifications,
    List<PageRouteInfo>? children,
  }) : super(
          KycVerificationRouter.name,
          args: KycVerificationRouterArgs(
            key: key,
            requiredVerifications: requiredVerifications,
          ),
          initialChildren: children,
        );

  static const String name = 'KycVerificationRouter';

  static const PageInfo<KycVerificationRouterArgs> page =
      PageInfo<KycVerificationRouterArgs>(name);
}

class KycVerificationRouterArgs {
  const KycVerificationRouterArgs({
    this.key,
    required this.requiredVerifications,
  });

  final Key? key;

  final List<RequiredVerified> requiredVerifications;

  @override
  String toString() {
    return 'KycVerificationRouterArgs{key: $key, requiredVerifications: $requiredVerifications}';
  }
}

/// generated route for
/// [KycVerifyYourProfile]
class KycVerifyYourProfileRouter
    extends PageRouteInfo<KycVerifyYourProfileRouterArgs> {
  KycVerifyYourProfileRouter({
    Key? key,
    required List<RequiredVerified> requiredVerifications,
    List<PageRouteInfo>? children,
  }) : super(
          KycVerifyYourProfileRouter.name,
          args: KycVerifyYourProfileRouterArgs(
            key: key,
            requiredVerifications: requiredVerifications,
          ),
          initialChildren: children,
        );

  static const String name = 'KycVerifyYourProfileRouter';

  static const PageInfo<KycVerifyYourProfileRouterArgs> page =
      PageInfo<KycVerifyYourProfileRouterArgs>(name);
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
/// [SignalrDebugInfo]
class SignalrDebugInfoRouter extends PageRouteInfo<void> {
  const SignalrDebugInfoRouter({List<PageRouteInfo>? children})
      : super(
          SignalrDebugInfoRouter.name,
          initialChildren: children,
        );

  static const String name = 'SignalrDebugInfoRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DebugInfo]
class DebugInfoRouter extends PageRouteInfo<void> {
  const DebugInfoRouter({List<PageRouteInfo>? children})
      : super(
          DebugInfoRouter.name,
          initialChildren: children,
        );

  static const String name = 'DebugInfoRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LogsScreen]
class LogsRouter extends PageRouteInfo<void> {
  const LogsRouter({List<PageRouteInfo>? children})
      : super(
          LogsRouter.name,
          initialChildren: children,
        );

  static const String name = 'LogsRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
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
    List<PageRouteInfo>? children,
  }) : super(
          SendByPhoneAmountRouter.name,
          args: SendByPhoneAmountRouterArgs(
            key: key,
            currency: currency,
            pickedContact: pickedContact,
            activeDialCode: activeDialCode,
          ),
          initialChildren: children,
        );

  static const String name = 'SendByPhoneAmountRouter';

  static const PageInfo<SendByPhoneAmountRouterArgs> page =
      PageInfo<SendByPhoneAmountRouterArgs>(name);
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
    List<PageRouteInfo>? children,
  }) : super(
          SendByPhoneConfirmRouter.name,
          args: SendByPhoneConfirmRouterArgs(
            key: key,
            currency: currency,
            operationId: operationId,
            receiverIsRegistered: receiverIsRegistered,
            amountStoreAmount: amountStoreAmount,
            pickedContact: pickedContact,
            activeDialCode: activeDialCode,
          ),
          initialChildren: children,
        );

  static const String name = 'SendByPhoneConfirmRouter';

  static const PageInfo<SendByPhoneConfirmRouterArgs> page =
      PageInfo<SendByPhoneConfirmRouterArgs>(name);
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
    List<PageRouteInfo>? children,
  }) : super(
          SendByPhonePreviewRouter.name,
          args: SendByPhonePreviewRouterArgs(
            key: key,
            currency: currency,
            amountStoreAmount: amountStoreAmount,
            pickedContact: pickedContact,
            activeDialCode: activeDialCode,
          ),
          initialChildren: children,
        );

  static const String name = 'SendByPhonePreviewRouter';

  static const PageInfo<SendByPhonePreviewRouterArgs> page =
      PageInfo<SendByPhonePreviewRouterArgs>(name);
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
/// [SendByPhoneNotifyRecipient]
class SendByPhoneNotifyRecipientRouter
    extends PageRouteInfo<SendByPhoneNotifyRecipientRouterArgs> {
  SendByPhoneNotifyRecipientRouter({
    Key? key,
    required String toPhoneNumber,
    List<PageRouteInfo>? children,
  }) : super(
          SendByPhoneNotifyRecipientRouter.name,
          args: SendByPhoneNotifyRecipientRouterArgs(
            key: key,
            toPhoneNumber: toPhoneNumber,
          ),
          initialChildren: children,
        );

  static const String name = 'SendByPhoneNotifyRecipientRouter';

  static const PageInfo<SendByPhoneNotifyRecipientRouterArgs> page =
      PageInfo<SendByPhoneNotifyRecipientRouterArgs>(name);
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
/// [SendByPhoneInput]
class SendByPhoneInputRouter extends PageRouteInfo<SendByPhoneInputRouterArgs> {
  SendByPhoneInputRouter({
    Key? key,
    required CurrencyModel currency,
    List<PageRouteInfo>? children,
  }) : super(
          SendByPhoneInputRouter.name,
          args: SendByPhoneInputRouterArgs(
            key: key,
            currency: currency,
          ),
          initialChildren: children,
        );

  static const String name = 'SendByPhoneInputRouter';

  static const PageInfo<SendByPhoneInputRouterArgs> page =
      PageInfo<SendByPhoneInputRouterArgs>(name);
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
/// [SplashScreenNoAnimation]
class SplashNoAnimationRoute extends PageRouteInfo<void> {
  const SplashNoAnimationRoute({List<PageRouteInfo>? children})
      : super(
          SplashNoAnimationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashNoAnimationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SingIn]
class SingInRouter extends PageRouteInfo<SingInRouterArgs> {
  SingInRouter({
    Key? key,
    String? email,
    List<PageRouteInfo>? children,
  }) : super(
          SingInRouter.name,
          args: SingInRouterArgs(
            key: key,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'SingInRouter';

  static const PageInfo<SingInRouterArgs> page =
      PageInfo<SingInRouterArgs>(name);
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
/// [Biometric]
class BiometricRouter extends PageRouteInfo<BiometricRouterArgs> {
  BiometricRouter({
    Key? key,
    bool isAccSettings = false,
    List<PageRouteInfo>? children,
  }) : super(
          BiometricRouter.name,
          args: BiometricRouterArgs(
            key: key,
            isAccSettings: isAccSettings,
          ),
          initialChildren: children,
        );

  static const String name = 'BiometricRouter';

  static const PageInfo<BiometricRouterArgs> page =
      PageInfo<BiometricRouterArgs>(name);
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
/// [AllowBiometric]
class AllowBiometricRoute extends PageRouteInfo<AllowBiometricRouteArgs> {
  AllowBiometricRoute({
    Key? key,
    dynamic s,
    List<PageRouteInfo>? children,
  }) : super(
          AllowBiometricRoute.name,
          args: AllowBiometricRouteArgs(
            key: key,
            s: s,
          ),
          initialChildren: children,
        );

  static const String name = 'AllowBiometricRoute';

  static const PageInfo<AllowBiometricRouteArgs> page =
      PageInfo<AllowBiometricRouteArgs>(name);
}

class AllowBiometricRouteArgs {
  const AllowBiometricRouteArgs({
    this.key,
    this.s,
  });

  final Key? key;

  final dynamic s;

  @override
  String toString() {
    return 'AllowBiometricRouteArgs{key: $key, s: $s}';
  }
}

/// generated route for
/// [VerificationScreen]
class VerificationRouter extends PageRouteInfo<void> {
  const VerificationRouter({List<PageRouteInfo>? children})
      : super(
          VerificationRouter.name,
          initialChildren: children,
        );

  static const String name = 'VerificationRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserDataScreen]
class UserDataScreenRouter extends PageRouteInfo<void> {
  const UserDataScreenRouter({List<PageRouteInfo>? children})
      : super(
          UserDataScreenRouter.name,
          initialChildren: children,
        );

  static const String name = 'UserDataScreenRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EmailVerification]
class EmailVerificationRoute extends PageRouteInfo<void> {
  const EmailVerificationRoute({List<PageRouteInfo>? children})
      : super(
          EmailVerificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'EmailVerificationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OnboardingScreen]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WithdrawalAddressScreen]
class WithdrawalAddressRouter extends PageRouteInfo<void> {
  const WithdrawalAddressRouter({List<PageRouteInfo>? children})
      : super(
          WithdrawalAddressRouter.name,
          initialChildren: children,
        );

  static const String name = 'WithdrawalAddressRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WithdrawalAmmountScreen]
class WithdrawalAmmountRouter extends PageRouteInfo<void> {
  const WithdrawalAmmountRouter({List<PageRouteInfo>? children})
      : super(
          WithdrawalAmmountRouter.name,
          initialChildren: children,
        );

  static const String name = 'WithdrawalAmmountRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WithdrawalPreviewScreen]
class WithdrawalPreviewRouter extends PageRouteInfo<void> {
  const WithdrawalPreviewRouter({List<PageRouteInfo>? children})
      : super(
          WithdrawalPreviewRouter.name,
          initialChildren: children,
        );

  static const String name = 'WithdrawalPreviewRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WithdrawalConfirmScreen]
class WithdrawalConfirmRouter extends PageRouteInfo<void> {
  const WithdrawalConfirmRouter({List<PageRouteInfo>? children})
      : super(
          WithdrawalConfirmRouter.name,
          initialChildren: children,
        );

  static const String name = 'WithdrawalConfirmRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
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
          args: WithdrawRouterArgs(
            key: key,
            withdrawal: withdrawal,
          ),
          initialChildren: children,
        );

  static const String name = 'WithdrawRouter';

  static const PageInfo<WithdrawRouterArgs> page =
      PageInfo<WithdrawRouterArgs>(name);
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
/// [SendGloballyConfirmScreen]
class SendGloballyConfirmRouter
    extends PageRouteInfo<SendGloballyConfirmRouterArgs> {
  SendGloballyConfirmRouter({
    Key? key,
    required SendToBankCardResponse data,
    required GlobalSendMethodsModelMethods method,
    List<PageRouteInfo>? children,
  }) : super(
          SendGloballyConfirmRouter.name,
          args: SendGloballyConfirmRouterArgs(
            key: key,
            data: data,
            method: method,
          ),
          initialChildren: children,
        );

  static const String name = 'SendGloballyConfirmRouter';

  static const PageInfo<SendGloballyConfirmRouterArgs> page =
      PageInfo<SendGloballyConfirmRouterArgs>(name);
}

class SendGloballyConfirmRouterArgs {
  const SendGloballyConfirmRouterArgs({
    this.key,
    required this.data,
    required this.method,
  });

  final Key? key;

  final SendToBankCardResponse data;

  final GlobalSendMethodsModelMethods method;

  @override
  String toString() {
    return 'SendGloballyConfirmRouterArgs{key: $key, data: $data, method: $method}';
  }
}

/// generated route for
/// [SendCardDetailScreen]
class SendCardDetailRouter extends PageRouteInfo<SendCardDetailRouterArgs> {
  SendCardDetailRouter({
    Key? key,
    required GlobalSendMethodsModelMethods method,
    required String countryCode,
    required CurrencyModel currency,
    List<PageRouteInfo>? children,
  }) : super(
          SendCardDetailRouter.name,
          args: SendCardDetailRouterArgs(
            key: key,
            method: method,
            countryCode: countryCode,
            currency: currency,
          ),
          initialChildren: children,
        );

  static const String name = 'SendCardDetailRouter';

  static const PageInfo<SendCardDetailRouterArgs> page =
      PageInfo<SendCardDetailRouterArgs>(name);
}

class SendCardDetailRouterArgs {
  const SendCardDetailRouterArgs({
    this.key,
    required this.method,
    required this.countryCode,
    required this.currency,
  });

  final Key? key;

  final GlobalSendMethodsModelMethods method;

  final String countryCode;

  final CurrencyModel currency;

  @override
  String toString() {
    return 'SendCardDetailRouterArgs{key: $key, method: $method, countryCode: $countryCode, currency: $currency}';
  }
}

/// generated route for
/// [SendCardPaymentMethodScreen]
class SendCardPaymentMethodRouter
    extends PageRouteInfo<SendCardPaymentMethodRouterArgs> {
  SendCardPaymentMethodRouter({
    Key? key,
    required String countryCode,
    required CurrencyModel currency,
    List<PageRouteInfo>? children,
  }) : super(
          SendCardPaymentMethodRouter.name,
          args: SendCardPaymentMethodRouterArgs(
            key: key,
            countryCode: countryCode,
            currency: currency,
          ),
          initialChildren: children,
        );

  static const String name = 'SendCardPaymentMethodRouter';

  static const PageInfo<SendCardPaymentMethodRouterArgs> page =
      PageInfo<SendCardPaymentMethodRouterArgs>(name);
}

class SendCardPaymentMethodRouterArgs {
  const SendCardPaymentMethodRouterArgs({
    this.key,
    required this.countryCode,
    required this.currency,
  });

  final Key? key;

  final String countryCode;

  final CurrencyModel currency;

  @override
  String toString() {
    return 'SendCardPaymentMethodRouterArgs{key: $key, countryCode: $countryCode, currency: $currency}';
  }
}

/// generated route for
/// [SendGloballyAmountScreen]
class SendGloballyAmountRouter
    extends PageRouteInfo<SendGloballyAmountRouterArgs> {
  SendGloballyAmountRouter({
    Key? key,
    required SendToBankRequestModel data,
    required GlobalSendMethodsModelMethods method,
    List<PageRouteInfo>? children,
  }) : super(
          SendGloballyAmountRouter.name,
          args: SendGloballyAmountRouterArgs(
            key: key,
            data: data,
            method: method,
          ),
          initialChildren: children,
        );

  static const String name = 'SendGloballyAmountRouter';

  static const PageInfo<SendGloballyAmountRouterArgs> page =
      PageInfo<SendGloballyAmountRouterArgs>(name);
}

class SendGloballyAmountRouterArgs {
  const SendGloballyAmountRouterArgs({
    this.key,
    required this.data,
    required this.method,
  });

  final Key? key;

  final SendToBankRequestModel data;

  final GlobalSendMethodsModelMethods method;

  @override
  String toString() {
    return 'SendGloballyAmountRouterArgs{key: $key, data: $data, method: $method}';
  }
}

/// generated route for
/// [Rewards]
class RewardsRouter extends PageRouteInfo<RewardsRouterArgs> {
  RewardsRouter({
    Key? key,
    required List<String> actualRewards,
    List<PageRouteInfo>? children,
  }) : super(
          RewardsRouter.name,
          args: RewardsRouterArgs(
            key: key,
            actualRewards: actualRewards,
          ),
          initialChildren: children,
        );

  static const String name = 'RewardsRouter';

  static const PageInfo<RewardsRouterArgs> page =
      PageInfo<RewardsRouterArgs>(name);
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
/// [ReturnToWallet]
class ReturnToWalletRouter extends PageRouteInfo<ReturnToWalletRouterArgs> {
  ReturnToWalletRouter({
    Key? key,
    required CurrencyModel currency,
    required EarnOfferModel earnOffer,
    List<PageRouteInfo>? children,
  }) : super(
          ReturnToWalletRouter.name,
          args: ReturnToWalletRouterArgs(
            key: key,
            currency: currency,
            earnOffer: earnOffer,
          ),
          initialChildren: children,
        );

  static const String name = 'ReturnToWalletRouter';

  static const PageInfo<ReturnToWalletRouterArgs> page =
      PageInfo<ReturnToWalletRouterArgs>(name);
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
    List<PageRouteInfo>? children,
  }) : super(
          PreviewReturnToWalletRouter.name,
          args: PreviewReturnToWalletRouterArgs(
            key: key,
            input: input,
          ),
          initialChildren: children,
        );

  static const String name = 'PreviewReturnToWalletRouter';

  static const PageInfo<PreviewReturnToWalletRouterArgs> page =
      PageInfo<PreviewReturnToWalletRouterArgs>(name);
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
/// [IBanScreen]
class IBanRouter extends PageRouteInfo<IBanRouterArgs> {
  IBanRouter({
    Key? key,
    int initIndex = 0,
    List<PageRouteInfo>? children,
  }) : super(
          IBanRouter.name,
          args: IBanRouterArgs(
            key: key,
            initIndex: initIndex,
          ),
          initialChildren: children,
        );

  static const String name = 'IBanRouter';

  static const PageInfo<IBanRouterArgs> page = PageInfo<IBanRouterArgs>(name);
}

class IBanRouterArgs {
  const IBanRouterArgs({
    this.key,
    this.initIndex = 0,
  });

  final Key? key;

  final int initIndex;

  @override
  String toString() {
    return 'IBanRouterArgs{key: $key, initIndex: $initIndex}';
  }
}

/// generated route for
/// [IbanAddBankAccountScreen]
class IbanAddBankAccountRouter
    extends PageRouteInfo<IbanAddBankAccountRouterArgs> {
  IbanAddBankAccountRouter({
    Key? key,
    AddressBookContactModel? contact,
    List<PageRouteInfo>? children,
  }) : super(
          IbanAddBankAccountRouter.name,
          args: IbanAddBankAccountRouterArgs(
            key: key,
            contact: contact,
          ),
          initialChildren: children,
        );

  static const String name = 'IbanAddBankAccountRouter';

  static const PageInfo<IbanAddBankAccountRouterArgs> page =
      PageInfo<IbanAddBankAccountRouterArgs>(name);
}

class IbanAddBankAccountRouterArgs {
  const IbanAddBankAccountRouterArgs({
    this.key,
    this.contact,
  });

  final Key? key;

  final AddressBookContactModel? contact;

  @override
  String toString() {
    return 'IbanAddBankAccountRouterArgs{key: $key, contact: $contact}';
  }
}

/// generated route for
/// [IbanEditBankAccountScreen]
class IbanEditBankAccountRouter
    extends PageRouteInfo<IbanEditBankAccountRouterArgs> {
  IbanEditBankAccountRouter({
    Key? key,
    AddressBookContactModel? contact,
    List<PageRouteInfo>? children,
  }) : super(
          IbanEditBankAccountRouter.name,
          args: IbanEditBankAccountRouterArgs(
            key: key,
            contact: contact,
          ),
          initialChildren: children,
        );

  static const String name = 'IbanEditBankAccountRouter';

  static const PageInfo<IbanEditBankAccountRouterArgs> page =
      PageInfo<IbanEditBankAccountRouterArgs>(name);
}

class IbanEditBankAccountRouterArgs {
  const IbanEditBankAccountRouterArgs({
    this.key,
    this.contact,
  });

  final Key? key;

  final AddressBookContactModel? contact;

  @override
  String toString() {
    return 'IbanEditBankAccountRouterArgs{key: $key, contact: $contact}';
  }
}

/// generated route for
/// [IbanBillingAddress]
class IbanAddressRouter extends PageRouteInfo<void> {
  const IbanAddressRouter({List<PageRouteInfo>? children})
      : super(
          IbanAddressRouter.name,
          initialChildren: children,
        );

  static const String name = 'IbanAddressRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [IbanSendConfirm]
class IbanSendConfirmRouter extends PageRouteInfo<IbanSendConfirmRouterArgs> {
  IbanSendConfirmRouter({
    Key? key,
    required AddressBookContactModel contact,
    required IbanPreviewWithdrawalModel data,
    List<PageRouteInfo>? children,
  }) : super(
          IbanSendConfirmRouter.name,
          args: IbanSendConfirmRouterArgs(
            key: key,
            contact: contact,
            data: data,
          ),
          initialChildren: children,
        );

  static const String name = 'IbanSendConfirmRouter';

  static const PageInfo<IbanSendConfirmRouterArgs> page =
      PageInfo<IbanSendConfirmRouterArgs>(name);
}

class IbanSendConfirmRouterArgs {
  const IbanSendConfirmRouterArgs({
    this.key,
    required this.contact,
    required this.data,
  });

  final Key? key;

  final AddressBookContactModel contact;

  final IbanPreviewWithdrawalModel data;

  @override
  String toString() {
    return 'IbanSendConfirmRouterArgs{key: $key, contact: $contact, data: $data}';
  }
}

/// generated route for
/// [IbanSendAmount]
class IbanSendAmountRouter extends PageRouteInfo<IbanSendAmountRouterArgs> {
  IbanSendAmountRouter({
    Key? key,
    required AddressBookContactModel contact,
    List<PageRouteInfo>? children,
  }) : super(
          IbanSendAmountRouter.name,
          args: IbanSendAmountRouterArgs(
            key: key,
            contact: contact,
          ),
          initialChildren: children,
        );

  static const String name = 'IbanSendAmountRouter';

  static const PageInfo<IbanSendAmountRouterArgs> page =
      PageInfo<IbanSendAmountRouterArgs>(name);
}

class IbanSendAmountRouterArgs {
  const IbanSendAmountRouterArgs({
    this.key,
    required this.contact,
  });

  final Key? key;

  final AddressBookContactModel contact;

  @override
  String toString() {
    return 'IbanSendAmountRouterArgs{key: $key, contact: $contact}';
  }
}

/// generated route for
/// [CryptoDeposit]
class CryptoDepositRouter extends PageRouteInfo<CryptoDepositRouterArgs> {
  CryptoDepositRouter({
    Key? key,
    required String header,
    required CurrencyModel currency,
    List<PageRouteInfo>? children,
  }) : super(
          CryptoDepositRouter.name,
          args: CryptoDepositRouterArgs(
            key: key,
            header: header,
            currency: currency,
          ),
          initialChildren: children,
        );

  static const String name = 'CryptoDepositRouter';

  static const PageInfo<CryptoDepositRouterArgs> page =
      PageInfo<CryptoDepositRouterArgs>(name);
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
/// [SmsAuthenticator]
class SmsAuthenticatorRouter extends PageRouteInfo<void> {
  const SmsAuthenticatorRouter({List<PageRouteInfo>? children})
      : super(
          SmsAuthenticatorRouter.name,
          initialChildren: children,
        );

  static const String name = 'SmsAuthenticatorRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
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
    List<PageRouteInfo>? children,
  }) : super(
          SetPhoneNumberRouter.name,
          args: SetPhoneNumberRouterArgs(
            key: key,
            then: then,
            isChangePhone: isChangePhone,
            fromRegister: fromRegister,
            successText: successText,
          ),
          initialChildren: children,
        );

  static const String name = 'SetPhoneNumberRouter';

  static const PageInfo<SetPhoneNumberRouterArgs> page =
      PageInfo<SetPhoneNumberRouterArgs>(name);
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
    List<PageRouteInfo>? children,
  }) : super(
          CircleBillingAddressRouter.name,
          args: CircleBillingAddressRouterArgs(
            key: key,
            onCardAdded: onCardAdded,
            expiryDate: expiryDate,
            cardholderName: cardholderName,
            cardNumber: cardNumber,
            cvv: cvv,
          ),
          initialChildren: children,
        );

  static const String name = 'CircleBillingAddressRouter';

  static const PageInfo<CircleBillingAddressRouterArgs> page =
      PageInfo<CircleBillingAddressRouterArgs>(name);
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
/// [AddCircleCard]
class AddCircleCardRouter extends PageRouteInfo<AddCircleCardRouterArgs> {
  AddCircleCardRouter({
    Key? key,
    required dynamic Function(CircleCard) onCardAdded,
    List<PageRouteInfo>? children,
  }) : super(
          AddCircleCardRouter.name,
          args: AddCircleCardRouterArgs(
            key: key,
            onCardAdded: onCardAdded,
          ),
          initialChildren: children,
        );

  static const String name = 'AddCircleCardRouter';

  static const PageInfo<AddCircleCardRouterArgs> page =
      PageInfo<AddCircleCardRouterArgs>(name);
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
/// [CurrencySell]
class CurrencySellRouter extends PageRouteInfo<CurrencySellRouterArgs> {
  CurrencySellRouter({
    Key? key,
    required CurrencyModel currency,
    List<PageRouteInfo>? children,
  }) : super(
          CurrencySellRouter.name,
          args: CurrencySellRouterArgs(
            key: key,
            currency: currency,
          ),
          initialChildren: children,
        );

  static const String name = 'CurrencySellRouter';

  static const PageInfo<CurrencySellRouterArgs> page =
      PageInfo<CurrencySellRouterArgs>(name);
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
/// [PreviewSell]
class PreviewSellRouter extends PageRouteInfo<PreviewSellRouterArgs> {
  PreviewSellRouter({
    Key? key,
    required PreviewSellInput input,
    List<PageRouteInfo>? children,
  }) : super(
          PreviewSellRouter.name,
          args: PreviewSellRouterArgs(
            key: key,
            input: input,
          ),
          initialChildren: children,
        );

  static const String name = 'PreviewSellRouter';

  static const PageInfo<PreviewSellRouterArgs> page =
      PageInfo<PreviewSellRouterArgs>(name);
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
/// [TransactionHistory]
class TransactionHistoryRouter
    extends PageRouteInfo<TransactionHistoryRouterArgs> {
  TransactionHistoryRouter({
    Key? key,
    String? assetName,
    String? assetSymbol,
    int initialIndex = 0,
    String? jwOperationId,
    List<PageRouteInfo>? children,
  }) : super(
          TransactionHistoryRouter.name,
          args: TransactionHistoryRouterArgs(
            key: key,
            assetName: assetName,
            assetSymbol: assetSymbol,
            initialIndex: initialIndex,
            jwOperationId: jwOperationId,
          ),
          initialChildren: children,
        );

  static const String name = 'TransactionHistoryRouter';

  static const PageInfo<TransactionHistoryRouterArgs> page =
      PageInfo<TransactionHistoryRouterArgs>(name);
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
/// [HistoryRecurringBuys]
class HistoryRecurringBuysRouter
    extends PageRouteInfo<HistoryRecurringBuysRouterArgs> {
  HistoryRecurringBuysRouter({
    Key? key,
    Source? from,
    List<PageRouteInfo>? children,
  }) : super(
          HistoryRecurringBuysRouter.name,
          args: HistoryRecurringBuysRouterArgs(
            key: key,
            from: from,
          ),
          initialChildren: children,
        );

  static const String name = 'HistoryRecurringBuysRouter';

  static const PageInfo<HistoryRecurringBuysRouterArgs> page =
      PageInfo<HistoryRecurringBuysRouterArgs>(name);
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
/// [GiftSelectAssetScreen]
class GiftSelectAssetRouter extends PageRouteInfo<GiftSelectAssetRouterArgs> {
  GiftSelectAssetRouter({
    Key? key,
    required List<CurrencyModel> assets,
    List<PageRouteInfo>? children,
  }) : super(
          GiftSelectAssetRouter.name,
          args: GiftSelectAssetRouterArgs(
            key: key,
            assets: assets,
          ),
          initialChildren: children,
        );

  static const String name = 'GiftSelectAssetRouter';

  static const PageInfo<GiftSelectAssetRouterArgs> page =
      PageInfo<GiftSelectAssetRouterArgs>(name);
}

class GiftSelectAssetRouterArgs {
  const GiftSelectAssetRouterArgs({
    this.key,
    required this.assets,
  });

  final Key? key;

  final List<CurrencyModel> assets;

  @override
  String toString() {
    return 'GiftSelectAssetRouterArgs{key: $key, assets: $assets}';
  }
}

/// generated route for
/// [ShowRecurringInfoAction]
class ShowRecurringInfoActionRouter
    extends PageRouteInfo<ShowRecurringInfoActionRouterArgs> {
  ShowRecurringInfoActionRouter({
    Key? key,
    required RecurringBuysModel recurringItem,
    required String assetName,
    List<PageRouteInfo>? children,
  }) : super(
          ShowRecurringInfoActionRouter.name,
          args: ShowRecurringInfoActionRouterArgs(
            key: key,
            recurringItem: recurringItem,
            assetName: assetName,
          ),
          initialChildren: children,
        );

  static const String name = 'ShowRecurringInfoActionRouter';

  static const PageInfo<ShowRecurringInfoActionRouterArgs> page =
      PageInfo<ShowRecurringInfoActionRouterArgs>(name);
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
/// [EmptyWallet]
class EmptyWalletRouter extends PageRouteInfo<EmptyWalletRouterArgs> {
  EmptyWalletRouter({
    Key? key,
    required CurrencyModel currency,
    List<PageRouteInfo>? children,
  }) : super(
          EmptyWalletRouter.name,
          args: EmptyWalletRouterArgs(
            key: key,
            currency: currency,
          ),
          initialChildren: children,
        );

  static const String name = 'EmptyWalletRouter';

  static const PageInfo<EmptyWalletRouterArgs> page =
      PageInfo<EmptyWalletRouterArgs>(name);
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
    List<PageRouteInfo>? children,
  }) : super(
          WalletRouter.name,
          args: WalletRouterArgs(
            key: key,
            currency: currency,
          ),
          initialChildren: children,
        );

  static const String name = 'WalletRouter';

  static const PageInfo<WalletRouterArgs> page =
      PageInfo<WalletRouterArgs>(name);
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
    List<PageRouteInfo>? children,
  }) : super(
          PinScreenRoute.name,
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
          initialChildren: children,
        );

  static const String name = 'PinScreenRoute';

  static const PageInfo<PinScreenRouteArgs> page =
      PageInfo<PinScreenRouteArgs>(name);
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
/// [PortfolioScreen]
class PortfolioRouter extends PageRouteInfo<void> {
  const PortfolioRouter({List<PageRouteInfo>? children})
      : super(
          PortfolioRouter.name,
          initialChildren: children,
        );

  static const String name = 'PortfolioRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MarketScreen]
class MarketRouter extends PageRouteInfo<MarketRouterArgs> {
  MarketRouter({
    Key? key,
    int initIndex = 0,
    List<PageRouteInfo>? children,
  }) : super(
          MarketRouter.name,
          args: MarketRouterArgs(
            key: key,
            initIndex: initIndex,
          ),
          initialChildren: children,
        );

  static const String name = 'MarketRouter';

  static const PageInfo<MarketRouterArgs> page =
      PageInfo<MarketRouterArgs>(name);
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
/// [MarketDetails]
class MarketDetailsRouter extends PageRouteInfo<MarketDetailsRouterArgs> {
  MarketDetailsRouter({
    Key? key,
    required MarketItemModel marketItem,
    List<PageRouteInfo>? children,
  }) : super(
          MarketDetailsRouter.name,
          args: MarketDetailsRouterArgs(
            key: key,
            marketItem: marketItem,
          ),
          initialChildren: children,
        );

  static const String name = 'MarketDetailsRouter';

  static const PageInfo<MarketDetailsRouterArgs> page =
      PageInfo<MarketDetailsRouterArgs>(name);
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
/// [PDFViewScreen]
class PDFViewScreenRouter extends PageRouteInfo<PDFViewScreenRouterArgs> {
  PDFViewScreenRouter({
    Key? key,
    required String url,
    List<PageRouteInfo>? children,
  }) : super(
          PDFViewScreenRouter.name,
          args: PDFViewScreenRouterArgs(
            key: key,
            url: url,
          ),
          initialChildren: children,
        );

  static const String name = 'PDFViewScreenRouter';

  static const PageInfo<PDFViewScreenRouterArgs> page =
      PageInfo<PDFViewScreenRouterArgs>(name);
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
/// [PhoneVerification]
class PhoneVerificationRouter
    extends PageRouteInfo<PhoneVerificationRouterArgs> {
  PhoneVerificationRouter({
    Key? key,
    required PhoneVerificationArgs args,
    List<PageRouteInfo>? children,
  }) : super(
          PhoneVerificationRouter.name,
          args: PhoneVerificationRouterArgs(
            key: key,
            args: args,
          ),
          initialChildren: children,
        );

  static const String name = 'PhoneVerificationRouter';

  static const PageInfo<PhoneVerificationRouterArgs> page =
      PageInfo<PhoneVerificationRouterArgs>(name);
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
/// [AddBankCard]
class AddUnlimintCardRouter extends PageRouteInfo<AddUnlimintCardRouterArgs> {
  AddUnlimintCardRouter({
    Key? key,
    required dynamic Function() onCardAdded,
    required String amount,
    CurrencyModel? currency,
    bool isPreview = false,
    List<PageRouteInfo>? children,
  }) : super(
          AddUnlimintCardRouter.name,
          args: AddUnlimintCardRouterArgs(
            key: key,
            onCardAdded: onCardAdded,
            amount: amount,
            currency: currency,
            isPreview: isPreview,
          ),
          initialChildren: children,
        );

  static const String name = 'AddUnlimintCardRouter';

  static const PageInfo<AddUnlimintCardRouterArgs> page =
      PageInfo<AddUnlimintCardRouterArgs>(name);
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
/// [PreviewBuyWithBankCard]
class PreviewBuyWithBankCardRouter
    extends PageRouteInfo<PreviewBuyWithBankCardRouterArgs> {
  PreviewBuyWithBankCardRouter({
    Key? key,
    required PreviewBuyWithBankCardInput input,
    List<PageRouteInfo>? children,
  }) : super(
          PreviewBuyWithBankCardRouter.name,
          args: PreviewBuyWithBankCardRouterArgs(
            key: key,
            input: input,
          ),
          initialChildren: children,
        );

  static const String name = 'PreviewBuyWithBankCardRouter';

  static const PageInfo<PreviewBuyWithBankCardRouterArgs> page =
      PageInfo<PreviewBuyWithBankCardRouterArgs>(name);
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
/// [PreviewBuyWithUnlimint]
class PreviewBuyWithUnlimintRouter
    extends PageRouteInfo<PreviewBuyWithUnlimintRouterArgs> {
  PreviewBuyWithUnlimintRouter({
    Key? key,
    required PreviewBuyWithUnlimintInput input,
    List<PageRouteInfo>? children,
  }) : super(
          PreviewBuyWithUnlimintRouter.name,
          args: PreviewBuyWithUnlimintRouterArgs(
            key: key,
            input: input,
          ),
          initialChildren: children,
        );

  static const String name = 'PreviewBuyWithUnlimintRouter';

  static const PageInfo<PreviewBuyWithUnlimintRouterArgs> page =
      PageInfo<PreviewBuyWithUnlimintRouterArgs>(name);
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
/// [SimplexWebView]
class SimplexWebViewRouter extends PageRouteInfo<SimplexWebViewRouterArgs> {
  SimplexWebViewRouter({
    required String url,
    List<PageRouteInfo>? children,
  }) : super(
          SimplexWebViewRouter.name,
          args: SimplexWebViewRouterArgs(url: url),
          initialChildren: children,
        );

  static const String name = 'SimplexWebViewRouter';

  static const PageInfo<SimplexWebViewRouterArgs> page =
      PageInfo<SimplexWebViewRouterArgs>(name);
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
    ) onSuccess,
    required dynamic Function(String)? onCancel,
    required String paymentId,
    required dynamic Function(String) onFailed,
    List<PageRouteInfo>? children,
  }) : super(
          Circle3dSecureWebViewRouter.name,
          args: Circle3dSecureWebViewRouterArgs(
            url: url,
            asset: asset,
            amount: amount,
            onSuccess: onSuccess,
            onCancel: onCancel,
            paymentId: paymentId,
            onFailed: onFailed,
          ),
          initialChildren: children,
        );

  static const String name = 'Circle3dSecureWebViewRouter';

  static const PageInfo<Circle3dSecureWebViewRouterArgs> page =
      PageInfo<Circle3dSecureWebViewRouterArgs>(name);
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
/// [PreviewBuyWithCircle]
class PreviewBuyWithCircleRouter
    extends PageRouteInfo<PreviewBuyWithCircleRouterArgs> {
  PreviewBuyWithCircleRouter({
    Key? key,
    required PreviewBuyWithCircleInput input,
    List<PageRouteInfo>? children,
  }) : super(
          PreviewBuyWithCircleRouter.name,
          args: PreviewBuyWithCircleRouterArgs(
            key: key,
            input: input,
          ),
          initialChildren: children,
        );

  static const String name = 'PreviewBuyWithCircleRouter';

  static const PageInfo<PreviewBuyWithCircleRouterArgs> page =
      PageInfo<PreviewBuyWithCircleRouterArgs>(name);
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
/// [ChooseAssetScreen]
class ChooseAssetRouter extends PageRouteInfo<void> {
  const ChooseAssetRouter({List<PageRouteInfo>? children})
      : super(
          ChooseAssetRouter.name,
          initialChildren: children,
        );

  static const String name = 'ChooseAssetRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PreviewBuyWithAsset]
class PreviewBuyWithAssetRouter
    extends PageRouteInfo<PreviewBuyWithAssetRouterArgs> {
  PreviewBuyWithAssetRouter({
    Key? key,
    void Function()? onBackButtonTap,
    required PreviewBuyWithAssetInput input,
    List<PageRouteInfo>? children,
  }) : super(
          PreviewBuyWithAssetRouter.name,
          args: PreviewBuyWithAssetRouterArgs(
            key: key,
            onBackButtonTap: onBackButtonTap,
            input: input,
          ),
          initialChildren: children,
        );

  static const String name = 'PreviewBuyWithAssetRouter';

  static const PageInfo<PreviewBuyWithAssetRouterArgs> page =
      PageInfo<PreviewBuyWithAssetRouterArgs>(name);
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
/// [PaymentMethodScreen]
class PaymentMethodRouter extends PageRouteInfo<PaymentMethodRouterArgs> {
  PaymentMethodRouter({
    Key? key,
    required CurrencyModel currency,
    List<PageRouteInfo>? children,
  }) : super(
          PaymentMethodRouter.name,
          args: PaymentMethodRouterArgs(
            key: key,
            currency: currency,
          ),
          initialChildren: children,
        );

  static const String name = 'PaymentMethodRouter';

  static const PageInfo<PaymentMethodRouterArgs> page =
      PageInfo<PaymentMethodRouterArgs>(name);
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
    bool showUaAlert = false,
    required CurrencyModel currency,
    required bool fromCard,
    required PaymentMethodType paymentMethod,
    List<PageRouteInfo>? children,
  }) : super(
          CurrencyBuyRouter.name,
          args: CurrencyBuyRouterArgs(
            key: key,
            recurringBuysType: recurringBuysType,
            circleCard: circleCard,
            unlimintCard: unlimintCard,
            bankCard: bankCard,
            newBankCardId: newBankCardId,
            newBankCardNumber: newBankCardNumber,
            showUaAlert: showUaAlert,
            currency: currency,
            fromCard: fromCard,
            paymentMethod: paymentMethod,
          ),
          initialChildren: children,
        );

  static const String name = 'CurrencyBuyRouter';

  static const PageInfo<CurrencyBuyRouterArgs> page =
      PageInfo<CurrencyBuyRouterArgs>(name);
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
    this.showUaAlert = false,
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

  final bool showUaAlert;

  final CurrencyModel currency;

  final bool fromCard;

  final PaymentMethodType paymentMethod;

  @override
  String toString() {
    return 'CurrencyBuyRouterArgs{key: $key, recurringBuysType: $recurringBuysType, circleCard: $circleCard, unlimintCard: $unlimintCard, bankCard: $bankCard, newBankCardId: $newBankCardId, newBankCardNumber: $newBankCardNumber, showUaAlert: $showUaAlert, currency: $currency, fromCard: $fromCard, paymentMethod: $paymentMethod}';
  }
}

/// generated route for
/// [DeleteReasonsScreen]
class DeleteReasonsScreenRouter extends PageRouteInfo<void> {
  const DeleteReasonsScreenRouter({List<PageRouteInfo>? children})
      : super(
          DeleteReasonsScreenRouter.name,
          initialChildren: children,
        );

  static const String name = 'DeleteReasonsScreenRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DeleteProfile]
class DeleteProfileRouter extends PageRouteInfo<void> {
  const DeleteProfileRouter({List<PageRouteInfo>? children})
      : super(
          DeleteProfileRouter.name,
          initialChildren: children,
        );

  static const String name = 'DeleteProfileRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileDetails]
class ProfileDetailsRouter extends PageRouteInfo<void> {
  const ProfileDetailsRouter({List<PageRouteInfo>? children})
      : super(
          ProfileDetailsRouter.name,
          initialChildren: children,
        );

  static const String name = 'ProfileDetailsRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DefaultAssetChange]
class DefaultAssetChangeRouter extends PageRouteInfo<void> {
  const DefaultAssetChangeRouter({List<PageRouteInfo>? children})
      : super(
          DefaultAssetChangeRouter.name,
          initialChildren: children,
        );

  static const String name = 'DefaultAssetChangeRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ChangePassword]
class ChangePasswordRouter extends PageRouteInfo<void> {
  const ChangePasswordRouter({List<PageRouteInfo>? children})
      : super(
          ChangePasswordRouter.name,
          initialChildren: children,
        );

  static const String name = 'ChangePasswordRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SetNewPassword]
class SetNewPasswordRouter extends PageRouteInfo<void> {
  const SetNewPasswordRouter({List<PageRouteInfo>? children})
      : super(
          SetNewPasswordRouter.name,
          initialChildren: children,
        );

  static const String name = 'SetNewPasswordRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AccountScreen]
class AccountRouter extends PageRouteInfo<void> {
  const AccountRouter({List<PageRouteInfo>? children})
      : super(
          AccountRouter.name,
          initialChildren: children,
        );

  static const String name = 'AccountRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [Crisp]
class CrispRouter extends PageRouteInfo<CrispRouterArgs> {
  CrispRouter({
    Key? key,
    required String welcomeText,
    List<PageRouteInfo>? children,
  }) : super(
          CrispRouter.name,
          args: CrispRouterArgs(
            key: key,
            welcomeText: welcomeText,
          ),
          initialChildren: children,
        );

  static const String name = 'CrispRouter';

  static const PageInfo<CrispRouterArgs> page = PageInfo<CrispRouterArgs>(name);
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
/// [AboutUs]
class AboutUsRouter extends PageRouteInfo<void> {
  const AboutUsRouter({List<PageRouteInfo>? children})
      : super(
          AboutUsRouter.name,
          initialChildren: children,
        );

  static const String name = 'AboutUsRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HelpCenterWebView]
class HelpCenterWebViewRouter
    extends PageRouteInfo<HelpCenterWebViewRouterArgs> {
  HelpCenterWebViewRouter({
    Key? key,
    required String link,
    List<PageRouteInfo>? children,
  }) : super(
          HelpCenterWebViewRouter.name,
          args: HelpCenterWebViewRouterArgs(
            key: key,
            link: link,
          ),
          initialChildren: children,
        );

  static const String name = 'HelpCenterWebViewRouter';

  static const PageInfo<HelpCenterWebViewRouterArgs> page =
      PageInfo<HelpCenterWebViewRouterArgs>(name);
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
/// [AccountSecurity]
class AccountSecurityRouter extends PageRouteInfo<void> {
  const AccountSecurityRouter({List<PageRouteInfo>? children})
      : super(
          AccountSecurityRouter.name,
          initialChildren: children,
        );

  static const String name = 'AccountSecurityRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TwoFaPhone]
class TwoFaPhoneRouter extends PageRouteInfo<TwoFaPhoneRouterArgs> {
  TwoFaPhoneRouter({
    Key? key,
    required TwoFaPhoneTriggerUnion trigger,
    List<PageRouteInfo>? children,
  }) : super(
          TwoFaPhoneRouter.name,
          args: TwoFaPhoneRouterArgs(
            key: key,
            trigger: trigger,
          ),
          initialChildren: children,
        );

  static const String name = 'TwoFaPhoneRouter';

  static const PageInfo<TwoFaPhoneRouterArgs> page =
      PageInfo<TwoFaPhoneRouterArgs>(name);
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
/// [PaymentMethods]
class PaymentMethodsRouter extends PageRouteInfo<void> {
  const PaymentMethodsRouter({List<PageRouteInfo>? children})
      : super(
          PaymentMethodsRouter.name,
          initialChildren: children,
        );

  static const String name = 'PaymentMethodsRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PreviewConvert]
class PreviewConvertRouter extends PageRouteInfo<PreviewConvertRouterArgs> {
  PreviewConvertRouter({
    Key? key,
    required PreviewConvertInput input,
    List<PageRouteInfo>? children,
  }) : super(
          PreviewConvertRouter.name,
          args: PreviewConvertRouterArgs(
            key: key,
            input: input,
          ),
          initialChildren: children,
        );

  static const String name = 'PreviewConvertRouter';

  static const PageInfo<PreviewConvertRouterArgs> page =
      PageInfo<PreviewConvertRouterArgs>(name);
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
    List<PageRouteInfo>? children,
  }) : super(
          ConvertRouter.name,
          args: ConvertRouterArgs(
            key: key,
            fromCurrency: fromCurrency,
          ),
          initialChildren: children,
        );

  static const String name = 'ConvertRouter';

  static const PageInfo<ConvertRouterArgs> page =
      PageInfo<ConvertRouterArgs>(name);
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
    List<PageRouteInfo>? children,
  }) : super(
          WaitingScreenRouter.name,
          args: WaitingScreenRouterArgs(
            key: key,
            onSuccess: onSuccess,
            primaryText: primaryText,
            secondaryText: secondaryText,
            specialTextWidget: specialTextWidget,
            wasAction: wasAction,
            onSkip: onSkip,
          ),
          initialChildren: children,
        );

  static const String name = 'WaitingScreenRouter';

  static const PageInfo<WaitingScreenRouterArgs> page =
      PageInfo<WaitingScreenRouterArgs>(name);
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
    List<PageRouteInfo>? children,
  }) : super(
          FailureScreenRouter.name,
          args: FailureScreenRouterArgs(
            key: key,
            secondaryText: secondaryText,
            secondaryButtonName: secondaryButtonName,
            onSecondaryButtonTap: onSecondaryButtonTap,
            primaryText: primaryText,
            primaryButtonName: primaryButtonName,
            onPrimaryButtonTap: onPrimaryButtonTap,
          ),
          initialChildren: children,
        );

  static const String name = 'FailureScreenRouter';

  static const PageInfo<FailureScreenRouterArgs> page =
      PageInfo<FailureScreenRouterArgs>(name);
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
/// [SuccessScreen]
class SuccessScreenRouter extends PageRouteInfo<SuccessScreenRouterArgs> {
  SuccessScreenRouter({
    Key? key,
    dynamic Function(BuildContext)? onSuccess,
    dynamic Function()? onActionButton,
    String? primaryText,
    String? secondaryText,
    Widget? specialTextWidget,
    Widget? bottomWidget,
    bool showActionButton = false,
    bool showProgressBar = false,
    bool showShareButton = false,
    bool showPrimaryButton = false,
    String? buttonText,
    int time = 3,
    List<PageRouteInfo>? children,
  }) : super(
          SuccessScreenRouter.name,
          args: SuccessScreenRouterArgs(
            key: key,
            onSuccess: onSuccess,
            onActionButton: onActionButton,
            primaryText: primaryText,
            secondaryText: secondaryText,
            specialTextWidget: specialTextWidget,
            bottomWidget: bottomWidget,
            showActionButton: showActionButton,
            showProgressBar: showProgressBar,
            showShareButton: showShareButton,
            showPrimaryButton: showPrimaryButton,
            buttonText: buttonText,
            time: time,
          ),
          initialChildren: children,
        );

  static const String name = 'SuccessScreenRouter';

  static const PageInfo<SuccessScreenRouterArgs> page =
      PageInfo<SuccessScreenRouterArgs>(name);
}

class SuccessScreenRouterArgs {
  const SuccessScreenRouterArgs({
    this.key,
    this.onSuccess,
    this.onActionButton,
    this.primaryText,
    this.secondaryText,
    this.specialTextWidget,
    this.bottomWidget,
    this.showActionButton = false,
    this.showProgressBar = false,
    this.showShareButton = false,
    this.showPrimaryButton = false,
    this.buttonText,
    this.time = 3,
  });

  final Key? key;

  final dynamic Function(BuildContext)? onSuccess;

  final dynamic Function()? onActionButton;

  final String? primaryText;

  final String? secondaryText;

  final Widget? specialTextWidget;

  final Widget? bottomWidget;

  final bool showActionButton;

  final bool showProgressBar;

  final bool showShareButton;

  final bool showPrimaryButton;

  final String? buttonText;

  final int time;

  @override
  String toString() {
    return 'SuccessScreenRouterArgs{key: $key, onSuccess: $onSuccess, onActionButton: $onActionButton, primaryText: $primaryText, secondaryText: $secondaryText, specialTextWidget: $specialTextWidget, bottomWidget: $bottomWidget, showActionButton: $showActionButton, showProgressBar: $showProgressBar, showShareButton: $showShareButton, showPrimaryButton: $showPrimaryButton, buttonText: $buttonText, time: $time}';
  }
}

/// generated route for
/// [VerifyingScreen]
class VerifyingScreenRouter extends PageRouteInfo<VerifyingScreenRouterArgs> {
  VerifyingScreenRouter({
    Key? key,
    required String cardId,
    required dynamic Function() onSuccess,
    List<PageRouteInfo>? children,
  }) : super(
          VerifyingScreenRouter.name,
          args: VerifyingScreenRouterArgs(
            key: key,
            cardId: cardId,
            onSuccess: onSuccess,
          ),
          initialChildren: children,
        );

  static const String name = 'VerifyingScreenRouter';

  static const PageInfo<VerifyingScreenRouterArgs> page =
      PageInfo<VerifyingScreenRouterArgs>(name);
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
    List<PageRouteInfo>? children,
  }) : super(
          SuccessVerifyingScreenRouter.name,
          args: SuccessVerifyingScreenRouterArgs(
            key: key,
            onSuccess: onSuccess,
          ),
          initialChildren: children,
        );

  static const String name = 'SuccessVerifyingScreenRouter';

  static const PageInfo<SuccessVerifyingScreenRouterArgs> page =
      PageInfo<SuccessVerifyingScreenRouterArgs>(name);
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
/// [InfoWebView]
class InfoWebViewRouter extends PageRouteInfo<InfoWebViewRouterArgs> {
  InfoWebViewRouter({
    Key? key,
    required String link,
    required String title,
    List<PageRouteInfo>? children,
  }) : super(
          InfoWebViewRouter.name,
          args: InfoWebViewRouterArgs(
            key: key,
            link: link,
            title: title,
          ),
          initialChildren: children,
        );

  static const String name = 'InfoWebViewRouter';

  static const PageInfo<InfoWebViewRouterArgs> page =
      PageInfo<InfoWebViewRouterArgs>(name);
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
/// [GiftReceiversDetailsScreen]
class GiftReceiversDetailsRouter extends PageRouteInfo<void> {
  const GiftReceiversDetailsRouter({List<PageRouteInfo>? children})
      : super(
          GiftReceiversDetailsRouter.name,
          initialChildren: children,
        );

  static const String name = 'GiftReceiversDetailsRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}
