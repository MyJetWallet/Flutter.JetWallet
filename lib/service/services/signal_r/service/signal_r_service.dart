import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:signalr_core/signalr_core.dart';

import '../../../../auth/providers/auth_model_notipod.dart';
import '../../../../shared/helpers/refresh_token.dart';
import '../../../shared/constants.dart';
import '../dto/assets_response_dto.dart';
import '../dto/balances_response_dto.dart';
import '../dto/server_time_response_dto.dart';
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

  /// connection is not restartable if it is stopped you cannot
  /// restart it - you need to create a new connection.
  late HubConnection _connection;

  final _assetsController = StreamController<AssetsModel>();
  final _balancesController = StreamController<BalancesModel>();
  final _instrumentsController = StreamController<InstrumentsModel>();
  final _pricesController = StreamController<PricesModel>();
  final _serverTimeController = StreamController<ServerTimeModel>();

  Future<void> init() async {
    _connection = HubConnectionBuilder().withUrl(urlSignalR).build();

    _connection.onclose((error) {
      signalRLog('Connection closed with $error');
      _startReconnect();
    });

    _connection.on(assetsMessage, (data) {
      final assets = AssetsDto.fromJson(_json(data)).toModel();

      _assetsController.add(assets);
    });

    _connection.on(balancesMessage, (data) {
      final balances = BalancesDto.fromJson(_json(data)).toModel();

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
      final serverTime = ServerTimeDto.fromJson(_json(data)).toModel();

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
    _pingTimer?.cancel();
    _pongTimer?.cancel();
    _reconnectTimer?.cancel();
    await _assetsController.close();
    await _balancesController.close();
    await _serverTimeController.close();
    await _instrumentsController.close();
    await _pricesController.close();
    await _connection.stop();
  }

  /// Type cast response data from the SignalR
  Map<String, dynamic> _json(List<dynamic>? data) {
    return data?.first as Map<String, dynamic>;
  }
}
