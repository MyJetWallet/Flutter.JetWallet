import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:mobx/mobx.dart';

part 'kyc_service.g.dart';

class KycService = _KycServiceBase with _$KycService;

abstract class _KycServiceBase with Store {
  @computed
  int get depositStatus => sSignalRModules.clientDetail.depositStatus;

  @computed
  int get tradeStatus => sSignalRModules.clientDetail.tradeStatus;

  @computed
  int get withdrawalStatus => sSignalRModules.clientDetail.withdrawalStatus;

  @computed
  bool get useSumsub => sSignalRModules.clientDetail.useSumsub;

  @computed
  bool get isSimpleKyc {
    final sessionInfo = getIt.get<StartupService>().sessionInfo;
    final toCheckSimpleKyc = sessionInfo?.toCheckSimpleKyc ?? false;

    final kucStatysesCombination = depositStatus == kycOperationStatus(KycStatus.allowed) &&
        tradeStatus == kycOperationStatus(KycStatus.allowed) &&
        withdrawalStatus == kycOperationStatus(KycStatus.kycRequired);

    return kucStatysesCombination && !toCheckSimpleKyc;
  }

  @computed
  List<KycDocumentType> get requiredDocuments {
    final documents = <KycDocumentType>[];

    var reqDocs = sSignalRModules.clientDetail.requiredDocuments.toList();

    if (reqDocs.isNotEmpty) {
      final sorted = reqDocs.toList();
      sorted.sort((a, b) => a.compareTo(b));

      reqDocs = sorted;

      for (final document in reqDocs) {
        documents.add(kycDocumentType(document));
      }
    }

    return documents;
  }

  @computed
  List<RequiredVerified> get requiredVerifications {
    final requiredVerified = <RequiredVerified>[];

    if (sSignalRModules.clientDetail.requiredVerifications.isNotEmpty) {
      for (final item in sSignalRModules.clientDetail.requiredVerifications) {
        requiredVerified.add(requiredVerifiedStatus(item));
      }
    }

    return requiredVerified;
  }

  @observable
  bool manualUpdateKycStatus = false;

  @computed
  bool get verificationInProgress => !manualUpdateKycStatus
      ? kycInProgress(
          sSignalRModules.clientDetail.depositStatus,
          sSignalRModules.clientDetail.tradeStatus,
          sSignalRModules.clientDetail.withdrawalStatus,
        )
      : manualUpdateKycStatus;

  @computed
  bool get inVerificationProgress => verificationInProgress;

  @action
  void updateKycStatus() {
    manualUpdateKycStatus = true;
  }
}
