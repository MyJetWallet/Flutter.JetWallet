import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_union.freezed.dart';

@freezed
class NewsUnion with _$NewsUnion {
  const factory NewsUnion.loading() = Loading;
  const factory NewsUnion.loaded() = Loaded;
  const factory NewsUnion.error() = Error;
}
