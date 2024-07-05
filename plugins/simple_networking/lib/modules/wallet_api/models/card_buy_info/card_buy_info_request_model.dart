import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_buy_info_request_model.freezed.dart';
part 'card_buy_info_request_model.g.dart';

@freezed
class CardBuyInfoRequestModel with _$CardBuyInfoRequestModel {
  const factory CardBuyInfoRequestModel({
    String? paymentId,
  }) = _CardBuyInfoRequestModel;

  factory CardBuyInfoRequestModel.fromJson(Map<String, dynamic> json) => _$CardBuyInfoRequestModelFromJson(json);
}
