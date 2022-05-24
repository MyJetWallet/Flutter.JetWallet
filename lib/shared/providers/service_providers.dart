import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/authentication/service/authentication_service.dart';
import 'package:simple_networking/services/blockchain/service/blockchain_service.dart';
import 'package:simple_networking/services/change_password/service/change_password_service.dart';
import 'package:simple_networking/services/chart/service/chart_service.dart';
import 'package:simple_networking/services/circle/service/circle_service.dart';
import 'package:simple_networking/services/disclaimer/service/disclaimers_service.dart';
import 'package:simple_networking/services/info/service/info_service.dart';
import 'package:simple_networking/services/key_value/key_value_service.dart';
import 'package:simple_networking/services/kyc/service/kyc_service.dart';
import 'package:simple_networking/services/kyc_documents/kyc_documents_service.dart';
import 'package:simple_networking/services/market_info/market_info_service.dart';
import 'package:simple_networking/services/market_news/market_news_service.dart';
import 'package:simple_networking/services/news/news_service.dart';
import 'package:simple_networking/services/notification/service/notification_service.dart';
import 'package:simple_networking/services/operation_history/operation_history_service.dart';
import 'package:simple_networking/services/phone_verification/service/phone_verification_service.dart';
import 'package:simple_networking/services/profile/service/profile_service.dart';
import 'package:simple_networking/services/recurring_manage/recurring_manage_service.dart';
import 'package:simple_networking/services/referral_code_service/service/referral_code_service.dart';
import 'package:simple_networking/services/signal_r/service/signal_r_service.dart';
import 'package:simple_networking/services/simplex/service/simplex_service.dart';
import 'package:simple_networking/services/swap/service/swap_service.dart';
import 'package:simple_networking/services/transfer/service/transfer_service.dart';
import 'package:simple_networking/services/two_fa/service/two_fa_service.dart';
import 'package:simple_networking/services/validation/service/validation_service.dart';
import 'package:simple_networking/services/wallet/service/wallet_service.dart';

import '../../app/shared/features/kyc/helper/kyc_alert_handler.dart';
import '../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../dio/basic_dio.dart';
import '../dio/dio_without_interceptors.dart';
import '../dio/image_dio.dart';
import '../helpers/refresh_token.dart';
import '../services/dynamic_link_service.dart';
import '../services/local_storage_service.dart';
import '../services/rsa_service.dart';
import 'device_info_pod.dart';
import 'device_size/media_query_pod.dart';
import 'package_info_fpod.dart';

final intlPod = Provider<AppLocalizations>((ref) {
  final key = ref.watch(sNavigatorKeyPod);

  return AppLocalizations.of(key.currentContext!)!;
});

final signalRServicePod = Provider<SignalRService>((ref) {
  final mediaQuery = ref.read(mediaQueryPod);

  return SignalRService(
    ref.read,
    refreshToken,
    ref.read(authInfoNotipod).token,
    ref.read(intlPod).localeName,
    ref.read(deviceInfoPod).deviceUid,
    ref.read(packageInfoPod).version,
    mediaQuery.size,
    mediaQuery.devicePixelRatio,
  );
});

final dioPod = Provider<Dio>((ref) {
  final authInfo = ref.watch(authInfoNotipod);

  return basicDio(authInfo, ref.read);
});

final dioWithoutInterceptorsPod = Provider<Dio>((ref) {
  return dioWithoutInterceptors(ref.read);
});

final imageDioPod = Provider<Dio>((ref) {
  final authInfo = ref.watch(authInfoNotipod);

  return imageDio(authInfo, ref.read);
});

final authServicePod = Provider<AuthenticationService>((ref) {
  final dio = ref.watch(dioWithoutInterceptorsPod);

  return AuthenticationService(dio);
});

final localStorageServicePod = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final blockchainServicePod = Provider<BlockchainService>((ref) {
  final dio = ref.watch(dioPod);

  return BlockchainService(dio);
});

final swapServicePod = Provider<SwapService>((ref) {
  final dio = ref.watch(dioPod);

  return SwapService(dio);
});

final chartServicePod = Provider<ChartService>((ref) {
  final dio = ref.watch(dioPod);

  return ChartService(dio);
});

final walletServicePod = Provider<WalletService>((ref) {
  final dio = ref.watch(dioPod);

  return WalletService(dio);
});

final notificationServicePod = Provider<NotificationService>((ref) {
  final dio = ref.watch(dioPod);

  return NotificationService(dio);
});

final dynamicLinkServicePod = Provider<DynamicLinkService>((ref) {
  return DynamicLinkService();
});

final validationServicePod = Provider<ValidationService>((ref) {
  final dio = ref.watch(dioPod);

  return ValidationService(dio);
});

final infoServicePod = Provider<InfoService>((ref) {
  final dio = ref.watch(dioPod);

  return InfoService(dio);
});

final rsaServicePod = Provider<RsaService>((ref) {
  return RsaService();
});

final marketInfoServicePod = Provider<MarketInfoService>((ref) {
  final dio = ref.watch(dioPod);

  return MarketInfoService(dio);
});

final keyValueServicePod = Provider<KeyValueService>((ref) {
  final dio = ref.watch(dioPod);

  return KeyValueService(dio);
});

final marketNewsServicePod = Provider<MarketNewsService>((ref) {
  final dio = ref.watch(dioPod);

  return MarketNewsService(dio);
});

final newsServicePod = Provider<NewsService>((ref) {
  final dio = ref.watch(dioPod);

  return NewsService(dio);
});

final operationHistoryServicePod = Provider<OperationHistoryService>((ref) {
  final dio = ref.watch(dioPod);

  return OperationHistoryService(dio);
});

final twoFaServicePod = Provider<TwoFaService>((ref) {
  final dio = ref.watch(dioPod);

  return TwoFaService(dio);
});

final phoneVerificationServicePod = Provider<PhoneVerificationService>((ref) {
  final dio = ref.watch(dioPod);

  return PhoneVerificationService(dio);
});

final transferServicePod = Provider<TransferService>((ref) {
  final dio = ref.watch(dioPod);

  return TransferService(dio);
});

final profileServicePod = Provider<ProfileService>((ref) {
  final dio = ref.watch(dioPod);

  return ProfileService(dio);
});

final kycAlertHandlerPod =
    Provider.family<KycAlertHandler, BuildContext>((ref, context) {
  final colors = ref.read(sColorPod);

  return KycAlertHandler(context: context, colors: colors);
});

final kycServicePod = Provider<KycService>((ref) {
  final dio = ref.watch(dioPod);

  return KycService(dio);
});

final kycDocumentsServicePod = Provider<KycDocumentsService>((ref) {
  final dio = ref.watch(imageDioPod);

  return KycDocumentsService(dio);
});

final changePasswordSerivcePod = Provider<ChangePasswordService>((ref) {
  final dio = ref.watch(dioPod);

  return ChangePasswordService(dio);
});

final circleServicePod = Provider<CircleService>(
  (ref) {
    final dio = ref.watch(dioPod);

    return CircleService(dio);
  },
  name: 'circleServicePod',
);

final simplexServicePod = Provider<SimplexService>(
  (ref) {
    final dio = ref.watch(dioPod);

    return SimplexService(dio);
  },
  name: 'simplexServicePod',
);

final referralCodeServicePod = Provider<ReferralCodeService>((ref) {
  final dio = ref.watch(dioPod);

  return ReferralCodeService(dio);
});

final recurringManageServicePod = Provider<RecurringManageService>((ref) {
  final dio = ref.watch(dioPod);

  return RecurringManageService(dio);
});

final disclaimerServicePod = Provider<DisclaimersService>((ref) {
  final dio = ref.watch(dioPod);

  return DisclaimersService(dio);
});
