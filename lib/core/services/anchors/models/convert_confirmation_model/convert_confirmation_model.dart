import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jetwallet/core/services/anchors/anchors_service.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'convert_confirmation_model.freezed.dart';

part 'convert_confirmation_model.g.dart';

///
/// Model created for [AnchorsService]
/// Any changes must be coordinated with all developers
///

@freezed
class ConvertConfirmationModel with _$ConvertConfirmationModel {
  const factory ConvertConfirmationModel({
    required String fromAsset,
    required String toAsset,
    @DecimalSerialiser() required Decimal fromAmount,
    @DecimalSerialiser() required Decimal toAmount,
    required bool isFromFixed,
  }) = _ConvertConfirmationModel;

  factory ConvertConfirmationModel.fromJson(Map<String, dynamic> json) => _$ConvertConfirmationModelFromJson(json);
}
