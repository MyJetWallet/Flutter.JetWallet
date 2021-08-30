import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../app/shared/features/key_value/model/key_value_key.dart';
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

  factory KeyValueModel.fromModel(KeyValueModel keyValue) {
    var serializedKeyValue = keyValue;

    for (final keyValuePair in keyValue.keys) {
      if (keyValuePair.key == KeyValueKey.watchlist) {
        serializedKeyValue = keyValue.copyWith(
          watchlist: WatchlistModel.fromJson(keyValuePair.toJson()),
        );
      }
    }

    return serializedKeyValue;
  }
}

@freezed
class WatchlistModel with _$WatchlistModel {
  const factory WatchlistModel({
    required String key,
    required List<String> value,
  }) = _WatchlistModel;

  factory WatchlistModel.fromJson(Map<String, dynamic> json) =>
      WatchlistModel(
        key: json['key'].toString(),
        value: (jsonDecode(
          json['value'].toString(),
        ) as List<dynamic>).cast<String>(),
      );
}

