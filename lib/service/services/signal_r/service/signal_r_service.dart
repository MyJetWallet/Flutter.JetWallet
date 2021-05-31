import 'dart:async';
import 'dart:developer';

import 'package:signalr_core/signalr_core.dart';

import '../../../shared/constants.dart';
import 'dto/wallet/assets_response_dto.dart';
import 'dto/wallet/balances_response_dto.dart';
import 'dto/wallet/server_time_response_dto.dart';
import 'model/wallet/asset_model.dart';
import 'model/wallet/balance_model.dart';
import 'model/wallet/instruments_model.dart';
import 'model/wallet/prices_model.dart';
import 'model/wallet/server_time_model.dart';

class SignalRService {
  static const _pingTime = 3;

  Timer? _pongTimer;
  Timer? _pingTimer;

  // the connection is not restartable if it is stopped you cannot
  // restart it - you need to create a new connection.
  late HubConnection? _connection;

  final _assetsController = StreamController<AssetsModel>();
  final _balancesController = StreamController<BalancesModel>();
  final _instrumentsController = StreamController<InstrumentsModel>();
  final _pricesController = StreamController<PricesModel>();
  final _serverTimeController = StreamController<ServerTimeModel>();

  Future<void> init(String token) async {
    _connection = HubConnectionBuilder().withUrl(urlSignalR).build();

    _connection?.onclose((error) {
      log('SignalRService: Connection closed with $error');
    });

    _connection?.on(assetsMessage, (data) {
      final assets = AssetsDto.fromJson(_json(data)).toModel();

      _assetsController.add(assets);
    });

    _connection?.on(balancesMessage, (data) {
      final balances = BalancesDto.fromJson(_json(data)).toModel();

      _balancesController.add(balances);
    });

    _connection?.on(instrumentsMessage, (data) {
      final instruments = InstrumentsModel.fromJson(_json(data));

      _instrumentsController.add(instruments);
    });

    _connection?.on(bidAskMessage, (data) {
      final prices = PricesModel.fromJson(_json(data));

      _pricesController.add(prices);
    });

    _connection?.on(pongMessage, (data) {
      final serverTime = ServerTimeDto.fromJson(_json(data)).toModel();

      _serverTimeController.add(serverTime);

      _pongTimer?.cancel();

      _startPong();
    });

    await _connection?.start();
    await _connection?.invoke(initMessage, args: [token]);

    _startPing();
  }

  Future<void> disconnect() async {
    _pingTimer?.cancel();
    _pongTimer?.cancel();
    await _assetsController.close();
    await _balancesController.close();
    await _serverTimeController.close();
    await _connection?.stop();
    _connection = null;
  }

  Stream<AssetsModel> assets() => _assetsController.stream;

  Stream<BalancesModel> balances() => _balancesController.stream;

  Stream<InstrumentsModel> instruments() => _instrumentsController.stream;

  Stream<PricesModel> prices() => _pricesController.stream;

  Stream<ServerTimeModel> serverTime() => _serverTimeController.stream;

  void _startPing() {
    _pingTimer = Timer.periodic(
      const Duration(seconds: _pingTime),
      (timer) => _connection?.invoke(pingMessage),
    );
  }

  void _startPong() {
    _pongTimer = Timer(
      const Duration(seconds: _pingTime * 3),
      () => disconnect(),
    );
  }

  /// Type cast response data from the SignalR
  Map<String, dynamic> _json(List<dynamic>? data) {
    return data?.first as Map<String, dynamic>;
  }
}
