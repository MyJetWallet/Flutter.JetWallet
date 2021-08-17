import 'package:freezed_annotation/freezed_annotation.dart';
import '../../model/market_item_model.dart';

part 'watchlist_state.freezed.dart';
part 'watchlist_state.g.dart';

@freezed
class WatchlistState with _$WatchlistState {
  const factory WatchlistState({
    required List<MarketItemModel> items,
  }) = _WatchlistState;

  factory WatchlistState.fromJson(Map<String, dynamic> json) =>
      _$WatchlistStateFromJson(json);
}
