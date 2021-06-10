import 'package:freezed_annotation/freezed_annotation.dart';

part 'convert_union.freezed.dart';

@freezed
class ConvertUnion with _$ConvertUnion {
  const factory ConvertUnion.requestQuote([String? error]) = RequestQuote;
  const factory ConvertUnion.loading() = Loading;
  const factory ConvertUnion.responseQuote() = ResponseQuote;
}
