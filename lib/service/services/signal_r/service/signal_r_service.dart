import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:signalr_core/signalr_core.dart';

import '../../../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../../../shared/helpers/device_type.dart';
import '../../../../shared/helpers/refresh_token.dart';
import '../../../../shared/logging/levels.dart';
import '../../../../shared/providers/device_uid_pod.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../shared/constants.dart';
import '../../market_info/model/market_info_response_model.dart';
import '../model/asset_model.dart';
import '../model/balance_model.dart';
import '../model/base_prices_model.dart';
import '../model/campaign_response_model.dart';
import '../model/client_detail_model.dart';
import '../model/indices_model.dart';
import '../model/instruments_model.dart';
import '../model/key_value_model.dart';
import '../model/kyc_countries_response_model.dart';
import '../model/market_info_model.dart';
import '../model/market_references_model.dart';
import '../model/period_prices_model.dart';
import '../model/price_accuracies.dart';
import '../model/referral_stats_response_model.dart';

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
  HubConnection? _connection;

  final _assetsController = StreamController<AssetsModel>();
  final _balancesController = StreamController<BalancesModel>();
  final _instrumentsController = StreamController<InstrumentsModel>();
  final _marketReferencesController = StreamController<MarketReferencesModel>();
  final _basePricesController = StreamController<BasePricesModel>();
  final _periodPricesController = StreamController<PeriodPricesModel>();
  final _clientDetailController = StreamController<ClientDetailModel>();
  final _keyValueController = StreamController<KeyValueModel>();
  final _campaignsBannersController = StreamController<CampaignResponseModel>();
  final _referralStatsController =
      StreamController<ReferralStatsResponseModel>();
  final _indicesController = StreamController<IndicesModel>();
  final _kycCountriesController = StreamController<KycCountriesResponseModel>();
  final _priceAccuraciesController = StreamController<PriceAccuracies>();
  final _marketInfoController = StreamController<MarketInfoResponseModel>();

  /// This variable is created to track previous snapshot of base prices.
  /// This needed because when signlaR gets update from basePrices it
  /// recevies only prices that changed, this results in overriding prices
  /// that didn't changed with zeros.
  var _oldBasePrices = const BasePricesModel(
    prices: [],
  );

  Future<void> init() async {
    isDisconnecting = false;

    _connection = HubConnectionBuilder().withUrl(walletApiSignalR).build();

    _connection?.on(kycCountriesMessage, (data) {
      try {
        final countries = KycCountriesResponseModel.fromJson(_json(data));
        _kycCountriesController.add(countries);
      } catch (e) {
        _logger.log(contract, kycCountriesMessage, e);
      }
    });

    _connection?.on(marketInfoMessage, (data) {



      try {
        print('data||| $data');
        final marketInfo = MarketInfoModel.fromList(data!);

        print('marketInfoMessage||| $marketInfo');
        // _kycCountriesController.add(countries);
      } catch (e) {
        print('CATCH ERROR');
        _logger.log(contract, kycCountriesMessage, e);
      }
    });

    _connection?.on(campaignsBannersMessage, (data) {
      try {
        final campaigns = CampaignResponseModel.fromJson(_json(data));
        _campaignsBannersController.add(campaigns);
      } catch (e) {
        _logger.log(contract, campaignsBannersMessage, e);
      }
    });

    _connection?.onclose((error) {
      if (!isDisconnecting) {
        _logger.log(signalR, 'Connection closed', error);
        _startReconnect();
      }
    });

    _connection?.on(referralStatsMessage, (data) {
      try {
        final referrerStats = ReferralStatsResponseModel.fromList(data!);
        _referralStatsController.add(referrerStats);
      } catch (e) {
        _logger.log(contract, referralStatsMessage, e);
      }
    });

    _connection?.on(assetsMessage, (data) {
      try {
        final assets = AssetsModel.fromJson(_json(data));
        _assetsController.add(assets);
      } catch (e) {
        _logger.log(contract, assetsMessage, e);
      }
    });

    _connection?.on(balancesMessage, (data) {
      try {
        final balances = BalancesModel.fromJson(_json(data));
        _balancesController.add(balances);
      } catch (e) {
        _logger.log(contract, balancesMessage, e);
      }
    });

    _connection?.on(instrumentsMessage, (data) {
      try {
        final instruments = InstrumentsModel.fromJson(_json(data));
        _instrumentsController.add(instruments);
      } catch (e) {
        _logger.log(contract, instrumentsMessage, e);
      }
    });

    _connection?.on(pongMessage, (data) {
      _pongTimer?.cancel();

      _startPong();
    });

    _connection?.on(marketReferenceMessage, (data) {
      try {
        final marketReferences = MarketReferencesModel.fromJson(_json(data));
        _marketReferencesController.add(marketReferences);
      } catch (e) {
        _logger.log(contract, marketReferenceMessage, e);
      }
    });

    _connection?.on(basePricesMessage, (data) {
      try {
        _oldBasePrices = BasePricesModel.fromNewPrices(
          json: _json(data),
          oldPrices: _oldBasePrices,
        );
        _basePricesController.add(_oldBasePrices);
      } catch (e) {
        _logger.log(contract, basePricesMessage, e);
      }
    });

    _connection?.on(periodPricesMessage, (data) {
      try {
        final basePrices = PeriodPricesModel.fromJson(_json(data));
        _periodPricesController.add(basePrices);
      } catch (e) {
        _logger.log(contract, periodPricesMessage, e);
      }
    });

    _connection?.on(clientDetailMessage, (data) {
      try {
        final clientDetail = ClientDetailModel.fromJson(_json(data));
        _clientDetailController.add(clientDetail);
      } catch (e) {
        _logger.log(contract, clientDetailMessage, e);
      }
    });

    _connection?.on(keyValueMessage, (data) {
      try {
        final keyValue = KeyValueModel.parsed(
          KeyValueModel.fromJson(_json(data)),
        );
        _keyValueController.add(keyValue);
      } catch (e) {
        _logger.log(contract, keyValueMessage, e);
      }
    });

    _connection?.on(indicesMessage, (data) {
      try {
        final indices = IndicesModel.fromJson(_json(data));
        _indicesController.add(indices);
      } catch (e) {
        _logger.log(contract, indicesMessage, e);
      }
    });

    _connection?.on(convertPriceSettingsMessage, (data) {
      try {
        final settings = PriceAccuracies.fromJson(_json(data));
        _priceAccuraciesController.add(settings);
      } catch (e) {
        _logger.log(contract, convertPriceSettingsMessage, e);
      }
    });

    final token = read(authInfoNotipod).token;
    final localeName = read(intlPod).localeName;
    final deviceUid = read(deviceUidPod);

    try {
      await _connection?.start();
    } catch (e) {
      _logger.log(signalR, 'Failed to start connection', e);
      rethrow;
    }

    try {
      await _connection?.invoke(
        initMessage,
        args: [token, localeName, deviceUid, deviceType],
      );
    } catch (e) {
      _logger.log(signalR, 'Failed to invoke connection', e);
      rethrow;
    }

    _startPing();
  }

  Stream<AssetsModel> assets() => _assetsController.stream;

  Stream<BalancesModel> balances() => _balancesController.stream;

  Stream<InstrumentsModel> instruments() => _instrumentsController.stream;

  Stream<MarketReferencesModel> marketReferences() =>
      _marketReferencesController.stream;

  Stream<BasePricesModel> basePrices() => _basePricesController.stream;

  Stream<PeriodPricesModel> periodPrices() => _periodPricesController.stream;

  Stream<ClientDetailModel> clientDetail() => _clientDetailController.stream;

  Stream<KeyValueModel> keyValue() => _keyValueController.stream;

  Stream<CampaignResponseModel> marketCampaigns() =>
      _campaignsBannersController.stream;

  Stream<ReferralStatsResponseModel> referralStats() =>
      _referralStatsController.stream;

  Stream<KycCountriesResponseModel> kycCountries() =>
      _kycCountriesController.stream;

  Stream<IndicesModel> indices() => _indicesController.stream;

  Stream<PriceAccuracies> priceAccuracies() =>
      _priceAccuraciesController.stream;

  void _startPing() {
    _pingTimer = Timer.periodic(
      const Duration(seconds: _pingTime),
      (_) {
        if (_connection?.state == HubConnectionState.connected) {
          try {
            _connection?.invoke(pingMessage);
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
      await _connection?.stop();

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
  ///
  /// The problem above can be solved by injecting HubConnection
  /// through signalRServicePod. + signalRServicePod must listen
  /// for auth changes in order to create a new connection after them.
  /// The solution must be properly tested.
  /// TODO(Eli) revisit this problem (added to backlog[SPUI-389])
  Future<void> disconnect() async {
    _logger.log(signalR, 'Disconnecting...');
    isDisconnecting = true;
    _pingTimer?.cancel();
    _pongTimer?.cancel();
    _reconnectTimer?.cancel();
    await _connection?.stop();
    _logger.log(signalR, 'Disconnected');
  }

  /// Type cast response data from the SignalR
  Map<String, dynamic> _json(List<dynamic>? data) {
    return data?.first as Map<String, dynamic>;
  }
}
