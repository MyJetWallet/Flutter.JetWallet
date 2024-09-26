import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'fee_preview_response_model.freezed.dart';
part 'fee_preview_response_model.g.dart';

@freezed
class FeePreviewRepsonseModel with _$FeePreviewRepsonseModel {
  const factory FeePreviewRepsonseModel({
    @Default([]) List<NetworkPreviewModel> networks,
  }) = _FeePreviewRepsonseModel;

  factory FeePreviewRepsonseModel.fromJson(Map<String, dynamic> json) => _$FeePreviewRepsonseModelFromJson(json);
}

@freezed
class NetworkPreviewModel with _$NetworkPreviewModel {
  const factory NetworkPreviewModel({
    required String network,
    required String description,
    @DecimalSerialiser() required Decimal feeAmount,
    required String feeAsset,
    required int time,
  }) = _NetworkPreviewModel;

  factory NetworkPreviewModel.fromJson(Map<String, dynamic> json) => _$NetworkPreviewModelFromJson(json);
}
