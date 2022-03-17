import 'package:freezed_annotation/freezed_annotation.dart';

part 'validate_address_request_model.freezed.dart';
part 'validate_address_request_model.g.dart';

@freezed
class ValidateAddressRequestModel with _$ValidateAddressRequestModel {
  const factory ValidateAddressRequestModel({
    String? toTag,
    required String assetSymbol,
    required String toAddress,
    required String assetNetwork,
  }) = _ValidateAddressRequestModel;

  factory ValidateAddressRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ValidateAddressRequestModelFromJson(json);
}
