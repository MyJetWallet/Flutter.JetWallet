import 'package:freezed_annotation/freezed_annotation.dart';

part 'p2p_payment_data.freezed.dart';
part 'p2p_payment_data.g.dart';

@freezed
class P2PPaymentData with _$P2PPaymentData {
  const factory P2PPaymentData({
    required String receiveMethodId,
  }) = _P2PPaymentData;

  factory P2PPaymentData.fromJson(Map<String, dynamic> json) => _$P2PPaymentDataFromJson(json);
}
