import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/apps_flyer_service.dart';
import 'package:jetwallet/core/services/credentials_service/credentials_service.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/auth/single_sign_in/models/single_sing_in_union.dart';
import 'package:jetwallet/utils/helpers/current_platform.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/auth_api/models/start_email_login/start_email_login_request_model.dart';
import 'package:simple_networking/modules/logs_api/models/add_log_model.dart';

part 'single_sing_in_store.g.dart';

class SingleSingInStore extends _SingleSingInStoreBase with _$SingleSingInStore {
  SingleSingInStore(super.email);

  static _SingleSingInStoreBase of(BuildContext context) => Provider.of<SingleSingInStore>(context, listen: false);
}

abstract class _SingleSingInStoreBase with Store {
  _SingleSingInStoreBase(this.email) {
    emailController = TextEditingController(text: email);
  }

  final String? email;

  static final _logger = getIt.get<SimpleLoggerService>();

  final loader = StackLoaderStore();

  late TextEditingController emailController;

  @observable
  SingleSingInStateUnion union = const SingleSingInStateUnion.input();

  @observable
  bool isEmailError = false;

  @action
  bool setIsEmailError(bool value) => isEmailError = value;

  @action
  Future<void> singleSingIn() async {
    var step = 0;

    try {
      ///
      /// Logs - 0
      ///
      _logger.log(
        level: Level.info,
        place: 'Sign in',
        message: 'singleSingIn',
      );

      if (union is Loading) {
        _logger.log(
          level: Level.info,
          place: 'Sign in',
          message: 'union = $union',
        );
        return;
      }

      _logger.log(
        level: Level.info,
        place: 'Sign in',
        message: 'skip union',
      );

      /// ------

      ///
      /// sDeviceInfo - 1
      ///
      DeviceInfo? deviceInfoModel;
      try {
        step = 1;
        deviceInfoModel = sDeviceInfo;

        _logger.log(
          level: Level.info,
          place: 'Sign in',
          message: deviceInfoModel.toString(),
        );
      } catch (e, stackTrace) {
        unawaited(
          serverLog(step, e, stackTrace),
        );
      }

      /// ------

      ///
      /// AppsFlyerService - 2
      ///
      var appsFlyerID = '';
      try {
        step = 2;
        final appsFlyerService = getIt.get<AppsFlyerService>();

        _logger.log(
          level: Level.info,
          place: 'Sign in',
          message: appsFlyerService.toString(),
        );

        appsFlyerID = await appsFlyerService.appsflyerSdk.getAppsFlyerUID() ?? '';

        _logger.log(
          level: Level.info,
          place: 'Sign in',
          message: appsFlyerID,
        );
      } catch (e, stackTrace) {
        unawaited(
          serverLog(step, e, stackTrace),
        );
      }

      /// ------

      ///
      /// AppStore - 3
      ///
      AppStore? authInfoN;
      try {
        step = 3;
        authInfoN = getIt.get<AppStore>();

        _logger.log(
          level: Level.info,
          place: 'Sign in',
          message: authInfoN.toString(),
        );
      } catch (e, stackTrace) {
        unawaited(
          serverLog(step, e, stackTrace),
        );
      }

      /// ------

      ///
      /// CredentialsService - 4
      ///
      CredentialsService? credentials;
      try {
        step = 4;
        credentials = getIt.get<CredentialsService>();

        _logger.log(
          level: Level.info,
          place: 'Sign in',
          message: credentials.toString(),
        );
      } catch (e, stackTrace) {
        unawaited(
          serverLog(step, e, stackTrace),
        );
      }

      /// ------

      union = const SingleSingInStateUnion.loading();

      _logger.log(
        level: Level.info,
        place: 'Sign in',
        message: union.toString(),
      );

      var advID = '';
      //String _advertisingId = 'Unknown';
      var adId = '';

      ///
      /// AppTrackingTransparency - 5
      ///
      try {
        step = 5;
        advID = await AppTrackingTransparency.getAdvertisingIdentifier();
        _logger.log(
          level: Level.info,
          place: 'Sign in',
          message: 'advID $advID',
        );
        //_advertisingId = await FlutterAdvertisingId.advertisingId;
        adId = sDeviceInfo.deviceUid;

        _logger.log(
          level: Level.info,
          place: 'Sign in',
          message: 'adId $adId',
        );
      } catch (e, stackTrace) {
        unawaited(
          serverLog(step, e, stackTrace),
        );

        advID = '';
        //_advertisingId = '';
        adId = '';

        _logger.log(
          level: Level.info,
          place: 'Sign in',
          message: e.toString(),
        );
      }

      /// ------

      ///
      /// postStartEmailLogin - 6
      ///
      step = 6;
      if (credentials != null && deviceInfoModel != null && authInfoN != null) {
        final model = StartEmailLoginRequestModel(
          email: credentials.email,
          platform: currentPlatform,
          deviceUid: deviceInfoModel.deviceUid,
          lang: intl.localeName,
          application: currentAppPlatform,
          appsflyerId: appsFlyerID,
          //adid: _advertisingId,
          idfv: adId,
          idfa: advID,
        );

        _logger.log(
          level: Level.info,
          place: 'Sign in',
          message: model.toString(),
        );

        final response =
            await getIt.get<SNetwork>().simpleNetworkingUnathorized.getAuthModule().postStartEmailLogin(model);
        sAnalytics.updateUserId(credentials.email);

        _logger.log(
          level: Level.info,
          place: 'Sign in',
          message: response.toString(),
        );

        response.pick(
          onData: (data) {
            _logger.log(
              level: Level.info,
              place: 'Sign in',
              message: 'in onData',
            );

            authInfoN!.updateAuthState(email: credentials!.email);
            _logger.log(
              level: Level.info,
              place: 'Sign in',
              message: 'after updateAuthState',
            );
            authInfoN.updateVerificationToken(data.verificationToken);

            _logger.log(
              level: Level.info,
              place: 'Sign in',
              message: 'after updateVerificationToken',
            );

            data.rejectDetail == null
                ? union = const SingleSingInStateUnion.success()
                : union = SingleSingInStateUnion.errorString(
                    data.rejectDetail.toString(),
                  );

            _logger.log(
              level: Level.info,
              place: 'Sign in',
              message: 'union = $union',
            );

            credentials.clearData();

            _logger.log(
              level: Level.info,
              place: 'Sign in',
              message: 'after clearData',
            );
          },
          onError: (error) {
            _logger.log(
              level: Level.info,
              place: 'singleSingIn',
              message: error.cause,
            );

            union = SingleSingInStateUnion.errorString(
              error.cause,
            );

            unawaited(
              serverLog(step, error, StackTrace.empty),
            );
          },
        );
      } else {
        union = SingleSingInStateUnion.error('${intl.something_went_wrong_try_again} ($step)');
      }
    } on ServerRejectException catch (error, stackTrace) {
      _logger.log(
        level: Level.info,
        place: 'singleSingIn',
        message: error.cause,
      );

      union = error.cause.contains('50') || error.cause.contains('40')
          ? SingleSingInStateUnion.error('${intl.something_went_wrong_try_again} ($step)')
          : SingleSingInStateUnion.error(error.cause);

      unawaited(
        serverLog(step, error, stackTrace),
      );
    } catch (e, stackTrace) {
      _logger.log(
        level: Level.info,
        place: 'singleSingIn',
        message: e.toString(),
      );

      union = e.toString().contains('50') || e.toString().contains('40')
          ? SingleSingInStateUnion.error('${intl.something_went_wrong_try_again} ($step)')
          : SingleSingInStateUnion.error('${intl.something_went_wrong} ($step)');

      unawaited(
        serverLog(step, e, stackTrace),
      );
    }
  }

  Future<void> serverLog(int step, Object e, StackTrace stackTrace) async {
    unawaited(
      getIt.get<SNetwork>().simpleNetworkingUnathorized.getLogsApiModule().postAddLog(
            AddLogModel(
              level: 'error',
              message: 'SignIn: step: $step,  exception: $e, stackTrace: $stackTrace',
              source: 'SignIn',
              process: 'signIn email',
              token: await getIt.get<LocalStorageService>().getValue(refreshTokenKey),
            ),
          ),
    );
  }

  @action
  void dispose() {
    emailController.dispose();
  }
}
