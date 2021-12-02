import 'package:dio/dio.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/service/services/campaign/campaign_service.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../service/services/authentication/service/authentication_service.dart';
import '../../service/services/blockchain/service/blockchain_service.dart';
import '../../service/services/chart/service/chart_service.dart';
import '../../service/services/info/service/info_service.dart';
import '../../service/services/key_value/key_value_service.dart';
import '../../service/services/market_info/market_info_service.dart';
import '../../service/services/market_news/market_news_service.dart';
import '../../service/services/news/news_service.dart';
import '../../service/services/notification/service/notification_service.dart';
import '../../service/services/operation_history/operation_history_service.dart';
import '../../service/services/phone_verification/service/phone_verification_service.dart';
import '../../service/services/profile/service/profile_service.dart';
import '../../service/services/signal_r/service/signal_r_service.dart';
import '../../service/services/swap/service/swap_service.dart';
import '../../service/services/transfer/service/transfer_service.dart';
import '../../service/services/two_fa/service/two_fa_service.dart';
import '../../service/services/validation/service/validation_service.dart';
import '../../service/services/wallet/service/wallet_service.dart';
import '../dio/basic_dio.dart';
import '../dio/dio_without_interceptors.dart';
import '../services/contact_service.dart';
import '../services/dynamic_link_service.dart';
import '../services/local_storage_service.dart';
import '../services/rsa_service.dart';

final intlPod = Provider<AppLocalizations>((ref) {
  final key = ref.watch(sNavigatorKeyPod);

  return AppLocalizations.of(key.currentContext!)!;
});

final signalRServicePod = Provider<SignalRService>((ref) {
  return SignalRService(ref.read);
});

final dioPod = Provider<Dio>((ref) {
  final authInfo = ref.watch(authInfoNotipod);

  return basicDio(authInfo, ref.read);
});

final dioWithoutInterceptorsPod = Provider<Dio>((ref) {
  return dioWithoutInterceptors();
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

final campaignServicePod = Provider<CampaignService>((ref) {
  final dio = ref.watch(dioPod);

  return CampaignService(dio);
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

final contactsServicePod = Provider<ContactService>((ref) {
  return ContactService();
});

final profileServicePod = Provider<ProfileService>((ref) {
  final dio = ref.watch(dioPod);

  return ProfileService(dio);
});
