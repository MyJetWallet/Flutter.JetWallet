import 'package:freezed_annotation/freezed_annotation.dart';

import '../circle_card.dart';

part 'all_cards_response_model.freezed.dart';
part 'all_cards_response_model.g.dart';

@freezed
class AllCardsResponseModel with _$AllCardsResponseModel {
  const factory AllCardsResponseModel({
    required List<CircleCard> cards,
  }) = _AllCardsResponseModel;

  factory AllCardsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AllCardsResponseModelFromJson(json);
}
