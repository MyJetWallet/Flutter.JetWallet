import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'incoming_gift_model.freezed.dart';
part 'incoming_gift_model.g.dart';

@freezed
abstract class IncomingGiftModel with _$IncomingGiftModel {
  const factory IncomingGiftModel({
    @Default([]) List<IncomingGiftObject> gifts,
  }) = _IncomingGiftModel;

  factory IncomingGiftModel.fromJson(Map<String, dynamic> json) =>
      _$IncomingGiftModelFromJson(json);
}

@freezed
abstract class IncomingGiftObject with _$IncomingGiftObject {
  const factory IncomingGiftObject({
    required String id,
    @DecimalNullSerialiser() Decimal? amount,
    String? assetSymbol,
    String? fromName,
    DateTime? createdAt,
    DateTime? expireAt,
  }) = _IncomingGiftObject;

  factory IncomingGiftObject.fromJson(Map<String, dynamic> json) =>
      _$IncomingGiftObjectFromJson(json);
}
