import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/config/constants.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_response_model.dart';

part 'key_value_model.freezed.dart';
part 'key_value_model.g.dart';

@freezed
class KeyValueModel with _$KeyValueModel {
  const factory KeyValueModel({
    WatchlistModel? watchlist,
    WatchlistModel? favoritesInstruments,
    WatchlistModel? viewedRewards,
    WatchlistModel? cards,
    String? lastUsedPaymentMethod,
    required double now,
    required List<KeyValueResponseModel> keys,
  }) = _KeyValueModel;

  factory KeyValueModel.fromJson(Map<String, dynamic> json) =>
      _$KeyValueModelFromJson(json);

  /// Takes [KeyValueModel] and parses it according to [KeyValueKeys]
  factory KeyValueModel.parsed(KeyValueModel keyValue) {
    var parsedKeyValue = keyValue;

    for (final pair in keyValue.keys) {
      if (pair.key == watchlistKey) {
        parsedKeyValue = parsedKeyValue.copyWith(
          watchlist: WatchlistModel.fromJson(pair.toJson()),
        );
      } else if (pair.key == cardsKey) {
        parsedKeyValue = parsedKeyValue.copyWith(
          cards: WatchlistModel.fromJson(pair.toJson()),
        );
      } else if (pair.key == lastUsedPaymentMethod) {
        parsedKeyValue = parsedKeyValue.copyWith(
          lastUsedPaymentMethod: pair.value,
        );
      } else if (pair.key == viewedRewardsKey) {
        parsedKeyValue = parsedKeyValue.copyWith(
          viewedRewards: WatchlistModel.fromJson(pair.toJson()),
        );
      } else if (pair.key == favoritesInstrumentsKey) {
        parsedKeyValue = parsedKeyValue.copyWith(
          favoritesInstruments: WatchlistModel.fromJson(pair.toJson()),
        );
      }
    }

    return parsedKeyValue;
  }
}

@freezed
class WatchlistModel with _$WatchlistModel {
  const factory WatchlistModel({
    required String key,
    required List<String> value,
  }) = _WatchlistModel;

  factory WatchlistModel.fromJson(Map<String, dynamic> json) => WatchlistModel(
        key: json['key'].toString(),
        value: (jsonDecode(json['value'].toString()) as List<dynamic>)
            .cast<String>(),
      );
}
