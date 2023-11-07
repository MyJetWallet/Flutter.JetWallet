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

    if (isSignalRRestarted) return false;

    isSignalRRestarted = true;

    transport.createNewSessionLog();

    if (_hubConnection == null) {
      _hubConnection = HubConnectionBuilder()
          .withUrl(
            options.walletApiSignalR!,
            HttpConnectionOptions(
              client: signalRClient,
              logMessageContent: true,
            ),
          )
          .build();

      await setupMessageHandler();

      await _hubConnection!.start();

      await sendInitMessage('New Session');

      _startPing();
    } else {
      if (_hubConnection!.state != HubConnectionState.connected) {
        await setupMessageHandler();

        await _hubConnection!.start();

        await sendInitMessage('Reconnect Session');

        _startPing();
      }
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
      } catch (e) {
        handleError('invoke $e', e);

        isSignalRRestarted = false;
        isDisconnecting = true;

        rethrow;
      }
    } else {
      log(
        level: lg.Level.error,
        place: _loggerValue,
        message: 'SignalR error init ${_hubConnection?.state}',
      );

      //isSignalRRestarted = false;
      //isDisconnecting = true;

      transport.addToLog(
        DateTime.now(),
        'SignalR error init ${_hubConnection?.state}',
      );

      if (!isDisconnecting) {
        reconnectSignalR();
      }
    }
  }

  static Future<void> handlePackage() async {
    // TODO(yaroslav): must be removed.
  }

  void handleError(String msg, Object error) {
    log(
      level: lg.Level.error,
      place: _loggerValue,
      message: msg,
    );

    transport.addToLog(DateTime.now(), 'SignalR error $error');

    if (msg == 'startconnection') {
      unawaited(reconnectSignalR());
    }

    //isSignalRRestarted = false;
    //isDisconnecting = true;
  }

  void simulateError() {
    _hubConnection?.stop();
  }

  void _startPing() {
    _pingTimer = Timer.periodic(
      const Duration(seconds: _pingTime),
      (_) async {
        if (_hubConnection?.state == HubConnectionState.connected) {
          try {
            transport.addToPing(DateTime.now());

            _hubConnection?.invoke(pingMessage);
          } catch (e) {
            transport.addToLog(DateTime.now(), 'Failed to start ping');
            log(
              level: lg.Level.error,
              place: _loggerValue,
              message: 'Failed to start ping',
            );
          }
        } else {
          transport.addToLog(DateTime.now(), 'Failed to start ping');
          log(
            level: lg.Level.error,
            place: _loggerValue,
            message: 'Failed to start ping',
          );

          _startReconnect();
        }
      },
    );
  }

  void pongMessageHandler(List<Object?>? data) {
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

        if (!isServiceDisposed) {
          _startReconnect();
        }
      },
    );
  }

  void _startReconnect() {
    if (_reconnectTimer == null || !_reconnectTimer!.isActive) {
      _reconnectTimer = Timer.periodic(
        const Duration(seconds: _reconnectTime),
        (_) => reconnectSignalR(),
      );
    }
  }

  /// Sometimes there will be the following error: \
  /// Unhandled Exception: SocketException: Reading from a closed socket \
  /// There are probably some problems with the library
  Future<void> reconnectSignalR({
    bool needRefreshToken = true,
  }) async {
    // TODO(yaroslav): must be removed.
    /*transport.addToLog(
      DateTime.now(),
      'Start reconnect Signalr. isDisconnecting: $isDisconnecting',
    );
    log(
      level: lg.Level.info,
      place: _loggerValue,
      message: 'Start reconnect Signalr. isDisconnecting: $isDisconnecting',
    );

    if (isServiceDisposed) return;

    if (!isDisconnecting) {
      try {
        _pingTimer?.cancel();
        _pongTimer?.cancel();

        await _hubConnection?.stop();

        await disableHandlerConnection();

        if (needRefreshToken) {
          await refreshToken();
        }
      } catch (e) {
        //isSignalRRestarted = false;
        //isDisconnecting = true;
      } finally {
        await openConnection();

        _reconnectTimer?.cancel();
      }
    }
    */
  }

  Future<void> disconnect(
    String from, {
    bool force = false,
  }) async {
    if (!force) {
      if (isSignalRRestarted) return;
    }

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

    if (force) {
      _checkConnectionTimer?.cancel();
      connectionCheckCount = 0;
    }
    await _hubConnection?.stop();

    await disableHandlerConnection();

    log(
      level: lg.Level.error,
      place: _loggerValue,
      message: 'SignalR Disconnected ${_hubConnection!.state}, Force timer: ${_checkConnectionTimer?.isActive}',
    );
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
      earnOffersMessage,
      method: handler.earnOffersMessageHandler,
    );
    _hubConnection?.off(
      recurringBuyMessage,
      method: handler.recurringBuyMessageHandler,
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
      instrumentsMessage,
      method: handler.instrumentsMessageHandler,
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
      paymentMethodsMessage,
      method: handler.paymentMethodsMessageHandler,
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
      nftCollectionsMessage,
      method: handler.nftCollectionsMessageHandler,
    );
    _hubConnection?.off(
      nftMarketMessage,
      method: handler.nftMarketMessageHandler,
    );
    _hubConnection?.off(
      nftPortfolioMessage,
      method: handler.nftPortfolioMessageHandler,
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
  }

  Future<void> setupMessageHandler() async {
    _hubConnection?.on(initFinished, handler.initFinishedHandler);

    _hubConnection?.on(cardsMessage, handler.cardsMessageHandler);

    _hubConnection?.on(cardLimitsMessage, handler.cardLimitsMessageHandler);

    _hubConnection?.on(earnOffersMessage, handler.earnOffersMessageHandler);

    _hubConnection?.on(recurringBuyMessage, handler.recurringBuyMessageHandler);

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

    _hubConnection?.on(instrumentsMessage, handler.instrumentsMessageHandler);

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

    _hubConnection?.on(indicesMessage, handler.indicesMessageHandler);

    _hubConnection?.on(
      convertPriceSettingsMessage,
      handler.convertPriceSettingsMessageHandler,
    );

    _hubConnection?.on(
      paymentMethodsMessage,
      handler.paymentMethodsMessageHandler,
    );

    _hubConnection?.on(
      paymentMethodsNewMessage,
      handler.paymentMethodsNewMessageHandler,
    );

    _hubConnection?.on(referralInfoMessage, handler.referralInfoMessageHandler);

    _hubConnection?.on(
      nftCollectionsMessage,
      handler.nftCollectionsMessageHandler,
    );

    _hubConnection?.on(nftMarketMessage, handler.nftMarketMessageHandler);

    _hubConnection?.on(nftPortfolioMessage, handler.nftPortfolioMessageHandler);

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
    _hubConnection?.on(bankingProfileMessage, (value) {
      print('bankingProfileMessage');
      print(value);
    });

    _hubConnection?.on(pendingOperationCountMessage, handler.pendingOperationCountHandler);

    ///

    _hubConnection?.on(pongMessage, pongMessageHandler);
  }
}
