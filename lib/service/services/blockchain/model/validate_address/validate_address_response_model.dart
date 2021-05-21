import 'package:freezed_annotation/freezed_annotation.dart';

part 'validate_address_response_model.freezed.dart';

@freezed
class ValidateAddressResponseModel with _$ValidateAddressResponseModel {
  const factory ValidateAddressResponseModel({
    required bool isValid,
  }) = _ValidateAddressResponseModel;
}
