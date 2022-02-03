import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../helpers/check_kyc_status.dart';

import '../../../../providers/client_detail_pod/client_detail_spod.dart';
import '../../model/kyc_operation_status_model.dart';
import '../../model/kyc_verified_model.dart';
import 'kyc_notifier.dart';

final kycNotipod =
    StateNotifierProvider.autoDispose<KycNotifier, KycModel>((ref) {
  final clientDetail = ref.watch(clientDetailSpod);
  var value = const KycModel();

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
      for (final item in clientDetailData.requiredVerifications) {
        requiredVerified.add(requiredVerifiedStatus(item));
      }
    }

    value = KycModel(
      depositStatus: clientDetailData.depositStatus,
      sellStatus: clientDetailData.tradeStatus,
      withdrawalStatus: clientDetailData.withdrawalStatus,
      requiredVerifications: requiredVerified,
      requiredDocuments: documents,
      verificationInProgress: kycInProgress(
        clientDetailData.depositStatus,
        clientDetailData.tradeStatus,
        clientDetailData.withdrawalStatus,
      ),
    );
  });

  return KycNotifier(
    read: ref.read,
    kycModel: value,
  );
});
