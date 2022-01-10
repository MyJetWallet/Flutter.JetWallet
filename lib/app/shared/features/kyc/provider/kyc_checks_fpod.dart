import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/providers/service_providers.dart';
import '../../../providers/client_detail_pod/client_detail_spod.dart';
import '../model/kyc_operation_status_model.dart';
import '../model/kyc_verified_model.dart';

final kycChecksFpod = FutureProvider.autoDispose<KycVerifiedModel>((ref) async {
  final clientDetail = ref.watch(clientDetailSpod);
  final kycChecksService = ref.read(kysServicePod);
  final response = await kycChecksService.kycChecks();

  var value = const KycVerifiedModel();

  clientDetail.whenData((clientDetailData) {
    final documents = <KycDocumentType>[];
    if (response.allowedDocuments.isNotEmpty) {
      response.allowedDocuments.sort((a, b) => a.compareTo(b));

      for (final document in response.allowedDocuments) {
        documents.add(kycDocumentType(document));
      }
    }

    final requiredVerified = <RequiredVerified>[];
    if (response.requiredVerifications.isNotEmpty) {
      response.requiredVerifications.sort((a, b) => a.compareTo(b));

      for (final item in response.requiredVerifications) {
        requiredVerified.add(requiredVerifiedStatus(item));
      }
    }

    value = KycVerifiedModel(
      depositStatus: clientDetailData.depositStatus,
      sellStatus: clientDetailData.tradeStatus,
      withdrawalStatus: clientDetailData.withdrawalStatus,
      requiredVerifications: requiredVerified,
      requiredDocuments: documents,
      verificationInProgress: response.verificationInProgress,
    );
  });

  print('KycVerifiedModel123 $value');

  return value;
});
