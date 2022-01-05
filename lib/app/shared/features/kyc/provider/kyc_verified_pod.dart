import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/client_detail_pod/client_detail_spod.dart';
import '../model/kyc_operation_status_model.dart';
import '../model/kyc_verified_model.dart';

final kycVerifiedPod = Provider.autoDispose<KycVerifiedModel>((ref) {
  ref.maintainState = true;

  final clientDetail = ref.watch(clientDetailSpod);
  var value = const KycVerifiedModel();

  clientDetail.whenData((clientDetailData) {

    final documents = <KycDocumentType>[];
    if (clientDetailData.requiredDocuments.isNotEmpty) {
      clientDetailData.requiredDocuments.sort((a, b) => a.compareTo(b));

      for (final document in clientDetailData.requiredDocuments) {
        documents.add(kycDocumentType(document));
      }
    }

    final requiredVerified = <RequiredVerified>[];
    if (clientDetailData.requiredVerifications.isNotEmpty) {
      clientDetailData.requiredVerifications.sort((a, b) => a.compareTo(b));

      for (final item in clientDetailData.requiredVerifications) {
        requiredVerified.add(requiredVerifiedStatus(item));
      }
    }

    value = KycVerifiedModel(
      depositStatus: clientDetailData.depositStatus,
      sellStatus: clientDetailData.tradeStatus,
      withdrawalStatus: clientDetailData.withdrawalStatus,
      requiredVerifications: requiredVerified,
      requiredDocuments: documents,
    );
  });

  return value;
});
