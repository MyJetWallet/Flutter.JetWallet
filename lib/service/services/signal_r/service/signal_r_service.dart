import 'dart:async';

import 'package:signalr_core/signalr_core.dart';

import '../../../shared/constants.dart';
import 'dto/wallet/assets_response_dto.dart';
import 'dto/wallet/balances_response_dto.dart';
import 'model/wallet/asset_model.dart';
import 'model/wallet/balance_model.dart';

class SignalRService {
  SignalRService() {
    _hubConnection = HubConnectionBuilder()
        .withUrl(
          urlSignalR,
          // HttpConnectionOptions(
          //   logging: (level, message) => print(message),
          // ),
        )
        .build();
  }

  late HubConnection _hubConnection;
  final StreamController<AssetsModel> _assetsModelStreamController = StreamController();
  final StreamController<BalancesModel> _balancesModelStreamController = StreamController();

  Future<void> init(String token) async {
    _hubConnection
      ..onclose(
              (error) => print('HubConnection: Connection closed with $error'))
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

    await _hubConnection.start();
    await _hubConnection.invoke(initMessage, args: [token]);
  }

  Stream<AssetsModel> getAssetsStream() => _assetsModelStreamController.stream;

  Stream<BalancesModel> getBalancesStream() => _balancesModelStreamController.stream;

  Future<void> disconnect() async {
    await _assetsModelStreamController.close();
    await _balancesModelStreamController.close();
    await _hubConnection.stop();
  }
}
