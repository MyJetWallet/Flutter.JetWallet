import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../service/services/wallet/model/news/news_response_model.dart';

part 'news_state.freezed.dart';

@freezed
class NewsState with _$NewsState {
  const factory NewsState({
    required List<NewsModel> news,
  }) = _NewsState;

  const NewsState._();

  bool get isReadMore => news.length == 3;
}
