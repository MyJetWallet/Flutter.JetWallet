import 'dart:async';

import 'package:logger/logger.dart' as logPrint;
import 'package:logging/logging.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:simple_networking/config/constants.dart';
import 'package:simple_networking/config/options.dart';
import 'package:simple_networking/helpers/device_type.dart';
import 'package:simple_networking/helpers/models/refresh_token_status.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_withdrawal_fee_model.dart';
import 'package:simple_networking/modules/signal_r/models/balance_model.dart';
import 'package:simple_networking/modules/signal_r/models/base_prices_model.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';
import 'package:simple_networking/modules/signal_r/models/campaign_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/signal_r/models/cards_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/fireblock_events_model.dart';
import 'package:simple_networking/modules/signal_r/models/indices_model.dart';
import 'package:simple_networking/modules/signal_r/models/instruments_model.dart';
import 'package:simple_networking/modules/signal_r/models/key_value_model.dart';
import 'package:simple_networking/modules/signal_r/models/kyc_countries_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/market_info_model.dart';
import 'package:simple_networking/modules/signal_r/models/market_references_model.dart';
import 'package:simple_networking/modules/signal_r/models/nft_collections.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';
import 'package:simple_networking/modules/signal_r/models/nft_portfolio.dart';
import 'package:simple_networking/modules/signal_r/models/period_prices_model.dart';
import 'package:simple_networking/modules/signal_r/models/price_accuracies.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/referral_info_model.dart';
import 'package:simple_networking/modules/signal_r/models/referral_stats_response_model.dart';
import 'package:http/http.dart' as http;

class SignalRModule {
  SignalRModule({
    required this.options,
    required this.refreshToken,
    required this.signalRClient,
    required this.token,
    required this.localeName,
    required this.deviceUid,
    this.isDebug = false,
  });

  final SimpleOptions options;
  final Future<RefreshTokenStatus> Function() refreshToken;
  final http.BaseClient signalRClient;
  final String token;
  final String localeName;
  final String deviceUid;

  final bool isDebug;

  static final _logger = Logger('SignalRService');

  final log = logPrint.Logger();

  static const _pingTime = 3;
  static const _reconnectTime = 5;

  Timer? _pongTimer;
  Timer? _pingTimer;
  Timer? _reconnectTimer;

  /// Is Module Disconnecting
  bool isDisconnecting = false;

  /// connection is not restartable if it is stopped you cannot
  /// restart it - you need to create a new connection.
  HubConnection? _connection;

  StreamController<AssetsModel> _assetsController =
      StreamController<AssetsModel>();
  StreamController<BalancesModel> _balancesController =
      StreamController<BalancesModel>();
  StreamController<InstrumentsModel> _instrumentsController =
      StreamController<InstrumentsModel>();
  StreamController<MarketReferencesModel> _marketReferencesController =
      StreamController<MarketReferencesModel>();
  StreamController<BasePricesModel> _basePricesController =
      StreamController<BasePricesModel>();
  StreamController<PeriodPricesModel> _periodPricesController =
      StreamController<PeriodPricesModel>();
  StreamController<ClientDetailModel> _clientDetailController =
      StreamController<ClientDetailModel>();
  StreamController<AssetWithdrawalFeeModel> _assetWithdrawalFeeController =
      StreamController<AssetWithdrawalFeeModel>();
  StreamController<KeyValueModel> _keyValueController =
      StreamController<KeyValueModel>();
  StreamController<CampaignResponseModel> _campaignsBannersController =
      StreamController<CampaignResponseModel>();
  StreamController<ReferralStatsResponseModel> _referralStatsController =
      StreamController<ReferralStatsResponseModel>();
  StreamController<IndicesModel> _indicesController =
      StreamController<IndicesModel>();
  StreamController<KycCountriesResponseModel> _kycCountriesController =
      StreamController<KycCountriesResponseModel>();
  StreamController<PriceAccuracies> _priceAccuraciesController =
      StreamController<PriceAccuracies>();
  StreamController<TotalMarketInfoModel> _marketInfoController =
      StreamController<TotalMarketInfoModel>();
  StreamController<AssetPaymentMethods> _assetPaymentMethodsController =
      StreamController<AssetPaymentMethods>();
  StreamController<BlockchainsModel> _blockchainsController =
      StreamController<BlockchainsModel>();
  StreamController<ReferralInfoModel> _referralInfoController =
      StreamController<ReferralInfoModel>();
  StreamController<RecurringBuysResponseModel> _recurringBuyController =
      StreamController<RecurringBuysResponseModel>();
  StreamController<List<EarnOfferModel>> _earnOfferController =
      StreamController<List<EarnOfferModel>>();
  StreamController<EarnProfileModel> _earnProfileController =
      StreamController<EarnProfileModel>();
  StreamController<CardLimitsModel> _cardLimitsController =
      StreamController<CardLimitsModel>();
  StreamController<CardsModel> _cardsController =
      StreamController<CardsModel>();

  StreamController<bool> _inifFinishedController = StreamController<bool>();

  StreamController<NftCollections> _nftCollectionController =
      StreamController<NftCollections>();
  StreamController<NFTMarkets> _nftMarketController =
      StreamController<NFTMarkets>();
  StreamController<NftPortfolio> _nftPortfolio =
      StreamController<NftPortfolio>();
  StreamController<FireblockEventsModel> _fireblockEvents =
      StreamController<FireblockEventsModel>();

  /// This variable is created to track previous snapshot of base prices.
  /// This needed because when signlaR gets update from basePrices it
  /// recevies only prices that changed, this results in overriding prices
  /// that didn't changed with zeros.
  var _oldBasePrices = const BasePricesModel(
    prices: [],
  );

  Future<void> recreateSignalR() async {
    _assetsController = StreamController<AssetsModel>();
    _balancesController = StreamController<BalancesModel>();
    _instrumentsController = StreamController<InstrumentsModel>();
    _marketReferencesController = StreamController<MarketReferencesModel>();
    _basePricesController = StreamController<BasePricesModel>();
    _periodPricesController = StreamController<PeriodPricesModel>();
    _clientDetailController = StreamController<ClientDetailModel>();
    _assetWithdrawalFeeController = StreamController<AssetWithdrawalFeeModel>();
    _keyValueController = StreamController<KeyValueModel>();
    _campaignsBannersController = StreamController<CampaignResponseModel>();
    _referralStatsController = StreamController<ReferralStatsResponseModel>();
    _indicesController = StreamController<IndicesModel>();
    _kycCountriesController = StreamController<KycCountriesResponseModel>();
    _priceAccuraciesController = StreamController<PriceAccuracies>();
    _marketInfoController = StreamController<TotalMarketInfoModel>();
    _assetPaymentMethodsController = StreamController<AssetPaymentMethods>();
    _blockchainsController = StreamController<BlockchainsModel>();
    _referralInfoController = StreamController<ReferralInfoModel>();
    _recurringBuyController = StreamController<RecurringBuysResponseModel>();
    _earnOfferController = StreamController<List<EarnOfferModel>>();
    _earnProfileController = StreamController<EarnProfileModel>();
    _cardLimitsController = StreamController<CardLimitsModel>();
    _cardsController = StreamController<CardsModel>();

    _inifFinishedController = StreamController<bool>();

    _nftCollectionController = StreamController<NftCollections>();
    _nftMarketController = StreamController<NFTMarkets>();
    _nftPortfolio = StreamController<NftPortfolio>();
    _fireblockEvents = StreamController<FireblockEventsModel>();
  }

  Future<void> clearSignalR() async {
    _oldBasePrices = const BasePricesModel(
      prices: [],
    );

    /*
    _assetsController.close();
    _balancesController.close();
    _instrumentsController.close();
    _marketReferencesController.close();
    _basePricesController.close();
    _periodPricesController.close();
    _clientDetailController.close();
    _assetWithdrawalFeeController.close();
    _keyValueController.close();
    _campaignsBannersController.close();
    _referralStatsController.close();
    _indicesController.close();
    _kycCountriesController.close();
    _priceAccuraciesController.close();
    _marketInfoController.close();
    _assetPaymentMethodsController.close();
    _blockchainsController.close();
    _referralInfoController.close();
    _recurringBuyController.close();
    _earnOfferController.close();
    _earnProfileController.close();
    _cardLimitsController.close();
    _cardsController.close();
    _inifFinishedController.close();
    */
  }

  showEror(String message) {
    if (isDebug) {
      log.e(message);
    }
  }

  // ignore: long-method
  Future<void> init() async {
    await recreateSignalR();

    isDisconnecting = false;

    _connection = HubConnectionBuilder()
        .withUrl(
          options.walletApiSignalR!,
          HttpConnectionOptions(
            client: signalRClient,
            //logging: (level, message) => log.d(message),
          ),
        )
        .build();

    _connection?.on(cardsMessage, (data) {
      try {
        final cardsList = CardsModel.fromJson(_json(data));
        _cardsController.add(cardsList);
      } catch (e) {
        _logger.log(contract, cardsMessage, e);

        showEror(e.toString());
      }
    });

    _connection?.on(initFinished, (data) {
      try {
        _inifFinishedController.add(true);
      } catch (e) {
        _logger.log(contract, initFinished, e);

        showEror(e.toString());
      }
    });

    _connection?.on(cardLimitsMessage, (data) {
      try {
        final cardLimits = CardLimitsModel.fromJson(_json(data));
        _cardLimitsController.add(cardLimits);
      } catch (e) {
        _logger.log(contract, cardLimitsMessage, e);

        showEror(e.toString());
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

          showEror(e.toString());
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

          showEror(e.toString());
        }
      }
    });

    _connection?.on(kycCountriesMessage, (data) {
      try {
        final countries = KycCountriesResponseModel.fromJson(_json(data));
        _kycCountriesController.add(countries);
      } catch (e) {
        _logger.log(contract, kycCountriesMessage, e);

        showEror(e.toString());
      }
    });

    _connection?.on(marketInfoMessage, (data) {
      try {
        final model = MarketInfoModel.fromJson(_json(data));
        final info = model.totalMarketInfo;
        _marketInfoController.add(info);
      } catch (e) {
        _logger.log(contract, kycCountriesMessage, e);

        showEror(e.toString());
      }
    });

    _connection?.on(campaignsBannersMessage, (data) {
      try {
        final campaigns = CampaignResponseModel.fromJson(_json(data));

        _campaignsBannersController.add(campaigns);
      } catch (e) {
        _logger.log(contract, campaignsBannersMessage, e);

        showEror(e.toString());
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

        showEror(e.toString());
      }
    });

    _connection?.on(assetsMessage, (data) {
      try {
        final assets = AssetsModel.fromJson(_json(data));

        _assetsController.add(assets);
      } catch (e) {
        _logger.log(contract, assetsMessage, e);

        showEror(e.toString());
      }
    });

    _connection?.on(balancesMessage, (data) {
      try {
        final balances = BalancesModel.fromJson(_json(data));
        _balancesController.add(balances);
      } catch (e) {
        _logger.log(contract, balancesMessage, e);

        showEror(e.toString());
      }
    });

    _connection?.on(instrumentsMessage, (data) {
      try {
        final instruments = InstrumentsModel.fromJson(_json(data));
        _instrumentsController.add(instruments);
      } catch (e) {
        _logger.log(contract, instrumentsMessage, e);

        showEror(e.toString());
      }
    });

    _connection?.on(blockchainsMessage, (data) {
      try {
        final blockchains = BlockchainsModel.fromJson(_json(data));
        _blockchainsController.add(blockchains);
      } catch (e) {
        _logger.log(contract, blockchainsMessage, e);

        showEror(e.toString());
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

        showEror(e.toString());
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
        print(e);

        _logger.log(contract, basePricesMessage, e);

        showEror(e.toString());
      }
    });

    _connection?.on(periodPricesMessage, (data) {
      try {
        final basePrices = PeriodPricesModel.fromJson(_json(data));
        _periodPricesController.add(basePrices);
      } catch (e) {
        _logger.log(contract, periodPricesMessage, e);

        showEror(e.toString());
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

        showEror(e.toString());
      }
    });

    _connection?.on(assetWithdrawalFeeMessage, (data) {
      try {
        final assetFees = AssetWithdrawalFeeModel.fromJson(_json(data));
        _assetWithdrawalFeeController.add(assetFees);
      } catch (e) {
        _logger.log(contract, assetWithdrawalFeeMessage, e);

        showEror(e.toString());
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

        showEror(e.toString());
      }
    });

    _connection?.on(indicesMessage, (data) {
      try {
        final indices = IndicesModel.fromJson(_json(data));
        _indicesController.add(indices);
      } catch (e) {
        _logger.log(contract, indicesMessage, e);

        showEror(e.toString());
      }
    });

    _connection?.on(convertPriceSettingsMessage, (data) {
      try {
        final settings = PriceAccuracies.fromJson(_json(data));
        _priceAccuraciesController.add(settings);
      } catch (e) {
        _logger.log(contract, convertPriceSettingsMessage, e);

        showEror(e.toString());
      }
    });

    _connection?.on(paymentMethodsMessage, (data) {
      try {
        final info = AssetPaymentMethods.fromJson(_json(data));

        _assetPaymentMethodsController.add(info);
      } catch (e) {
        _logger.log(contract, paymentMethodsMessage, e);

        showEror(e.toString());
      }
    });

    _connection?.on(referralInfoMessage, (data) {
      try {
        final info = ReferralInfoModel.fromJson(_json(data));

        _referralInfoController.add(info);
      } catch (e) {
        _logger.log(contract, referralInfoMessage, e);

        showEror(e.toString());
      }
    });

    _connection?.on(nftCollectionsMessage, (data) {
      try {
        final collection = NftCollections.fromJson(_json(data));

        _nftCollectionController.add(collection);
      } catch (e) {
        _logger.log(contract, nftCollectionsMessage, e);

        showEror(e.toString());

        log.e(e.toString());
      }
    });

    _connection?.on(nftMarketMessage, (data) {
      try {
        final market = NFTMarkets.fromJson(_json(data));

        _nftMarketController.add(market);
      } catch (e) {
        _logger.log(contract, nftMarketMessage, e);

        showEror(e.toString());

        log.e(e.toString());
      }
    });

    _connection?.on(nftPortfolioMessage, (data) {
      try {
        final nft = NftPortfolio.fromJson(_json(data));

        _nftPortfolio.add(nft);

        log.d(nft);
      } catch (e) {
        _logger.log(contract, nftMarketMessage, e);

        showEror(e.toString());

        log.e(e.toString());
      }
    });

    _connection?.on(fireblocksMessages, (data) {
      try {
        final fireblockEvents = FireblockEventsModel.fromJson(_json(data));

        _fireblockEvents.add(fireblockEvents);

        log.d(fireblockEvents);
      } catch (e) {
        _logger.log(contract, fireblocksMessages, e);

        showEror(e.toString());

        log.e(e.toString());
      }
    });

    try {
      await _connection?.start();
    } catch (e) {
      _logger.log(signalR, 'Failed to start connection', e);

      showEror('Failed to start connection');
      rethrow;
    }

    try {
      print('SIGNALR => invoke');
      print(token);
      print('$localeName $deviceUid $deviceType');

      await _connection?.invoke(
        initMessage,
        args: [token, localeName, deviceUid, deviceType],
      );
    } catch (e) {
      showEror(e.toString());
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

  Stream<AssetWithdrawalFeeModel> assetWithdrawalFee() =>
      _assetWithdrawalFeeController.stream;

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

  Stream<CardLimitsModel> cardLimits() => _cardLimitsController.stream;

  Stream<EarnProfileModel> earnProfile() => _earnProfileController.stream;

  Stream<bool> isAppLoaded() => _inifFinishedController.stream;

  Stream<CardsModel> cards() => _cardsController.stream;

  Stream<NftCollections> nftCollections() => _nftCollectionController.stream;

  Stream<NFTMarkets> nftMarket() => _nftMarketController.stream;

  Stream<NftPortfolio> nftPortfolio() => _nftPortfolio.stream;

  Stream<FireblockEventsModel> fireblockEvents() => _fireblockEvents.stream;

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
        _startReconnect();
      },
    );
  }

  void _startReconnect() {
    print('SIGNALR STARTRECONNECT');

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
    try {
      print('SIGNALR RECONNECT');

      await _connection?.stop();

      _pingTimer?.cancel();
      _pongTimer?.cancel();

      await refreshToken();

      await init();

      _reconnectTimer?.cancel();
    } catch (e) {}
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
    isDisconnecting = true;
    _pingTimer?.cancel();
    _pongTimer?.cancel();
    _reconnectTimer?.cancel();
    await _connection?.stop();

    clearSignalR();
  }

  /// Type cast response data from the SignalR
  Map<String, dynamic> _json(List<dynamic>? data) {
    return data?.first as Map<String, dynamic>;
  }
}
