import 'package:freezed_annotation/freezed_annotation.dart';

part 'invest_transfer_response_model.freezed.dart';
part 'invest_transfer_response_model.g.dart';

@freezed
class InvestTransferResponseModel with _$InvestTransferResponseModel {
  factory InvestTransferResponseModel({
    required bool isTransfered,
  }) = _InvestTransferResponseModel;

  factory InvestTransferResponseModel.fromJson(Map<String, dynamic> json) =>
      _$InvestTransferResponseModelFromJson(json);
}
