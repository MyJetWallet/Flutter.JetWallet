import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../shared/constants.dart';
import '../../key_value/model/key_value_response_model.dart';

part 'key_value_model.freezed.dart';
part 'key_value_model.g.dart';

@freezed
class KeyValueModel with _$KeyValueModel {
  const factory KeyValueModel({
    WatchlistModel? watchlist,
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
        parsedKeyValue = keyValue.copyWith(
          watchlist: WatchlistModel.fromJson(pair.toJson()),
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
