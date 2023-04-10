import 'dart:async';

import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:logger/logger.dart';

import 'package:simple_networking/config/constants.dart';
import 'package:simple_networking/config/options.dart';
import 'package:simple_networking/helpers/device_type.dart';
import 'package:simple_networking/helpers/models/refresh_token_status.dart';
import 'package:simple_networking/modules/signal_r/models/base_prices_model.dart';

import 'package:simple_networking/modules/signal_r/signal_r_func_handler.dart';
import 'package:simple_networking/modules/signal_r/signal_r_transport.dart';

class SignalRModuleNew {
  SignalRModuleNew({
    required this.transport,
    required this.options,
    required this.refreshToken,
    required this.token,
    required this.headers,
    required this.localeName,
    required this.deviceUid,
    required this.log,
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
  final Map<String, String> headers;
  final String token;
  final String localeName;
  final String deviceUid;

  final bool isDebug;
  final Function({
    required Level level,
    required String message,
    required String place,
  }) log;

  static const _pingTime = 3;
  static const _reconnectTime = 5;
  static const _messageTime = 10;

  final _loggerValue = 'SignalR';

  Timer? _pongTimer;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  Timer? _messageTimer;

  HubConnection? _hubConnection;

  /// Is Module Disconnecting
  bool isDisconnecting = false;

  //String? userToken;
  //void setUserToken(String value) {
  //  userToken = value;
  //
  //  reconnectSignalR(needRefreshToken: false);
  //}

  Future<void> init() async {
    log(
      level: Level.info,
      place: _loggerValue,
      message:
          'SignalR Init \n isDisconnecting: $isDisconnecting Connection: ${_hubConnection?.state}',
    );

    if (_hubConnection?.state == HubConnectionState.Connected) {
      return;
    }

    isDisconnecting = false;

    final defaultHeaders = MessageHeaders();

    defaultHeaders.setHeaderValue(
      headers.keys.first,
      headers.entries.first.value,
    );

    final httpOptions = HttpConnectionOptions(
      headers: defaultHeaders,
      //logger: _logger,
    );

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          options.walletApiSignalR!,
          options: httpOptions,
        )
        .withAutomaticReconnect()
        //.configureLogging(_logger)
        .build();

    //_hubConnection?.onclose(({error}) => _startReconnect());

    ///

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

    try {
      await _hubConnection?.start();
    } catch (e) {
      log(
        level: Level.error,
        place: _loggerValue,
        message: 'SignalR failed to start connection $e',
      );

      handleError('startconnection', Object());
      rethrow;
    }

    if (_hubConnection?.state == HubConnectionState.Connected) {
      try {
        await _hubConnection?.invoke(
          initMessage,
          args: [token, localeName, deviceUid, deviceType],
        );
      } catch (e) {
        handleError('invoke $e', e);
        rethrow;
      }
    } else {
      log(
        level: Level.error,
        place: _loggerValue,
        message: 'SignalR error init ${_hubConnection?.state}',
      );

      if (!isDisconnecting) {
        reconnectSignalR();
      }
    }

    _startPing();
  }

  static Future<void> handlePackage() async {}

  void handleError(String msg, Object error) {
    log(
      level: Level.error,
      place: _loggerValue,
      message: msg,
    );

    if (msg == 'startconnection') {
      unawaited(reconnectSignalR());
    }
    //showEror(error.toString());
  }

  void simulateError() {
    _hubConnection?.stop();
    _hubConnection?.invoke(pingMessage);
  }

  void _startPing() {
    log(
      level: Level.info,
      place: _loggerValue,
      message: 'Start Ping \n Status: ${_hubConnection?.state}',
    );

    _pingTimer = Timer.periodic(
      const Duration(seconds: _pingTime),
      (_) {
        if (_hubConnection?.state == HubConnectionState.Connected) {
          try {
            _hubConnection?.invoke(pingMessage);
          } catch (e) {
            log(
              level: Level.error,
              place: _loggerValue,
              message: 'Failed to start ping',
            );
          }
        } else {
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
          level: Level.info,
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
      level: Level.info,
      place: _loggerValue,
      message: 'Start reconnect Signalr. isDisconnecting: $isDisconnecting',
    );

    if (!isDisconnecting) {
      try {
        await disableHandlerConnection();

        _pingTimer?.cancel();
        _pongTimer?.cancel();
        _messageTimer?.cancel();

        await _hubConnection?.stop();

        await disableHandlerConnection();

        if (needRefreshToken) {
          await refreshToken();
        }

        await init();

        _reconnectTimer?.cancel();
      } catch (e) {}
    }
  }

  Future<void> disconnect() async {
    log(
      level: Level.warning,
      place: _loggerValue,
      message: 'SignalR Disconnect',
    );

    isDisconnecting = true;

    _pingTimer?.cancel();
    _pongTimer?.cancel();
    _reconnectTimer?.cancel();

    await disableHandlerConnection();

    await _hubConnection?.stop();

    await disableHandlerConnection();
  }

  Future<void> disableHandlerConnection() async {
    log(
      level: Level.info,
      place: _loggerValue,
      message: 'Disable Handler Connection',
    );

    _hubConnection?.off(
      initFinished,
      method: handler.initFinishedHandler,
    );
    _hubConnection?.off(
      cardsMessage,
      method: handler.cardsMessageHandler,
    );
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
    _hubConnection?.off(
      assetsMessage,
      method: handler.assetsMessageHandler,
    );
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
    _hubConnection?.off(
      indicesMessage,
      method: handler.indicesMessageHandler,
    );
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
    _hubConnection?.off(
      pongMessage,
      method: pongMessageHandler,
    );
  }
}
