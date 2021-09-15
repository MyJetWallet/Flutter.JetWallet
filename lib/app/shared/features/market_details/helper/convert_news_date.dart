import '../../../../../service/services/news/model/news_response_model.dart';

List<NewsModel> convertNewsDate(List<NewsModel> news) {
  for (final item in news) {
    final index = news.indexOf(item);

    news[index] = news[index].copyWith(
      timestamp:
          DateTime.parse('${news[index].timestamp}Z').toLocal().toString(),
    );
  }

  return news;
}
