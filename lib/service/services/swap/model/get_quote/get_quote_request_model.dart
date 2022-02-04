import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/decimal_serialiser.dart';

part 'get_quote_request_model.freezed.dart';
part 'get_quote_request_model.g.dart';

@freezed
class GetQuoteRequestModel with _$GetQuoteRequestModel {
  const factory GetQuoteRequestModel({
    @Default(true) bool isFromFixed,
    @DecimalSerialiser()
    @JsonKey(name: 'fromAssetVolume')
        Decimal? fromAssetAmount,
    @DecimalSerialiser() @JsonKey(name: 'toAssetVolume') Decimal? toAssetAmount,
    @JsonKey(name: 'fromAsset') required String fromAssetSymbol,
    @JsonKey(name: 'toAsset') required String toAssetSymbol,
  }) = _GetQuoteRequestModel;

  factory GetQuoteRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GetQuoteRequestModelFromJson(json);
}
