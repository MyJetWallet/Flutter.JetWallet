import 'package:freezed_annotation/freezed_annotation.dart';

part 'kyc_selfie_union.freezed.dart';

@freezed
class KycSelfieUnion with _$KycSelfieUnion {
  const factory KycSelfieUnion.input() = Input;
  const factory KycSelfieUnion.error(Object error) = Error;
  const factory KycSelfieUnion.done() = Done;
}
