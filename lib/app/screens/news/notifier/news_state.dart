import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/services/news/model/news_response_model.dart';

import 'news_union.dart';

part 'news_state.freezed.dart';

@freezed
class NewsState with _$NewsState {
  const factory NewsState({
    @Default(Loading()) NewsUnion union,
    @Default(false) bool nothingToLoad,
    @Default([]) List<NewsModel> newsItems,
  }) = _NewsState;
}
