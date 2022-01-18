import 'package:freezed_annotation/freezed_annotation.dart';
import '../../model/kyc_verified_model.dart';

part 'kyc_state.freezed.dart';

@freezed
class KycState with _$KycState {
  const factory KycState({
    @Default([]) List<KycModel> requiredVerifications,
  }) = _KycState;
}
