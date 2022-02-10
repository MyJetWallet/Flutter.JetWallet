import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

import 'helpers/hash_string.dart';
import 'models/event_type.dart';
import 'models/property_type.dart';
import 'models/source.dart';
import 'models/user_type.dart';

final sAnalytics = SimpleAnalytics();

class SimpleAnalytics {
  factory SimpleAnalytics() => _instance;

  SimpleAnalytics._internal();

  static final SimpleAnalytics _instance = SimpleAnalytics._internal();

  final _analytics = Amplitude.getInstance();

  /// Run at the start of the app
  ///
  /// Provide:
  /// 1. environmentKey for Amplitude workspace
  /// 2. userEmail if user is already authenticated
  Future<void> init(String environmentKey, [String? userEmail]) async {
    await _analytics.init(environmentKey);

    if (userEmail != null) {
      await _analytics.setUserId(hashString(userEmail));
    }
  }

  Future<void> onboardingView() async {
    await _analytics.logEvent(EventType.onboardingView);
  }

  Future<void> signUpView() async {
    await _analytics.logEvent(EventType.signUpView);
  }

  Future<void> signUpSuccess(String userEmail) async {
    await _analytics.setUserId(hashString(userEmail));

    final identify = Identify()
      ..setOnce(UserType.signUpDate, '${DateTime.now()}')
      ..set(UserType.kycStatus, 'Unknown');

    await _analytics.identify(identify);
    await _analytics.logEvent(EventType.signUpSuccess);
  }

  Future<void> signUpFailure(String userEmail, String error) async {
    await _analytics.logEvent(
      EventType.signUpFailure,
      eventProperties: {
        PropertyType.error: error,
        PropertyType.email: userEmail,
        PropertyType.id: hashString(userEmail),
      },
    );
  }

  Future<void> emailVerificationView() async {
    await _analytics.logEvent(EventType.emailVerificationView);
  }

  Future<void> emailConfirmed() async {
    await _analytics.logEvent(EventType.emailConfirmed);
  }

  Future<void> loginView() async {
    await _analytics.logEvent(EventType.loginView);
  }

  Future<void> loginSuccess(String userEmail) async {
    await _analytics.setUserId(hashString(userEmail));

    await _analytics.logEvent(EventType.loginSuccess);
  }

  Future<void> loginFailure(String userEmail, String error) async {
    await _analytics.logEvent(
      EventType.loginFailure,
      eventProperties: {
        PropertyType.error: error,
        PropertyType.email: userEmail,
        PropertyType.id: hashString(userEmail),
      },
    );
  }

  /// Full name must be provided e.g. Bitcoin, and not BTC (ticker)
  Future<void> assetView(String assetName) async {
    await _analytics.logEvent(
      EventType.assetView,
      eventProperties: {
        PropertyType.assetName: assetName,
      },
    );
  }

  Future<void> portfolioView(Source source) async {
    await _analytics.logEvent(
      EventType.assetView,
      eventProperties: {
        PropertyType.sourceScreen: source.name,
      },
    );
  }

  /// Call when user makes logout.
  /// It will clean unique userId and will generate deviceId, 
  /// so the user will appear as a brand new one.
  Future<void> logout() async {
    await _analytics.setUserId(null);
    await _analytics.regenerateDeviceId();
    await _analytics.logEvent(EventType.logout);
  }
}
