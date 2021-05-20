import 'dart:async';

import 'package:signalr_core/signalr_core.dart';

import '../../../shared/constants.dart';
import 'dto/wallet/assets_response_dto.dart';
import 'dto/wallet/balances_response_dto.dart';
import 'dto/wallet/server_time_response_dto.dart';
import 'model/wallet/asset_model.dart';
import 'model/wallet/balance_model.dart';
import 'model/wallet/server_time_model.dart';

class SignalRService {
  static const _pingTime = 3;
  Timer? _pongTimer;
  Timer? _pingTimer;
  late HubConnection? _hubConnection;
  final StreamController<AssetsModel> _assetsModelStreamController = StreamController();
  final StreamController<BalancesModel> _balancesModelStreamController = StreamController();
  final StreamController<ServerTimeModel> _serverTimeStreamController = StreamController();

  Future<void> init(String token) async {
    _hubConnection = HubConnectionBuilder()
        .withUrl(
          urlSignalR,
          // HttpConnectionOptions(
          //   logging: (level, message) => print(message),
          // ),
        )
        .build();

    _hubConnection
      // ignore: avoid_print
      ?..onclose((error) => print('HubConnection: Connection closed with $error'))
      ..on(assetListMessage, (data) {
        final json = data?.first as Map<String, dynamic>;
        final assets = AssetsDto.fromJson(json).toModel();
        _assetsModelStreamController.add(assets);
      })
      ..on(spotWalletBalancesMessage, (data) {
        final json = data?.first as Map<String, dynamic>;
        final balances = BalancesDto.fromJson(json).toModel();
        _balancesModelStreamController.add(balances);
      });

    _hubConnection?.on(pongMessage, (data) {
      final json = data?.first as Map<String, dynamic>;
      final serverTime = ServerTimeDto.fromJson(json).toModel();
      _serverTimeStreamController.add(serverTime);

      _pongTimer?.cancel();

      _pongTimer = Timer(
        const Duration(seconds: _pingTime * 3),
        () => disconnect(),
      );
    });

    await _hubConnection?.start();
    await _hubConnection?.invoke(initMessage, args: [token]);

    _startPing();
  }

  Future<void> disconnect() async {
    _pingTimer?.cancel();
    _pongTimer?.cancel();
    await _assetsModelStreamController.close();
    await _balancesModelStreamController.close();
    await _serverTimeStreamController.close();
    await _hubConnection?.stop();
    _hubConnection = null;
  }

  Stream<AssetsModel> getAssetsStream() => _assetsModelStreamController.stream;

  Stream<BalancesModel> getBalancesStream() => _balancesModelStreamController.stream;

  Stream<ServerTimeModel> getServerTimeStream() => _serverTimeStreamController.stream;

  void _startPing() {
    _pingTimer = Timer.periodic(const Duration(seconds: _pingTime), (timer) async {
      await _hubConnection?.invoke(pingMessage);
    });
  }
}
