import 'package:freezed_annotation/freezed_annotation.dart';

import '../circle_card.dart';

part 'all_cards_response_model.freezed.dart';

@freezed
class AllCardsResponseModel with _$AllCardsResponseModel {
  const factory AllCardsResponseModel({
    required List<CircleCard> cards,
  }) = _AllCardsResponseModel;

  factory AllCardsResponseModel.fromList(List<dynamic> list) {
    return AllCardsResponseModel(
      cards: list.map((e) => CircleCard.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
