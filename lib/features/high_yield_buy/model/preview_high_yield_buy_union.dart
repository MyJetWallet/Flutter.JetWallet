import 'package:freezed_annotation/freezed_annotation.dart';

part 'preview_high_yield_buy_union.freezed.dart';

@freezed
class PreviewHighYieldBuyUnion with _$PreviewHighYieldBuyUnion {
  const factory PreviewHighYieldBuyUnion.quoteLoading() = QuoteLoading;
  const factory PreviewHighYieldBuyUnion.quoteSuccess() = QuoteSuccess;
  const factory PreviewHighYieldBuyUnion.executeLoading() = ExecuteLoading;
  const factory PreviewHighYieldBuyUnion.executeSuccess() = ExecuteSuccess;
}
