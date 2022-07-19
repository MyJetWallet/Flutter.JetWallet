import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/services/signal_r/model/cards_model.dart';

part 'bottom_navigation_state.freezed.dart';

@freezed
class BottomNavigationState with _$BottomNavigationState {
  const factory BottomNavigationState({
    @Default([]) List<String> cardsIds,
    CardsModel? cards,
    @Default(false) bool cardNotification,
  }) = _BottomNavigationState;
}
