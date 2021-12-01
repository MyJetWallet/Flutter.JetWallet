import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../service/services/news/model/news_response_model.dart';

part 'education_news_state.freezed.dart';

@freezed
class NewsState with _$NewsState {
  const factory NewsState({
    required List<NewsModel> news,
    required bool canLoadMore,
    required int newsPortionAmount,
  }) = _NewsState;
}
