class EventType {
  /// User visits onboarding screen
  static const onboardingView = 'Onboarding view';

  /// User visits sign up page
  static const signUpView = 'Sign up view';
  static const signUpSuccess = 'Sign up';
  static const signUpFailure = 'Sign up failed';

  /// User visits email verification page
  static const emailVerificationView = 'Sign up - email verification';

  /// User successfully confirmed email be entering verification code
  static const emailConfirmed = 'Sign up - email confirmed';

  /// User visits login page
  static const loginView = 'Login view';
  static const loginSuccess = 'Login';
  static const loginFailure = 'Login failed';

  /// User visits Asset details screen with Chart/About....
  static const assetView = 'Asset View';

  /// User visits Earn program screen (all assets + APY)
  static const earnProgramView = 'Earn program - Portfolio home screen';

  /// Logout action
  static const logout = 'Logout';
}
