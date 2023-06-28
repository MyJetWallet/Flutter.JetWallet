import 'package:mobx/mobx.dart';

part 'verification_store.g.dart';

class VerificationStore = _VerificationStoreBase with _$VerificationStore;

enum VerificationScreenStep { Email, Phone, PersonalDetail, Pin }

abstract class _VerificationStoreBase with Store {
  @observable
  VerificationScreenStep step = VerificationScreenStep.Phone;

  @observable
  bool isEmailDone = true;
  @action
  void setEmailDone(bool value) => isEmailDone = value;

  @observable
  bool isPhoneDone = false;

  @observable
  bool isRefreshPin = false;

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
    step = VerificationScreenStep.PersonalDetail;
  }

  @action
  void setRefreshPin() {
    isRefreshPin = true;
  }

  @action
  void personalDetailDone() {
    isPersonalDetailsDone = true;
    step = VerificationScreenStep.Pin;
  }

  @action
  void clear() {
    step = VerificationScreenStep.Phone;
    isEmailDone = false;
    isPhoneDone = false;
    isPersonalDetailsDone = false;
    isCreatePinDone = false;
  }
}
