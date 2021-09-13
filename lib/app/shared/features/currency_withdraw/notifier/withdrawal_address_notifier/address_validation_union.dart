import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_validation_union.freezed.dart';

@freezed
class AddressValidationUnion with _$AddressValidationUnion {
  const factory AddressValidationUnion.hide() = Hide;
  const factory AddressValidationUnion.invalid() = Invalid;
  const factory AddressValidationUnion.loading() = Loading;
  const factory AddressValidationUnion.valid() = Valid;
}
