import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'kyc_selfie_union.dart';

part 'kyc_selfie_state.freezed.dart';

@freezed
class KycSelfieState with _$KycSelfieState {
  const factory KycSelfieState({
    File? selfie,
    @Default(Input()) KycSelfieUnion union,
  }) = _KycSelfieState;

  const KycSelfieState._();

  bool get isSelfieNotEmpty {
    return selfie != null;
  }
}
