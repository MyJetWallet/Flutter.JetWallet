import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:signalr_core/signalr_core.dart';

import '../../../../auth/providers/auth_model_notipod.dart';
import '../../../../shared/helpers/refresh_token.dart';
import '../../../shared/constants.dart';
import '../model/asset_model.dart';
import '../model/balance_model.dart';
import '../model/instruments_model.dart';
import '../model/prices_model.dart';
import '../model/server_time_model.dart';
import 'helpers/signal_r_log.dart';

class SignalRService {
  SignalRService(this.read);

  final Reader read;

  static const _pingTime = 3;
  static const _reconnectTime = 5;

  Timer? _pongTimer;
  Timer? _pingTimer;
  Timer? _reconnectTimer;

  bool isDisconnecting = false;

  /// connection is not restartable if it is stopped you cannot
  /// restart it - you need to create a new connection.
  late HubConnection _connection;

  final _assetsController = StreamController<AssetsModel>();
  final _balancesController = StreamController<BalancesModel>();
  final _instrumentsController = StreamController<InstrumentsModel>();
  final _pricesController = StreamController<PricesModel>();
  final _serverTimeController = StreamController<ServerTimeModel>();

  Future<void> init() async {
    isDisconnecting = false;

    _connection = HubConnectionBuilder().withUrl(urlSignalR).build();

    _connection.onclose((error) {
      if (!isDisconnecting) {
        signalRLog('Connection closed with $error');
        _startReconnect();
      }
    });

    _connection.on(assetsMessage, (data) {
      final assets = AssetsModel.fromJson(_json(data));

      _assetsController.add(assets);
    });

    _connection.on(balancesMessage, (data) {
      final balances = BalancesModel.fromJson(_json(data));

      _balancesController.add(balances);
    });

    _connection.on(instrumentsMessage, (data) {
      final instruments = InstrumentsModel.fromJson(_json(data));

      _instrumentsController.add(instruments);
    });

    _connection.on(bidAskMessage, (data) {
      final prices = PricesModel.fromJson(_json(data));

      _pricesController.add(prices);
    });

    _connection.on(pongMessage, (data) {
      final serverTime = ServerTimeModel.fromJson(_json(data));

      _serverTimeController.add(serverTime);

      _pongTimer?.cancel();

      _startPong();
    });

    final token = read(authModelNotipod).token;

    await _connection.start();
    await _connection.invoke(initMessage, args: [token]);

    _startPing();
  }

  Stream<AssetsModel> assets() => _assetsController.stream;

  Stream<BalancesModel> balances() => _balancesController.stream;

  Stream<InstrumentsModel> instruments() => _instrumentsController.stream;

  Stream<PricesModel> prices() => _pricesController.stream;

  Stream<ServerTimeModel> serverTime() => _serverTimeController.stream;

  void _startPing() {
    _pingTimer = Timer.periodic(
      const Duration(seconds: _pingTime),
      (_) {
        if (_connection.state == HubConnectionState.connected) {
          _connection.invoke(pingMessage);
        }
      },
    );
  }

  void _startPong() {
    _pongTimer = Timer(
      const Duration(seconds: _pingTime * 3),
      () {
        signalRLog('Pong Timeout');
        _startReconnect();
      },
    );
  }

  void _startReconnect() {
    if (_reconnectTimer == null || !_reconnectTimer!.isActive) {
      _reconnectTimer = Timer.periodic(
        const Duration(seconds: _reconnectTime),
        (_) => _reconnect(),
      );
    }
  }

  /// Sometimes there will be the following error: \
  /// Unhandled Exception: SocketException: Reading from a closed socket \
  /// There are probably some problems with the library
  Future<void> _reconnect() async {
    signalRLog('Reconnecting Hub');

    try {
      await _connection.stop();

      _pingTimer?.cancel();
      _pongTimer?.cancel();

      await refreshToken(read);

      await init();

      _reconnectTimer?.cancel();
    } catch (e) {
      signalRLog(e.toString());
    }
  }

  Future<void> disconnect() async {
    signalRLog('Disconnecting');
    isDisconnecting = true;
    _pingTimer?.cancel();
    _pongTimer?.cancel();
    _reconnectTimer?.cancel();
    await _connection.stop();
    // * Caution
    // Streams are not closed for a specific reason:
    // Since they are created inside a single instance we can't close them
    // because our StreamProviders will throw an error:
    // Bad state: Stream has already been listened to
  }

  /// Type cast response data from the SignalR
  Map<String, dynamic> _json(List<dynamic>? data) {
    return data?.first as Map<String, dynamic>;
  }
}
