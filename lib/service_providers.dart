import 'package:dio/dio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth/screens/sign_in_up/provider/auth_model_notipod.dart';
import 'service/services/authentication/service/authentication_service.dart';
import 'service/services/blockchain/service/blockchain_service.dart';
import 'service/services/chart/service/chart_service.dart';
import 'service/services/info/service/info_service.dart';
import 'service/services/notification/service/notification_service.dart';
import 'service/services/signal_r/service/signal_r_service.dart';
import 'service/services/swap/service/swap_service.dart';
import 'service/services/validation/service/validation_service.dart';
import 'service/services/wallet/service/wallet_service.dart';
import 'shared/dio/basic_dio.dart';
import 'shared/dio/dio_without_interceptors.dart';
import 'shared/services/dynamic_link_service.dart';
import 'shared/services/local_storage_service.dart';
import 'shared/services/rsa_service.dart';

final intlPod = ScopedProvider<AppLocalizations>(null);

final signalRServicePod = Provider<SignalRService>((ref) {
  return SignalRService(ref.read);
});

final dioPod = Provider<Dio>((ref) {
  final authModel = ref.watch(authModelNotipod);

  return basicDio(authModel, ref.read);
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
