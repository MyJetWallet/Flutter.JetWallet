import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../../service/services/signal_r/model/blockchains_model.dart';

part 'withdrawal_preview_state.freezed.dart';

@freezed
class WithdrawalPreviewState with _$WithdrawalPreviewState {
  const factory WithdrawalPreviewState({
    @Default('') String tag,
    @Default('') String address,
    @Default('0') String amount,
    @Default('') String operationId,
    @Default(false) bool loading,
    @Default(false) bool addressIsInternal,
    @Default(BlockchainModel()) BlockchainModel blockchain,
  }) = _WithdrawalPreviewState;
}
