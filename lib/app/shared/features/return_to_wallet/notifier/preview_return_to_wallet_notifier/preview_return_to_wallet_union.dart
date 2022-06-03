import 'package:freezed_annotation/freezed_annotation.dart';

part 'preview_return_to_wallet_union.freezed.dart';

@freezed
class PreviewReturnToWalletUnion with _$PreviewReturnToWalletUnion {
  const factory PreviewReturnToWalletUnion.quoteLoading() = QuoteLoading;
  const factory PreviewReturnToWalletUnion.quoteSuccess() = QuoteSuccess;
  const factory PreviewReturnToWalletUnion.executeLoading() = ExecuteLoading;
  const factory PreviewReturnToWalletUnion.executeSuccess() = ExecuteSuccess;
}
