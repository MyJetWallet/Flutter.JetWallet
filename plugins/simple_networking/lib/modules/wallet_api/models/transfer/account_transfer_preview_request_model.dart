import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'account_transfer_preview_request_model.freezed.dart';
part 'account_transfer_preview_request_model.g.dart';

@freezed
class AccountTransferPreviewRequestModel with _$AccountTransferPreviewRequestModel {
  const factory AccountTransferPreviewRequestModel({
    required String requestId,
    required String fromAssetSymbol,
    @DecimalSerialiser() required Decimal fromAmount,
    required CredentialsModel fromAccount,
    required CredentialsModel toAccount,
  }) = _AccountTransferPreviewRequestModel;

  factory AccountTransferPreviewRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AccountTransferPreviewRequestModelFromJson(json);
}

@freezed
class CredentialsModel with _$CredentialsModel {
  const factory CredentialsModel({
    required String accountId,
    required CredentialsType type,
  }) = _CredentialsModel;

  factory CredentialsModel.fromJson(Map<String, dynamic> json) => _$CredentialsModelFromJson(json);
}

enum CredentialsType {
  @JsonValue(0)
  clearjunctionAccount(analyticsValue: 'CJ'),
  @JsonValue(1)
  unlimitAccount(analyticsValue: 'Unlimit'),
  @JsonValue(2)
  unlimitCard(analyticsValue: 'V.Card');

  const CredentialsType({
    required this.analyticsValue,
  });

  final String analyticsValue;
}
