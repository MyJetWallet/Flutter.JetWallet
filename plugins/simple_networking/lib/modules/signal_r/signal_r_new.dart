import 'dart:async';

import 'package:logger/logger.dart' as logPrint;
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
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
import 'package:simple_networking/modules/signal_r/models/indices_model.dart';
import 'package:simple_networking/modules/signal_r/models/instruments_model.dart';
import 'package:simple_networking/modules/signal_r/models/key_value_model.dart';
import 'package:simple_networking/modules/signal_r/models/kyc_countries_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/market_info_model.dart';
import 'package:simple_networking/modules/signal_r/models/market_references_model.dart';
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
  });

  final SimpleOptions options;
  final Future<RefreshTokenStatus> Function() refreshToken;
  final http.BaseClient signalRClient;
  final String token;
  final String localeName;
  final String deviceUid;

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

  BehaviorSubject<AssetsModel> _assetsController =
      BehaviorSubject<AssetsModel>();
  BehaviorSubject<BalancesModel> _balancesController =
      BehaviorSubject<BalancesModel>();
  BehaviorSubject<InstrumentsModel> _instrumentsController =
      BehaviorSubject<InstrumentsModel>();
  BehaviorSubject<MarketReferencesModel> _marketReferencesController =
      BehaviorSubject<MarketReferencesModel>();
  BehaviorSubject<BasePricesModel> _basePricesController =
      BehaviorSubject<BasePricesModel>();
  BehaviorSubject<PeriodPricesModel> _periodPricesController =
      BehaviorSubject<PeriodPricesModel>();
  BehaviorSubject<ClientDetailModel> _clientDetailController =
      BehaviorSubject<ClientDetailModel>();
  BehaviorSubject<AssetWithdrawalFeeModel> _assetWithdrawalFeeController =
      BehaviorSubject<AssetWithdrawalFeeModel>();
  BehaviorSubject<KeyValueModel> _keyValueController =
      BehaviorSubject<KeyValueModel>();
  BehaviorSubject<CampaignResponseModel> _campaignsBannersController =
      BehaviorSubject<CampaignResponseModel>();
  BehaviorSubject<ReferralStatsResponseModel> _referralStatsController =
      BehaviorSubject<ReferralStatsResponseModel>();
  BehaviorSubject<IndicesModel> _indicesController =
      BehaviorSubject<IndicesModel>();
  BehaviorSubject<KycCountriesResponseModel> _kycCountriesController =
      BehaviorSubject<KycCountriesResponseModel>();
  BehaviorSubject<PriceAccuracies> _priceAccuraciesController =
      BehaviorSubject<PriceAccuracies>();
  BehaviorSubject<TotalMarketInfoModel> _marketInfoController =
      BehaviorSubject<TotalMarketInfoModel>();
  BehaviorSubject<AssetPaymentMethods> _assetPaymentMethodsController =
      BehaviorSubject<AssetPaymentMethods>();
  BehaviorSubject<BlockchainsModel> _blockchainsController =
      BehaviorSubject<BlockchainsModel>();
  BehaviorSubject<ReferralInfoModel> _referralInfoController =
      BehaviorSubject<ReferralInfoModel>();
  BehaviorSubject<RecurringBuysResponseModel> _recurringBuyController =
      BehaviorSubject<RecurringBuysResponseModel>();
  BehaviorSubject<List<EarnOfferModel>> _earnOfferController =
      BehaviorSubject<List<EarnOfferModel>>();
  BehaviorSubject<EarnProfileModel> _earnProfileController =
      BehaviorSubject<EarnProfileModel>();
  BehaviorSubject<CardLimitsModel> _cardLimitsController =
      BehaviorSubject<CardLimitsModel>();
  BehaviorSubject<CardsModel> _cardsController = BehaviorSubject<CardsModel>();

  BehaviorSubject<bool> _inifFinishedController = BehaviorSubject<bool>();
}
