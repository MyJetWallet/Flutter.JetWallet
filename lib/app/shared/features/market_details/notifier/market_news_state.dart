import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/services/market_news/model/market_news_response_model.dart';

part 'market_news_state.freezed.dart';

@freezed
class MarketNewsState with _$MarketNewsState {
  const factory MarketNewsState({
    required List<MarketNewsModel> news,
    required bool canLoadMore,
  }) = _MarketNewsState;
}
