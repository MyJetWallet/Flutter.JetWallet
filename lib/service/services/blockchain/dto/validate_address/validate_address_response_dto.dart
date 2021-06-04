import 'package:json_annotation/json_annotation.dart';

import '../../model/validate_address/validate_address_response_model.dart';

part 'validate_address_response_dto.g.dart';

@JsonSerializable()
class ValidateAddressResponseDto {
  ValidateAddressResponseDto({
    required this.isValid,
  });

  factory ValidateAddressResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ValidateAddressResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ValidateAddressResponseDtoToJson(this);

  ValidateAddressResponseModel toModel() {
    return ValidateAddressResponseModel(
      isValid: isValid,
    );
  }

  final bool isValid;
}
