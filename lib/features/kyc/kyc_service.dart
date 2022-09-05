import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
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
    sSignalRModules.clientDetails.listen(
      (clientDetailData) {
        final documents = <KycDocumentType>[];

        print('KYC');
        print(clientDetailData.requiredDocuments);

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

        depositStatus = clientDetailData.depositStatus;
        sellStatus = clientDetailData.tradeStatus;
        withdrawalStatus = clientDetailData.withdrawalStatus;
        requiredVerifications = ObservableList.of(requiredVerified);
        requiredDocuments = ObservableList.of(documents);
        verificationInProgress = kycInProgress(
          clientDetailData.depositStatus,
          clientDetailData.tradeStatus,
          clientDetailData.withdrawalStatus,
        );
      },
    );
  }

  @action
  void updateKycStatus() {
    verificationInProgress = true;
  }
}
