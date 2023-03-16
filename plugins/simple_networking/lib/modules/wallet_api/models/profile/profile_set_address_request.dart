import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_set_address_request.freezed.dart';
part 'profile_set_address_request.g.dart';

@freezed
class ProfileSetAddressRequestModel with _$ProfileSetAddressRequestModel {
  factory ProfileSetAddressRequestModel({
    String? addressLine1,
    String? addressLine2,
    String? buildingNumber,
    String? city,
    String? state,
    String? postalCode,
    String? country,
  }) = _ProfileSetAddressRequestModel;

  factory ProfileSetAddressRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileSetAddressRequestModelFromJson(json);
}
