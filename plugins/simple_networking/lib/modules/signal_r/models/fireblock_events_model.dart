import 'package:freezed_annotation/freezed_annotation.dart';

part 'fireblock_events_model.freezed.dart';
part 'fireblock_events_model.g.dart';

@freezed
class FireblockEventsModel with _$FireblockEventsModel {
  factory FireblockEventsModel({
    List<FireblocksMessageModel>? events,
  }) = _FireblockEventsModel;

  factory FireblockEventsModel.fromJson(Map<String, dynamic> json) => _$FireblockEventsModelFromJson(json);
}

@freezed
class FireblocksMessageModel with _$FireblocksMessageModel {
  factory FireblocksMessageModel({
    String? messageId,
    String? eventType,
  }) = _FireblocksMessageModel;

  factory FireblocksMessageModel.fromJson(Map<String, dynamic> json) => _$FireblocksMessageModelFromJson(json);
}
