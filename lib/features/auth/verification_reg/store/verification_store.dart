import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:mobx/mobx.dart';

part 'verification_store.g.dart';

class VerificationStore = _VerificationStoreBase with _$VerificationStore;

enum VerificationScreenStep { email, phone, personalDetail, pin }

abstract class _VerificationStoreBase with Store {
  @observable
  VerificationScreenStep step = VerificationScreenStep.phone;

  @observable
  bool isEmailDone = true;
  @action
  void setEmailDone(bool value) => isEmailDone = value;

  @observable
  bool isPhoneDone = false;

  @observable
  bool isRefreshPin = false;

  @computed
  bool get showPhoneNumberSteep {
    return getIt.get<KycService>().requiredVerifications.contains(RequiredVerified.proofOfPhone) &&
        sUserInfo.phone != '';
  }

  @action
  void setPhoneDone(bool value) => isPhoneDone = value;

  @observable
  bool isPersonalDetailsDone = false;
  @action
  void setPersonalDetailsDone(bool value) => isPersonalDetailsDone = value;

  @observable
  bool isCreatePinDone = false;
  @action
  void setCreatePinDone(bool value) => isCreatePinDone = value;

  @action
  void phoneDone() {
    isPhoneDone = true;
    step = VerificationScreenStep.personalDetail;
  }

  @action
  void setRefreshPin() {
    isRefreshPin = true;
  }

  @action
  void personalDetailDone() {
    isPersonalDetailsDone = true;
    step = VerificationScreenStep.pin;
  }

  @action
  void clear() {
    step = VerificationScreenStep.phone;
    isEmailDone = false;
    isPhoneDone = false;
    isPersonalDetailsDone = false;
    isCreatePinDone = false;
  }
}
