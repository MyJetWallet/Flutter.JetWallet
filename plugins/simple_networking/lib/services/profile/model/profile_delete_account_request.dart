import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_delete_account_request.freezed.dart';
part 'profile_delete_account_request.g.dart';

@freezed
class ProfileDeleteAccountRequest with _$ProfileDeleteAccountRequest {
  factory ProfileDeleteAccountRequest({
    required final String tokenId,
    required final List<String> deletionReasonIds,
  }) = _ProfileDeleteAccountRequest;

  factory ProfileDeleteAccountRequest.fromJson(Map<String, dynamic> json) =>
      _$ProfileDeleteAccountRequestFromJson(json);
}
