import 'package:freezed_annotation/freezed_annotation.dart';

part 'preview_sell_union.freezed.dart';

@freezed
class PreviewSellUnion with _$PreviewSellUnion {
  const factory PreviewSellUnion.quoteLoading() = QuoteLoading;
  const factory PreviewSellUnion.quoteSuccess() = QuoteSuccess;
  const factory PreviewSellUnion.executeLoading() = ExecuteLoading;
  const factory PreviewSellUnion.executeSuccess() = ExecuteSuccess;
}
