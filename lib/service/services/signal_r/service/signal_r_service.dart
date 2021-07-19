import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:signalr_core/signalr_core.dart';

import '../../../../auth/screens/sign_in_up/notifier/auth_model_notifier/auth_model_notipod.dart';
import '../../../../shared/helpers/refresh_token.dart';
import '../../../../shared/logging/levels.dart';
import '../../../shared/constants.dart';
import '../model/asset_model.dart';
import '../model/balance_model.dart';
import '../model/instruments_model.dart';
import '../model/market_references_model.dart';
import '../model/prices_model.dart';

class SignalRService {
  SignalRService(this.read);

  final Reader read;

  static final _logger = Logger('SignalRService');

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
  final _marketReferencesController = StreamController<MarketReferencesModel>();

  Future<void> init() async {
    isDisconnecting = false;

    _connection = HubConnectionBuilder().withUrl(urlSignalR).build();

    _connection.onclose((error) {
      if (!isDisconnecting) {
        _logger.log(signalR, 'Connection closed', error);
        _startReconnect();
      }
    });

    _connection.on(assetsMessage, (data) {
      try {
        final assets = AssetsModel.fromJson(_json(data));
        _assetsController.add(assets);
      } catch (e) {
        _logger.log(contract, assetsMessage, e);
      }
    });

    _connection.on(balancesMessage, (data) {
      try {
        final balances = BalancesModel.fromJson(_json(data));
        _balancesController.add(balances);
      } catch (e) {
        _logger.log(contract, balancesMessage, e);
      }
    });

    _connection.on(instrumentsMessage, (data) {
      try {
        final instruments = InstrumentsModel.fromJson(_json(data));
        _instrumentsController.add(instruments);
      } catch (e) {
        _logger.log(contract, instrumentsMessage, e);
      }
    });

    _connection.on(bidAskMessage, (data) {
      try {
        final prices = PricesModel.fromJson(_json(data));
        _pricesController.add(prices);
      } catch (e) {
        _logger.log(contract, bidAskMessage, e);
      }
    });

    _connection.on(pongMessage, (data) {
      _pongTimer?.cancel();

      _startPong();
    });

    _connection.on(marketReferenceMessage, (data) {
      try {
        final marketReferences = MarketReferencesModel.fromJson(_json(data));
        _marketReferencesController.add(marketReferences);
      } catch (e) {
        _logger.log(contract, marketReferenceMessage, e);
      }
    });

    final token = read(authModelNotipod).token;

    try {
      await _connection.start();
    } catch (e) {
      _logger.log(signalR, 'Failed to start connection', e);
      rethrow;
    }

    try {
      await _connection.invoke(initMessage, args: [token]);
    } catch (e) {
      _logger.log(signalR, 'Failed to invoke connection', e);
      rethrow;
    }

    _startPing();
  }

  Stream<AssetsModel> assets() => _assetsController.stream;

  Stream<BalancesModel> balances() => _balancesController.stream;

  Stream<InstrumentsModel> instruments() => _instrumentsController.stream;

  Stream<PricesModel> prices() => _pricesController.stream;

  Stream<MarketReferencesModel> marketReferences() =>
      _marketReferencesController.stream;

  void _startPing() {
    _pingTimer = Timer.periodic(
      const Duration(seconds: _pingTime),
      (_) {
        if (_connection.state == HubConnectionState.connected) {
          try {
            _connection.invoke(pingMessage);
          } catch (e) {
            _logger.log(signalR, 'Failed to start ping', e);
            rethrow;
          }
        }
      },
    );
  }

  void _startPong() {
    _pongTimer = Timer(
      const Duration(seconds: _pingTime * 3),
      () {
        _logger.log(signalR, 'Pong Timeout');
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
    _logger.log(signalR, 'Reconnecting...');

    try {
      await _connection.stop();

      _pingTimer?.cancel();
      _pongTimer?.cancel();

      await refreshToken(read);

      await init();

      _reconnectTimer?.cancel();
    } catch (e) {
      _logger.log(signalR, 'Failed to reconnect. Trying again...', e);
    }
  }

  /// * CAUTION \
  /// Streams are not closed for a specific reason: \
  /// Since they are created inside a single instance we can't close them
  /// because our StreamProviders will throw an error:
  /// Bad state: Stream has already been listened to
  Future<void> disconnect() async {
    _logger.log(signalR, 'Disconnecting...');
    isDisconnecting = true;
    _pingTimer?.cancel();
    _pongTimer?.cancel();
    _reconnectTimer?.cancel();
    await _connection.stop();
    _logger.log(signalR, 'Disconnected');
  }

  /// Type cast response data from the SignalR
  Map<String, dynamic> _json(List<dynamic>? data) {
    return data?.first as Map<String, dynamic>;
  }
}
