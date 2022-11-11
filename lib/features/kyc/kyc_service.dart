import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:mobx/mobx.dart';

part 'kyc_service.g.dart';

class KycService = _KycServiceBase with _$KycService;

abstract class _KycServiceBase with Store {
  _KycServiceBase() {
    init();
  }

  @observable
  int depositStatus = 0;

  @observable
  int sellStatus = 0;

  @observable
  int withdrawalStatus = 0;

  @observable
  ObservableList<KycDocumentType> requiredDocuments = ObservableList.of([]);

  @observable
  ObservableList<RequiredVerified> requiredVerifications =
      ObservableList.of([]);

  @observable
  bool verificationInProgress = false;

  @computed
  bool get inVerificationProgress => verificationInProgress;

  @action
  void init() {
    final documents = <KycDocumentType>[];

    if (sSignalRModules.clientDetail.requiredDocuments.isNotEmpty) {
      final sorted = sSignalRModules.clientDetail.requiredDocuments.toList();
      sorted.sort((a, b) => a.compareTo(b));

      sSignalRModules.clientDetail.copyWith(
        requiredDocuments: sorted,
      );

      for (final document in sSignalRModules.clientDetail.requiredDocuments) {
        documents.add(kycDocumentType(document));
      }
    }

    final requiredVerified = <RequiredVerified>[];
    if (sSignalRModules.clientDetail.requiredVerifications.isNotEmpty) {
      for (final item in sSignalRModules.clientDetail.requiredVerifications) {
        requiredVerified.add(requiredVerifiedStatus(item));
      }
    }

    depositStatus = sSignalRModules.clientDetail.depositStatus;
    sellStatus = sSignalRModules.clientDetail.tradeStatus;
    withdrawalStatus = sSignalRModules.clientDetail.withdrawalStatus;
    requiredVerifications = ObservableList.of(requiredVerified);
    requiredDocuments = ObservableList.of(documents);
    verificationInProgress = kycInProgress(
      sSignalRModules.clientDetail.depositStatus,
      sSignalRModules.clientDetail.tradeStatus,
      sSignalRModules.clientDetail.withdrawalStatus,
    );
  }

  @action
  void updateKycStatus() {
    verificationInProgress = true;
  }
}
