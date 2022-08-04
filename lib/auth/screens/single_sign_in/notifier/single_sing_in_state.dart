import 'package:freezed_annotation/freezed_annotation.dart';
import 'single_sing_in_union.dart';

part 'single_sing_in_state.freezed.dart';

@freezed
class SingleSingInState with _$SingleSingInState {
  const factory SingleSingInState({
    @Default(Input()) SingleSingInStateUnion union,
  }) = _SingleSingInState;
}
