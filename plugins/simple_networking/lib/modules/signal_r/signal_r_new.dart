import 'dart:async';
import 'dart:math';

//import 'package:signalr_netcore/ihub_protocol.dart';
//import 'package:signalr_netcore/signalr_client.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart' as lg;
import 'package:logging/logging.dart' as logg;

import 'package:simple_networking/config/constants.dart';
import 'package:simple_networking/config/options.dart';
import 'package:simple_networking/helpers/device_type.dart';
import 'package:simple_networking/helpers/models/refresh_token_status.dart';
import 'package:simple_networking/modules/signal_r/models/base_prices_model.dart';

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

  final bool isDebug;
  final Function({
    required lg.Level level,
    required String message,
    required String place,
  }) log;

  final Future<String> Function() getToken;

  static const _pingTime = 3;
  static const _reconnectTime = 5;
  static const _messageTime = 10;

  final _loggerValue = 'SignalR';

  Timer? _pongTimer;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  Timer? _messageTimer;

  //HubConnection? _hubConnection;
  HubConnection? _hubConnection;

  /// Is Module Disconnecting
  bool isDisconnecting = false;

  bool isSignalRRestarted = false;

  void logMsg(String msg) {
    if (msg.contains('sending data')) {
      log(
        level: lg.Level.warning,
        place: _loggerValue,
        message: 'SignalR $msg',
      );
    }
  }

  Future<void> openConnection() async {
    if (isSignalRRestarted) return;

    log(
      level: lg.Level.verbose,
      place: _loggerValue,
      message: 'SignalR state: ${_hubConnection?.state}',
    );

    isSignalRRestarted = true;

    if (_hubConnection == null) {
      /*final defaultHeaders = MessageHeaders();
      defaultHeaders.setHeaderValue(
        headers.keys.first,
        headers.entries.first.value,
      );
      final httpOptions = HttpConnectionOptions(
        headers: defaultHeaders,
        logger: _logger,
        logMessageContent: true,
      );

      _hubConnection = HubConnectionBuilder()
          .withUrl(
            options.walletApiSignalR!,
            options: httpOptions,
          )
          //.withAutomaticReconnect()
          .configureLogging(_logger!)
          .build();

      _hubConnection!.onclose(({error}) {
        log(
          level: lg.Level.error,
          place: _loggerValue,
          message: 'SignalR onclose',
        );
      });
      */

      _hubConnection = HubConnectionBuilder()
          .withUrl(
            options.walletApiSignalR!,
            HttpConnectionOptions(
              client: signalRClient,
              logging: (level, message) => logMsg(message),
              logMessageContent: true,
            ),
          )
          .build();

      await setupMessageHandler();

      await _hubConnection!.start();

      await sendInitMessage('2');

      _startPing();
    } else {
      if (_hubConnection!.state != HubConnectionState.connected) {
        await setupMessageHandler();

        await _hubConnection!.start();

        await sendInitMessage('3');

        _startPing();
      }
    }

    isSignalRRestarted = false;
    isDisconnecting = false;
  }

  Future<void> sendInitMessage(String from) async {
    if (_hubConnection?.state == HubConnectionState.connected) {
      log(
        level: lg.Level.error,
        place: _loggerValue,
        message: 'SignalR init message $from',
      );

      try {
        final _token = await getToken();

        await _hubConnection?.invoke(
          initMessage,
          args: [
            _token,
            localeName,
            deviceUid,
            deviceType,
          ],
        );
      } catch (e) {
        handleError('invoke $e', e);
        rethrow;
      }
    } else {
      log(
        level: lg.Level.error,
        place: _loggerValue,
        message: 'SignalR error init ${_hubConnection?.state}',
      );

      if (!isDisconnecting) {
        reconnectSignalR();
      }
    }
  }

  static Future<void> handlePackage() async {}

  void handleError(String msg, Object error) {
    log(
      level: lg.Level.error,
      place: _loggerValue,
      message: msg,
    );

    if (msg == 'startconnection') {
      unawaited(disconnect('handleError'));
    }
    //showEror(error.toString());
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
            log(
              level: lg.Level.info,
              place: _loggerValue,
              message:
                  'Start Ping \n Status: ${_hubConnection?.state} \n Connection ID: ${_hubConnection?.connectionId}',
            );

            _hubConnection?.invoke(pingMessage);
          } catch (e) {
            log(
              level: lg.Level.error,
              place: _loggerValue,
              message: 'Failed to start ping',
            );
          }
        } else {
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
    _pongTimer?.cancel();

    _startPong();
  }

  void _startPong() {
    _pongTimer = Timer(
      const Duration(seconds: _pingTime * 3),
      () {
        log(
          level: lg.Level.info,
          place: _loggerValue,
          message: 'Start pong reconnect',
        );

        _startReconnect();
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
    log(
      level: lg.Level.info,
      place: _loggerValue,
      message: 'Start reconnect Signalr. isDisconnecting: $isDisconnecting',
    );

    if (!isDisconnecting) {
      try {
        _pingTimer?.cancel();
        _pongTimer?.cancel();
        _messageTimer?.cancel();

        await _hubConnection?.stop();

        await disableHandlerConnection();

        if (needRefreshToken) {
          await refreshToken();
        }

        await openConnection();

        _reconnectTimer?.cancel();
      } catch (e) {}
    }
  }

  Future<void> disconnect(String from) async {
    if (isSignalRRestarted) return;

    log(
      level: lg.Level.warning,
      place: _loggerValue,
      message: 'SignalR Disconnect $from',
    );

    isDisconnecting = true;

    _pingTimer?.cancel();
    _pongTimer?.cancel();
    _reconnectTimer?.cancel();

    await _hubConnection?.stop();

    await disableHandlerConnection();
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

    ///

    _hubConnection?.on(pongMessage, pongMessageHandler);
  }
}
