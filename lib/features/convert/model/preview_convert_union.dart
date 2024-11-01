import 'package:freezed_annotation/freezed_annotation.dart';

part 'preview_convert_union.freezed.dart';

@freezed
class PreviewConvertUnion with _$PreviewConvertUnion {
  const factory PreviewConvertUnion.quoteLoading() = QuoteLoading;
  const factory PreviewConvertUnion.quoteSuccess() = QuoteSuccess;
  const factory PreviewConvertUnion.executeLoading() = ExecuteLoading;
  const factory PreviewConvertUnion.executeSuccess() = ExecuteSuccess;
}
