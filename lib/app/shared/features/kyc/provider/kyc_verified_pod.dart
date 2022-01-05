import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/client_detail_pod/client_detail_spod.dart';
import '../model/kyc_verified_model.dart';

final kycVerifiedPod = Provider.autoDispose<KycVerifiedModel>((ref) {
  ref.maintainState = true;

  final clientDetail = ref.watch(clientDetailSpod);
  var value = const KycVerifiedModel();

  clientDetail.whenData((clientDetailData) {
    value = KycVerifiedModel(
      depositStatus: clientDetailData.depositStatus,
      tradeStatus: clientDetailData.tradeStatus,
      withdrawalStatus: clientDetailData.withdrawalStatus,
      requiredVerifications: clientDetailData.requiredVerifications,
      requiredDocuments: clientDetailData.requiredDocuments,
    );
  });

  return value;
});
