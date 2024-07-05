import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jetwallet/features/send_gift/store/receiver_datails_store.dart';
import 'package:jetwallet/utils/models/currency_model.dart';

part 'send_gift_info_model.freezed.dart';
part 'send_gift_info_model.g.dart';

@freezed
class SendGiftInfoModel with _$SendGiftInfoModel {
  const factory SendGiftInfoModel({
    CurrencyModel? currency,
    Decimal? amount,
    ReceiverContacrType? selectedContactType,
    String? email,
    String? phoneBody,
    String? phoneCountryCode,
  }) = _SendGiftInfoModel;

  factory SendGiftInfoModel.fromJson(Map<String, dynamic> json) => _$SendGiftInfoModelFromJson(json);
}
