import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../service/services/circle/model/circle_card.dart';
import 'payment_methods_union.dart';

part 'payment_methods_state.freezed.dart';

@freezed
class PaymentMethodsState with _$PaymentMethodsState {
  const factory PaymentMethodsState({
    @Default([]) List<CircleCard> cards,
    @Default(Loading()) PaymentMethodsUnion union,
  }) = _PaymentMethodsState;
}
