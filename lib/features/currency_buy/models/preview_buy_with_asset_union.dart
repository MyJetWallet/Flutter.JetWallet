import 'package:freezed_annotation/freezed_annotation.dart';

part 'preview_buy_with_asset_union.freezed.dart';

@freezed
class PreviewBuyWithAssetUnion with _$PreviewBuyWithAssetUnion {
  const factory PreviewBuyWithAssetUnion.quoteLoading() = QuoteLoading;
  const factory PreviewBuyWithAssetUnion.quoteSuccess() = QuoteSuccess;
  const factory PreviewBuyWithAssetUnion.executeLoading() = ExecuteLoading;
  const factory PreviewBuyWithAssetUnion.executeSuccess() = ExecuteSuccess;
}
