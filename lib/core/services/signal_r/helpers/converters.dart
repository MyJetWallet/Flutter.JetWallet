import 'package:jetwallet/features/kyc/models/kyc_country_model.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/models/nft_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/signal_r/models/campaign_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model.dart';
import 'package:simple_networking/modules/signal_r/models/indices_model.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';
import 'package:simple_networking/modules/signal_r/models/price_accuracies.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_model.dart';
import 'package:simple_networking/modules/signal_r/models/referral_stats_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/signalr_log.dart';
//import 'package:simple_networking/modules/signal_r/models/signalr_log.dart';

class ObservableEarnOfferModelListConverter implements JsonConverter<ObservableList<EarnOfferModel>, List<dynamic>> {
  const ObservableEarnOfferModelListConverter();

  @override
  ObservableList<EarnOfferModel> fromJson(List<dynamic> json) => ObservableList.of(
        json.cast<Map<String, dynamic>>().map(EarnOfferModel.fromJson),
      );

  @override
  List<Map<String, dynamic>> toJson(ObservableList<EarnOfferModel> list) => list.map((e) => e.toJson()).toList();
}

class ObservableRecurringBuysModelListConverter
    implements JsonConverter<ObservableList<RecurringBuysModel>, List<dynamic>> {
  const ObservableRecurringBuysModelListConverter();

  @override
  ObservableList<RecurringBuysModel> fromJson(List<dynamic> json) => ObservableList.of(
        json.cast<Map<String, dynamic>>().map(RecurringBuysModel.fromJson),
      );

  @override
  List<Map<String, dynamic>> toJson(ObservableList<RecurringBuysModel> list) => list.map((e) => e.toJson()).toList();
}

class ObservableKycCountryModelListConverter implements JsonConverter<ObservableList<KycCountryModel>, List<dynamic>> {
  const ObservableKycCountryModelListConverter();

  @override
  ObservableList<KycCountryModel> fromJson(List<dynamic> json) => ObservableList.of(
        json.cast<Map<String, dynamic>>().map(KycCountryModel.fromJson),
      );

  @override
  List<Map<String, dynamic>> toJson(ObservableList<KycCountryModel> list) => list.map((e) => e.toJson()).toList();
}

class ObservableCampaignModelListConverter implements JsonConverter<ObservableList<CampaignModel>, List<dynamic>> {
  const ObservableCampaignModelListConverter();

  @override
  ObservableList<CampaignModel> fromJson(List<dynamic> json) => ObservableList.of(
        json.cast<Map<String, dynamic>>().map(CampaignModel.fromJson),
      );

  @override
  List<Map<String, dynamic>> toJson(ObservableList<CampaignModel> list) => list.map((e) => e.toJson()).toList();
}

class ObservableReferralStatsModelListConverter
    implements JsonConverter<ObservableList<ReferralStatsModel>, List<dynamic>> {
  const ObservableReferralStatsModelListConverter();

  @override
  ObservableList<ReferralStatsModel> fromJson(List<dynamic> json) => ObservableList.of(
        json.cast<Map<String, dynamic>>().map(ReferralStatsModel.fromJson),
      );

  @override
  List<Map<String, dynamic>> toJson(ObservableList<ReferralStatsModel> list) => list.map((e) => e.toJson()).toList();
}

class ObservableMarketItemModelListConverter implements JsonConverter<ObservableList<MarketItemModel>, List<dynamic>> {
  const ObservableMarketItemModelListConverter();

  @override
  ObservableList<MarketItemModel> fromJson(List<dynamic> json) => ObservableList.of(
        json.cast<Map<String, dynamic>>().map(MarketItemModel.fromJson),
      );

  @override
  List<Map<String, dynamic>> toJson(ObservableList<MarketItemModel> list) => list.map((e) => e.toJson()).toList();
}

class ObservableIndexModelListConverter implements JsonConverter<ObservableList<IndexModel>, List<dynamic>> {
  const ObservableIndexModelListConverter();

  @override
  ObservableList<IndexModel> fromJson(List<dynamic> json) => ObservableList.of(
        json.cast<Map<String, dynamic>>().map(IndexModel.fromJson),
      );

  @override
  List<Map<String, dynamic>> toJson(ObservableList<IndexModel> list) => list.map((e) => e.toJson()).toList();
}

class ObservablePriceAccuracyListConverter implements JsonConverter<ObservableList<PriceAccuracy>, List<dynamic>> {
  const ObservablePriceAccuracyListConverter();

  @override
  ObservableList<PriceAccuracy> fromJson(List<dynamic> json) => ObservableList.of(
        json.cast<Map<String, dynamic>>().map(PriceAccuracy.fromJson),
      );

  @override
  List<Map<String, dynamic>> toJson(ObservableList<PriceAccuracy> list) => list.map((e) => e.toJson()).toList();
}

class ObservableNftModelListConverter implements JsonConverter<ObservableList<NftModel>, List<dynamic>> {
  const ObservableNftModelListConverter();

  @override
  ObservableList<NftModel> fromJson(List<dynamic> json) => ObservableList.of(
        json.cast<Map<String, dynamic>>().map(NftModel.fromJson),
      );

  @override
  List<Map<String, dynamic>> toJson(ObservableList<NftModel> list) => list.map((e) => e.toJson()).toList();
}

class ObservableNftMarketListConverter implements JsonConverter<ObservableList<NftMarket>, List<dynamic>> {
  const ObservableNftMarketListConverter();

  @override
  ObservableList<NftMarket> fromJson(List<dynamic> json) => ObservableList.of(
        json.cast<Map<String, dynamic>>().map(NftMarket.fromJson),
      );

  @override
  List<Map<String, dynamic>> toJson(ObservableList<NftMarket> list) => list.map((e) => e.toJson()).toList();
}

class ObservableSignalRLogsListConverter implements JsonConverter<ObservableList<SignalrLog>, List<dynamic>> {
  const ObservableSignalRLogsListConverter();

  @override
  ObservableList<SignalrLog> fromJson(List<dynamic> json) => ObservableList.of(
        json.cast<Map<String, dynamic>>().map(SignalrLog.fromJson),
      );

  @override
  List<Map<String, dynamic>> toJson(ObservableList<SignalrLog> list) => list.map((e) => e.toJson()).toList();
}
