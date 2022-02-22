class EventType {
  /// User visits onboarding screen
  static const onboardingView = 'Onboarding view';

  /// User visits sign up page
  static const signUpView = 'Sign up view';
  static const signUpSuccess = 'Sign up';
  static const signUpFailure = 'Sign up failed';

  /// User visits email verification page
  static const emailVerificationView = 'Sign up - email verification view';

  /// User successfully confirmed email be entering verification code
  static const emailConfirmed = 'Sign up - email confirmed';

  /// User visits login page
  static const loginView = 'Login view';
  static const loginSuccess = 'Login';
  static const loginFailure = 'Login failed';

  /// User visits Asset details screen with Chart/About....
  static const assetView = 'Asset View';

  /// User visits Earn program screen (all assets + APY)
  static const earnProgramView = 'Earn program view';

  /// Logout action
  static const logout = 'Logout';

  /// Places where we call kyc popup
  static const kycVerifyProfile = 'KYC - Verify your profile';

  /// Change country code, send country name
  static const changeCountryCode = 'Change country code';

  /// Choose country name and document type in kyc
  static const identityParametersChoosed = 'Identity parameters choosed';

  /// Market filters
  static const marketFilters = 'Filters';

  /// Add asset to watchlist
  static const addToWatchlist = 'Add to watchlist';

  /// Click on market banner, close-open, campaign name
  static const clickMarketBanner = 'Market banner click';

  /// Rewards screen view
  static const rewardsScreenView = 'Rewards screen view';

  static const inviteFriendView = 'Invite friend view';

  static const buySellView = 'Buy / Sell view';
}
