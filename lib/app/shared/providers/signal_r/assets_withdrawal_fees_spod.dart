import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/asset_withdrawal_fee_model.dart';
import '../../../../shared/providers/service_providers.dart';

final assetsWithdrawalFeesSpod = StreamProvider
    .autoDispose<AssetWithdrawalFeeModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.assetWithdrawalFee();
});
