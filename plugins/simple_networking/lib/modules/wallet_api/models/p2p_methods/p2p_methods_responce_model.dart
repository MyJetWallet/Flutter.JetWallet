import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'p2p_methods_responce_model.freezed.dart';
part 'p2p_methods_responce_model.g.dart';

@freezed
class P2PMethodsResponceModel with _$P2PMethodsResponceModel {
  const factory P2PMethodsResponceModel({
    @Default([]) List<P2PMethodModel> methods,
  }) = _P2PMethodsResponceModel;

  factory P2PMethodsResponceModel.fromJson(Map<String, dynamic> json) => _$P2PMethodsResponceModelFromJson(json);
}

@freezed
class P2PMethodModel with _$P2PMethodModel {
  const factory P2PMethodModel({
    required String methodId,
    @JsonKey(unknownEnumValue: P2PMethodType.unknown) required P2PMethodType type,
    required String asset,
    required int weight,
    required String name,
    required String description,
    @DecimalNullSerialiser() Decimal? minAmount,
    @DecimalNullSerialiser() Decimal? maxAmount,
    @Default([]) List<String> countries,
  }) = _P2PMethodModel;

  factory P2PMethodModel.fromJson(Map<String, dynamic> json) => _$P2PMethodModelFromJson(json);
}

enum P2PMethodType {
  @JsonValue(0)
  cardNumber,
  @JsonValue(1)
  iban,
  @JsonValue(2)
  mobilePhone,
  @JsonValue(3)
  paytm,
  @JsonValue(4)
  upi,
  @JsonValue(5)
  imps,
  @JsonValue(6)
  bankAccount,
  @JsonValue(7)
  ibanWithName,
  @JsonValue(8)
  bankAccountWithBankName,
  @JsonValue(9)
  wise,
  @JsonValue(-1)
  unknown,
}
