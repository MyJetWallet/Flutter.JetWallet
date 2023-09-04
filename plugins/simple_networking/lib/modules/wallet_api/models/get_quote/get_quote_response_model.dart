import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';

part 'get_quote_response_model.freezed.dart';
part 'get_quote_response_model.g.dart';

@freezed
class GetQuoteResponseModel with _$GetQuoteResponseModel {
  const factory GetQuoteResponseModel({
    required bool isFromFixed,
    required String operationId,
    required String feeAsset,
    RecurringBuyInfoModel? recurringBuyInfo,
    @DecimalSerialiser() required Decimal price,
    @JsonKey(name: 'fromAsset') required String fromAssetSymbol,
    @JsonKey(name: 'toAsset') required String toAssetSymbol,
    @DecimalSerialiser()
    @JsonKey(name: 'fromAssetVolume')
    required Decimal fromAssetAmount,
    @DecimalSerialiser()
    @JsonKey(name: 'toAssetVolume')
    required Decimal toAssetAmount,
    @JsonKey(name: 'actualTimeInSecond') required int expirationTime,
    @DecimalSerialiser() required Decimal feeAmount,
    @DecimalSerialiser()
    @JsonKey(name: 'feePercentage')
    required Decimal feePercent,
  }) = _GetQuoteResponseModel;

  factory GetQuoteResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetQuoteResponseModelFromJson(json);
}

@freezed
class RecurringBuyInfoModel with _$RecurringBuyInfoModel {
  const factory RecurringBuyInfoModel({
    required RecurringBuysType scheduleType,
    required String nextExecutionTime,
  }) = _RecurringBuyInfoModel;

  factory RecurringBuyInfoModel.fromJson(Map<String, dynamic> json) =>
      _$RecurringBuyInfoModelFromJson(json);
}
