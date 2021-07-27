import 'package:freezed_annotation/freezed_annotation.dart';

part 'convert_union.freezed.dart';

@freezed
class ConvertUnion with _$ConvertUnion {
  const factory ConvertUnion.quoteLoading() = QuoteLoading;
  const factory ConvertUnion.quoteRefresh() = QuoteRefresh;
  const factory ConvertUnion.quoteSuccess() = QuoteSuccess;
  const factory ConvertUnion.quoteError() = QuoteError;
  const factory ConvertUnion.executeLoading() = ExecuteLoading;
  const factory ConvertUnion.executeSuccess() = ExecuteSuccess;
  const factory ConvertUnion.executeError() = ExecuteError;
}
