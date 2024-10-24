// AppConfig
import 'package:simple_networking/modules/remote_config/models/rewards_asset_model.dart';

late int emailVerificationCodeLength;
late int phoneVerificationCodeLength;
late String userAgreementLink;
late String privacyPolicyLink;
late String referralPolicyLink;
late String nftTermsLink;
late String nftPolicyLink;
late String simpleCompanyName;
late String simpleCompanyAddress;
late String refundPolicyLink;
late String infoRewardsLink;
late String infoEarnLink;
late String amlKycPolicyLink;
late int paymentDelayDays;
late String privacyEarnLink;
late int minAmountOfCharsInPassword;
late int maxAmountOfCharsInPassword;
late int quoteRetryInterval;
late String defaultAssetIcon;
late int emailResendCountdown;
late int withdrawalConfirmResendCountdown;
late int localPinLength;
late int maxPinAttempts;
late int forgotPasswordLockHours;
late int changePasswordLockHours;
late int changePhoneLockHours;
late String cardLimitsLearnMoreLink;
late String p2pTerms;
late String jarTerms;
bool rateUp = true;
String prepaidCardPartnerLink = '';
String prepaidCardTermsAndConditionsLink = '';
String simpleCoinDisclaimerLink = '';
String simpleTapLink = '';
bool usePhoneForSendGift = true;
int simpleCoinRoadmapCompletedSteep = 3;
List<RewardsAssetModel> rewardsAssets = [];
bool showPhoneNumberStep = false;

// Versioning
late String recommendedVersion;
late String minimumVersion;

// Support
late String faqLink;
late String crispWebsiteId;

// Analytics
late String analyticsApiKey;
late List<String> amplitudeAllowCountryList;

// Simplex
late String simplexOrigin;

// AppsFlyer
late String appsFlyerKey;
late String iosAppId;
late String androidAppId;

// Circle
late bool cvvEnabled;

// NFT
late String shortUrl;
late String fullUrl;
late String shareLink;

//MerchantPay
late String displayName;
late List<String> merchantCapabilities;
late List<String> supportedNetworks;
late String countryCode;

//Sift
late String siftBeaconKey;
late String siftAccountId;

//Support
late bool showZendesk;
late String zendeskIOS;
late String zendeskAndroid;

late String iconApi;
