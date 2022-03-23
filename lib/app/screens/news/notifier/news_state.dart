import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../service/services/news/model/news_response_model.dart';
import 'news_union.dart';

part 'news_state.freezed.dart';

@freezed
class NewsState with _$NewsState {
  const factory NewsState({
    required List<NewsModel> newsItems,
    @Default(Loading()) NewsUnion union,
    @Default(false) bool nothingToLoad,
  }) = _NewsState;
}
