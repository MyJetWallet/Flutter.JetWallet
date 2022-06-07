import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:signalr_core/signalr_core.dart';

import '../../../../shared/helpers/device_type.dart';
import '../../../shared/api_urls.dart';
import '../../../shared/constants.dart';
import '../../../shared/helpers/device_type.dart';
import '../../../shared/models/refresh_token_status.dart';
import '../model/asset_model.dart';
import '../model/asset_payment_methods.dart';
import '../model/balance_model.dart';
import '../model/base_prices_model.dart';
import '../model/blockchains_model.dart';
import '../model/campaign_response_model.dart';
import '../model/client_detail_model.dart';
import '../model/earn_offers_model.dart';
import '../model/earn_profile_model.dart';
import '../model/indices_model.dart';
import '../model/instruments_model.dart';
import '../model/key_value_model.dart';
import '../model/kyc_countries_response_model.dart';
import '../model/market_info_model.dart';
import '../model/market_references_model.dart';
import '../model/period_prices_model.dart';
import '../model/price_accuracies.dart';
import '../model/recurring_buys_response_model.dart';
import '../model/referral_info_model.dart';
import '../model/referral_stats_response_model.dart';

class _HttpClient extends http.BaseClient {
  _HttpClient({required this.defaultHeaders});
  final _httpClient = http.Client();
  final Map<String, String> defaultHeaders;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(defaultHeaders);
    return _httpClient.send(request);
  }
}

class SignalRService {
  SignalRService(
    this.read,
    this.refreshToken,
    this.token,
    this.localeName,
    this.deviceUid,
    this.appVersion,
    this.deviceSize,
    this.devicePixelRatio,
    this.deviceModel,
  );

  final Reader read;
  final Future<RefreshTokenStatus> Function(Reader) refreshToken;
  final String token;
  final String localeName;
  final String deviceUid;
  final String appVersion;
  final Size deviceSize;
  final double devicePixelRatio;
  final String deviceModel;

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
  final _marketInfoController = StreamController<TotalMarketInfoModel>();
  final _assetPaymentMethodsController =
      StreamController<AssetPaymentMethods>();
  final _blockchainsController = StreamController<BlockchainsModel>();
  final _referralInfoController = StreamController<ReferralInfoModel>();
  final _recurringBuyController =
      StreamController<RecurringBuysResponseModel>();
  final _earnOfferController = StreamController<List<EarnOfferModel>>();
  final _earnProfileController = StreamController<EarnProfileModel>();

  final _inifFinishedController = StreamController<bool>();

  /// This variable is created to track previous snapshot of base prices.
  /// This needed because when signlaR gets update from basePrices it
  /// recevies only prices that changed, this results in overriding prices
  /// that didn't changed with zeros.
  var _oldBasePrices = const BasePricesModel(
    prices: [],
  );

  Future<void> init() async {
    isDisconnecting = false;

    final httpClient = _HttpClient(
      defaultHeaders: {
        'User-Agent': '$appVersion;$deviceType;$deviceSize;$devicePixelRatio;'
            '$deviceModel',
      },
    );

    _connection = HubConnectionBuilder()
        .withUrl(walletApiSignalR, HttpConnectionOptions(client: httpClient))
        .build();

    _connection?.on(initFinished, (data) {
      try {
        _inifFinishedController.add(true);
      } catch (e) {
        _logger.log(contract, initFinished, e);
      }
    });

    _connection?.on(earnProfileMessage, (data) {
      try {
        final earnProfileInfo = EarnProfileModel.fromJson(_json(data));
        _earnProfileController.add(earnProfileInfo);
      } catch (e) {
        _logger.log(contract, earnProfileMessage, e);
      }
    });

    _connection?.on(earnOffersMessage, (data) {
      if (data != null) {
        final list = data.toList();
        try {
          final finalData = EarnFullModel.fromJson(_json(list));
          _earnOfferController.add(finalData.earnOffers);
          if (finalData.earnProfile != null) {
            _earnProfileController.add(finalData.earnProfile!);
          }
        } catch (e) {
          _logger.log(contract, earnOffersMessage, e);
        }
      }
    });

    _connection?.on(recurringBuyMessage, (data) {
      if (data != null) {
        final list = data.toList();
        try {
          final recurringBuys = RecurringBuysResponseModel.fromJson(
            _json(list),
          );

          _recurringBuyController.add(recurringBuys);
        } catch (e) {
          _logger.log(contract, recurringBuyMessage, e);
        }
      }
    });

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
        final model = MarketInfoModel.fromJson(_json(data));
        final info = model.totalMarketInfo;
        _marketInfoController.add(info);
      } catch (e) {
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

    _connection?.on(blockchainsMessage, (data) {
      try {
        final blockchains = BlockchainsModel.fromJson(_json(data));
        _blockchainsController.add(blockchains);
      } catch (e) {
        _logger.log(contract, blockchainsMessage, e);
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
        final map = {
          for (final e in _json(data).entries) e.key: e.value,
          'recivedAt': DateTime.now().toString(),
        };
        final clientDetail = ClientDetailModel.fromJson(map);
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

    _connection?.on(paymentMethodsMessage, (data) {
      try {
        final info = AssetPaymentMethods.fromJson(_json(data));

        _assetPaymentMethodsController.add(info);
      } catch (e) {
        _logger.log(contract, paymentMethodsMessage, e);
      }
    });

    _connection?.on(referralInfoMessage, (data) {
      try {
        final info = ReferralInfoModel.fromJson(_json(data));

        _referralInfoController.add(info);
      } catch (e) {
        _logger.log(contract, referralInfoMessage, e);
      }
    });

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

  Stream<TotalMarketInfoModel> marketInfo() => _marketInfoController.stream;

  Stream<AssetPaymentMethods> paymentMethods() =>
      _assetPaymentMethodsController.stream;

  Stream<BlockchainsModel> blockchains() => _blockchainsController.stream;

  Stream<ReferralInfoModel> referralInfo() => _referralInfoController.stream;

  Stream<RecurringBuysResponseModel> recurringBuy() =>
      _recurringBuyController.stream;

  Stream<List<EarnOfferModel>> earnOffers() => _earnOfferController.stream;

  Stream<EarnProfileModel> earnProfile() => _earnProfileController.stream;

  Stream<bool> isAppLoaded() => _inifFinishedController.stream;

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
