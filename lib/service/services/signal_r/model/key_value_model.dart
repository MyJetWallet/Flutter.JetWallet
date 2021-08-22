import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'key_value_model.freezed.dart';
part 'key_value_model.g.dart';

@freezed
class KeyValueModel with _$KeyValueModel {
  const factory KeyValueModel({
    required double now,
    required List<KeyValuePairModel> keys,
    WatchlistModel? watchlist,
  }) = _KeyValueModel;

  factory KeyValueModel.fromJson(Map<String, dynamic> json) =>
      _$KeyValueModelFromJson(json);
}

@freezed
class KeyValuePairModel with _$KeyValuePairModel {
  const factory KeyValuePairModel({
    required String key,
    required String value,
  }) = _KeyValuePairModel;

  factory KeyValuePairModel.fromJson(Map<String, dynamic> json) =>
      _$KeyValuePairModelFromJson(json);
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

