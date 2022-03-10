import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_methods_union.freezed.dart';

@freezed
class PaymentMethodsUnion with _$PaymentMethodsUnion {
  const factory PaymentMethodsUnion.loading() = Loading;
  const factory PaymentMethodsUnion.success() = Success;
}
