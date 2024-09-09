import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_sectors_message_model.freezed.dart';
part 'market_sectors_message_model.g.dart';

@freezed
class MarketSectorsMessageModel with _$MarketSectorsMessageModel {
  const factory MarketSectorsMessageModel({
    @Default([]) List<MarketSectorModel> sectors,
  }) = _MarketSectorsMessageModel;

  factory MarketSectorsMessageModel.fromJson(Map<String, dynamic> json) => _$MarketSectorsMessageModelFromJson(json);
}

@freezed
class MarketSectorModel with _$MarketSectorModel {
  const factory MarketSectorModel({
    @Default('') String id,
    @Default('') String title,
    @Default('') String description,
    @Default('') String imageUrl,
    @Default(0) int weight,
    @Default('') String bigImageUrl,
  }) = _MarketSectorModel;

  factory MarketSectorModel.fromJson(Map<String, dynamic> json) => _$MarketSectorModelFromJson(json);
}
