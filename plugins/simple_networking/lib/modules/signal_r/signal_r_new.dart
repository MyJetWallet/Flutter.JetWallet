import 'dart:async';

//import 'package:signalr_netcore/ihub_protocol.dart';
//import 'package:signalr_netcore/signalr_client.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart' as lg;

import 'package:simple_networking/config/constants.dart';
import 'package:simple_networking/config/options.dart';
import 'package:simple_networking/helpers/device_type.dart';
import 'package:simple_networking/helpers/models/refresh_token_status.dart';

import 'package:simple_networking/modules/signal_r/signal_r_func_handler.dart';
import 'package:simple_networking/modules/signal_r/signal_r_transport.dart';

import 'package:signalr_core/signalr_core.dart';

class SignalRModuleNew {
  SignalRModuleNew({
    required this.transport,
    required this.options,
    required this.refreshToken,
    required this.localeName,
    required this.deviceUid,
    required this.log,
    required this.getToken,
    required this.signalRClient,
    required this.forceReconnect,
    required this.getUrlForConnectin,
    this.isDebug = false,
  }) {
    handler = SignalRFuncHandler(
      sTransport: transport,
      instance: this,
    );
  }

  late SignalRFuncHandler handler;

  final SignalRTransport transport;
  final SimpleOptions options;
  final Future<RefreshTokenStatus> Function() refreshToken;
  final String localeName;
  final String deviceUid;
  final BaseClient signalRClient;
  final Function() forceReconnect;

  final bool isDebug;
  final Function({
    required lg.Level level,
    required String message,
    required String place,
  }) log;

  final Future<String> Function() getToken;

  final String Function() getUrlForConnectin;

  static const _pingTime = 3;
  static const _reconnectTime = 5;

  final _loggerValue = 'SignalR';

  Timer? _pongTimer;
  Timer? _pingTimer;
  Timer? _reconnectTimer;

  Timer? _checkConnectionTimer;
  static const _checkConnectionTime = 6;
  int connectionCheckCount = 0;

  HubConnectionState get hubStatus => _hubConnection?.state ?? HubConnectionState.disconnected;

  //HubConnection? _hubConnection;
  HubConnection? _hubConnection;

  /// Is Module Disconnecting
  bool isDisconnecting = false;

  bool isSignalRRestarted = false;
  bool isServiceDisposed = false;

  String? connectionId;

  void logMsg(String msg) {
    if (msg.contains('sending data')) {
      log(
        level: lg.Level.warning,
        place: _loggerValue,
        message: 'SignalR $msg',
      );
    }
  }

  Future<void> checkConnectionTimer() async {
    if (isServiceDisposed) return;

    _checkConnectionTimer = Timer.periodic(
      const Duration(seconds: _checkConnectionTime),
      (timer) {
        if (_hubConnection?.state == HubConnectionState.connected) {
          connectionCheckCount = 0;
        } else {
          connectionCheckCount++;
        }

        if (connectionCheckCount != 0) {
          log(
            level: lg.Level.info,
            place: _loggerValue,
            message: 'Check connection TIMER count: $connectionCheckCount, status: ${_hubConnection?.state}',
          );
        }

        if (connectionCheckCount >= 3) {
          log(
            level: lg.Level.error,
            place: _loggerValue,
            message: 'SignalR force reconnect',
          );

          timer.cancel();
          forceReconnect();
        }
      },
    );
  }

  Future<bool> openConnection() async {
    log(
      level: lg.Level.warning,
      place: _loggerValue,
      message: 'SignalR state: ${_hubConnection?.state} \n isSignalRRestarted: $isSignalRRestarted',
    );

    if (isSignalRRestarted) return false;
    if (isServiceDisposed) return false;

    isSignalRRestarted = true;

    transport.createNewSessionLog();

    await disconnectSocket('From openConnection');

    try {
      final url = getUrlForConnectin();
      _hubConnection = HubConnectionBuilder()
          .withUrl(
            url,
            HttpConnectionOptions(
              client: signalRClient,
              logMessageContent: true,
            ),
          )
          .build();

      await setupMessageHandler();

      await _hubConnection!.start();

      connectionId = _hubConnection?.connectionId;

      await sendInitMessage('New Session');

      _startPing();
      _startPong();
    } catch (e) {
      log(
        level: lg.Level.error,
        place: _loggerValue,
        message: 'SignalR error on openConnection $e',
      );

      _startReconnect();
    }

    isSignalRRestarted = false;
    isDisconnecting = false;

    return true;
  }

  Future<void> sendInitMessage(String from) async {
    if (_hubConnection?.state == HubConnectionState.connected) {
      try {
        final token = await getToken();

        log(
          level: lg.Level.info,
          place: _loggerValue,
          message: 'SignalR init message: $from \n With Token: $token',
        );

        await _hubConnection?.invoke(
          initMessage,
          args: [
            token,
            localeName,
            deviceUid,
            deviceType,
          ],
        );

        log(
          level: lg.Level.info,
          place: _loggerValue,
          message: 'Sucsses SignalR init from: $from',
        );
      } catch (e) {
        handleError('invoke $e', e);
      }
    } else {
      log(
        level: lg.Level.error,
        place: _loggerValue,
        message: 'SignalR error init ${_hubConnection?.state}',
      );

      transport.addToLog(
        DateTime.now(),
        'SignalR error init ${_hubConnection?.state}',
      );
    }
  }

  static Future<void> handlePackage() async {}

  void handleError(String msg, Object error) {
    log(
      level: lg.Level.error,
      place: _loggerValue,
      message: msg,
    );

    transport.addToLog(DateTime.now(), 'SignalR error $error');
  }

  Future<void> simulateError() async {
    await _hubConnection?.stop();
  }

  void _startPing() {
    _pingTimer = Timer.periodic(
      const Duration(seconds: _pingTime),
      (_) async {
        if (_hubConnection?.state == HubConnectionState.connected) {
          try {
            transport.addToPing(DateTime.now());

            await _hubConnection?.invoke(pingMessage);
          } catch (e) {
            transport.addToLog(DateTime.now(), 'Failed to send ping ${_hubConnection?.state}');
            log(
              level: lg.Level.error,
              place: _loggerValue,
              message: 'Failed to send ping ${_hubConnection?.state}',
            );
          }
        } else {
          transport.addToLog(DateTime.now(), 'Failed to send ping ${_hubConnection?.state}');
          log(
            level: lg.Level.error,
            place: _loggerValue,
            message: 'Failed to send ping ${_hubConnection?.state}',
          );
        }
      },
    );
  }

  void pongMessageHandler(List<Object?>? data) {
    log(
      level: lg.Level.info,
      place: _loggerValue,
      message: 'Pong Message Handler',
    );
    transport.addToPong(DateTime.now());

    _pongTimer?.cancel();
    _startPong();
  }

  void _startPong() {
    _pongTimer = Timer(
      const Duration(seconds: _pingTime * 3),
      () {
        transport.addToLog(DateTime.now(), 'Start pong reconnect');
        log(
          level: lg.Level.info,
          place: _loggerValue,
          message: 'Start pong reconnect',
        );

        if (isServiceDisposed) return;

        _startReconnect();
      },
    );
  }

  void _startReconnect() {
    if (_reconnectTimer == null || !_reconnectTimer!.isActive) {
      _reconnectTimer = Timer(
        const Duration(seconds: _reconnectTime),
        () {
          openConnection();
        },
      );
    }
  }

  Future<void> disconnectSocket(String from) async {
    try {
      if (_hubConnection == null) return;

      log(
        level: lg.Level.warning,
        place: _loggerValue,
        message: 'SignalR Disconnect $from',
      );
      transport.addToLog(DateTime.now(), 'SignalR Disconnect $from');

      isDisconnecting = true;
      isSignalRRestarted = false;

      _pingTimer?.cancel();
      _pongTimer?.cancel();
      _reconnectTimer?.cancel();

      _pingTimer = null;
      _pongTimer = null;
      _reconnectTimer = null;

      await _hubConnection?.stop();

      await disableHandlerConnection();

      _hubConnection = null;

      log(
        level: lg.Level.error,
        place: _loggerValue,
        message: 'SignalR is Disconnected.',
      );
    } catch (e) {
      log(
        level: lg.Level.error,
        place: _loggerValue,
        message: 'SignalR error on disconnectSocket $e',
      );
    }
  }

  void dispose() {
    isServiceDisposed = true;

    disableHandlerConnection();

    _hubConnection?.stop();

    _hubConnection = null;

    _pingTimer?.cancel();
    _pongTimer?.cancel();
    _reconnectTimer?.cancel();
    _checkConnectionTimer?.cancel();
    connectionCheckCount = 0;
  }

  Future<void> disableHandlerConnection() async {
    log(
      level: lg.Level.info,
      place: _loggerValue,
      message: 'Disable Handler Connection',
    );

    _hubConnection?.off(initFinished, method: handler.initFinishedHandler);
    _hubConnection?.off(cardsMessage, method: handler.cardsMessageHandler);
    _hubConnection?.off(
      cardLimitsMessage,
      method: handler.cardLimitsMessageHandler,
    );
    _hubConnection?.off(
      kycCountriesMessage,
      method: handler.kycCountriesMessageHandler,
    );
    _hubConnection?.off(
      marketInfoMessage,
      method: handler.marketInfoMessageHandler,
    );
    _hubConnection?.off(
      campaignsBannersMessage,
      method: handler.campaignsBannersMessageHandler,
    );
    _hubConnection?.off(
      referralStatsMessage,
      method: handler.referralStatsMessageHandler,
    );
    _hubConnection?.off(assetsMessage, method: handler.assetsMessageHandler);
    _hubConnection?.off(
      balancesMessage,
      method: handler.balancesMessageHandler,
    );
    _hubConnection?.off(
      blockchainsMessage,
      method: handler.blockchainsMessageHandler,
    );
    _hubConnection?.off(
      marketReferenceMessage,
      method: handler.marketReferenceMessageHandler,
    );
    _hubConnection?.off(
      basePricesMessage,
      method: handler.basePricesMessageHandler,
    );
    _hubConnection?.off(
      periodPricesMessage,
      method: handler.periodPricesMessageHandler,
    );
    _hubConnection?.off(
      clientDetailMessage,
      method: handler.clientDetailMessageHandler,
    );
    _hubConnection?.off(
      assetWithdrawalFeeMessage,
      method: handler.assetWithdrawalFeeMessageHandler,
    );
    _hubConnection?.off(
      keyValueMessage,
      method: handler.keyValueMessageHandler,
    );
    _hubConnection?.off(indicesMessage, method: handler.indicesMessageHandler);
    _hubConnection?.off(
      convertPriceSettingsMessage,
      method: handler.convertPriceSettingsMessageHandler,
    );
    _hubConnection?.off(
      paymentMethodsNewMessage,
      method: handler.paymentMethodsNewMessageHandler,
    );
    _hubConnection?.off(
      referralInfoMessage,
      method: handler.referralInfoMessageHandler,
    );

    _hubConnection?.off(
      fireblocksMessages,
      method: handler.fireblocksMessagesHandler,
    );
    _hubConnection?.off(pongMessage, method: pongMessageHandler);
    _hubConnection?.off(
      operationHistoryMessages,
      method: handler.operationHistoryHandler,
    );
    _hubConnection?.off(
      globalSendMethods,
      method: handler.globalSendMethodsHandler,
    );
    _hubConnection?.off(
      incomingGiftsMessage,
      method: handler.incomingGiftsHandler,
    );
    _hubConnection?.off(
      rewardsProfileMessage,
      method: handler.rewardsProfileHandler,
    );
    _hubConnection?.off(
      rewardsProfileMessage,
      method: handler.rewardsProfileHandler,
    );

    _hubConnection?.off(
      pendingOperationCountMessage,
      method: handler.pendingOperationCountHandler,
    );

    _hubConnection?.off(
      investAllActivePositionsMessage,
      method: handler.investAllActivePositionsMessageHandler,
    );

    _hubConnection?.off(
      earnOffers,
      method: handler.earnOffersMessageHandler,
    );

    _hubConnection?.off(
      earnPositions,
      method: handler.earnPositionsMessageHandler,
    );

    // Baners
    _hubConnection?.off(
      bannerList,
      method: handler.bannerListMessageHandler,
    );

    _hubConnection?.off(
      marketSectors,
      method: handler.marketSectorsMessageHandler,
    );
  }

  Future<void> setupMessageHandler() async {
    _hubConnection?.on(initFinished, handler.initFinishedHandler);

    _hubConnection?.on(cardsMessage, handler.cardsMessageHandler);

    _hubConnection?.on(cardLimitsMessage, handler.cardLimitsMessageHandler);

    _hubConnection?.on(kycCountriesMessage, handler.kycCountriesMessageHandler);

    _hubConnection?.on(marketInfoMessage, handler.marketInfoMessageHandler);

    _hubConnection?.on(
      campaignsBannersMessage,
      handler.campaignsBannersMessageHandler,
    );

    _hubConnection?.on(
      referralStatsMessage,
      handler.referralStatsMessageHandler,
    );

    _hubConnection?.on(assetsMessage, handler.assetsMessageHandler);

    _hubConnection?.on(balancesMessage, handler.balancesMessageHandler);

    _hubConnection?.on(blockchainsMessage, handler.blockchainsMessageHandler);

    _hubConnection?.on(
      marketReferenceMessage,
      handler.marketReferenceMessageHandler,
    );

    _hubConnection?.on(basePricesMessage, handler.basePricesMessageHandler);

    _hubConnection?.on(periodPricesMessage, handler.periodPricesMessageHandler);

    _hubConnection?.on(clientDetailMessage, handler.clientDetailMessageHandler);

    _hubConnection?.on(
      assetWithdrawalFeeMessage,
      handler.assetWithdrawalFeeMessageHandler,
    );

    _hubConnection?.on(keyValueMessage, handler.keyValueMessageHandler);

    _hubConnection?.on(investAllActivePositionsMessage, handler.investAllActivePositionsMessageHandler);
    _hubConnection?.on(investInstrumentsMessage, handler.investInstrumentsMessageHandler);
    _hubConnection?.on(investPricesMessage, handler.investPricesMessageHandler);
    _hubConnection?.on(investSectorsMessage, handler.investSectorsMessageHandler);
    _hubConnection?.on(investWalletMessage, handler.investWalletMessageHandler);
    _hubConnection?.on(investBaseDailyPricesMessage, handler.investBaseDailyPricesMessageHandler);

    _hubConnection?.on(indicesMessage, handler.indicesMessageHandler);

    _hubConnection?.on(
      convertPriceSettingsMessage,
      handler.convertPriceSettingsMessageHandler,
    );

    _hubConnection?.on(
      paymentMethodsNewMessage,
      handler.paymentMethodsNewMessageHandler,
    );

    _hubConnection?.on(referralInfoMessage, handler.referralInfoMessageHandler);

    _hubConnection?.on(fireblocksMessages, handler.fireblocksMessagesHandler);

    _hubConnection?.on(
      operationHistoryMessages,
      handler.operationHistoryHandler,
    );

    _hubConnection?.on(
      globalSendMethods,
      handler.globalSendMethodsHandler,
    );

    _hubConnection?.on(incomingGiftsMessage, handler.incomingGiftsHandler);

    _hubConnection?.on(
      rewardsProfileMessage,
      handler.rewardsProfileHandler,
    );

    _hubConnection?.on(bankingProfileMessage, handler.bankingProfileHandler);

    _hubConnection?.on(pendingOperationCountMessage, handler.pendingOperationCountHandler);

    // Earn
    _hubConnection?.on(earnOffers, handler.earnOffersMessageHandler);
    _hubConnection?.on(earnPositions, handler.earnPositionsMessageHandler);

    _hubConnection?.on(pongMessage, pongMessageHandler);

    // Baners
    _hubConnection?.on(bannerList, handler.bannerListMessageHandler);

    // Simple Coin
    _hubConnection?.on(smplWalletProfile, handler.smplWalletProfileMessageHandler);

    _hubConnection?.on(marketSectors, handler.marketSectorsMessageHandler);
  }
}
