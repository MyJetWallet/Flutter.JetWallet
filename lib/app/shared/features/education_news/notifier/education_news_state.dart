import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../service/services/education_news/model/education_news_response_model.dart';

part 'education_news_state.freezed.dart';

@freezed
class EducationNewsState with _$EducationNewsState {
  const factory EducationNewsState({
    required List<EducationNewsModel> news,
    required bool canLoadMore,
    required int newsPortionAmount,
  }) = _EducationNewsState;
}
