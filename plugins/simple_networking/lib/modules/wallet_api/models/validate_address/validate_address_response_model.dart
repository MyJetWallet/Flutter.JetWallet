import 'package:freezed_annotation/freezed_annotation.dart';

part 'validate_address_response_model.freezed.dart';
part 'validate_address_response_model.g.dart';

@freezed
class ValidateAddressResponseModel with _$ValidateAddressResponseModel {
  const factory ValidateAddressResponseModel({
    required bool isValid,

    /// Internal address doesn't have a fee on withdraw
    required bool isInternal,
    required bool isJar,
  }) = _ValidateAddressResponseModel;

  factory ValidateAddressResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ValidateAddressResponseModelFromJson(json);
}
