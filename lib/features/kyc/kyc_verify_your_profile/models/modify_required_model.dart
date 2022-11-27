import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';

part 'modify_required_model.freezed.dart';

@freezed
class ModifyRequiredVerified with _$ModifyRequiredVerified {
  const factory ModifyRequiredVerified({
    RequiredVerified? requiredVerified,
    @Default(false) bool verifiedDone,
  }) = _ModifyRequiredVerified;
}
