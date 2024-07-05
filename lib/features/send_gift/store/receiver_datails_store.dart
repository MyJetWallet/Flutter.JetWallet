import 'package:mobx/mobx.dart';

import '../../../core/di/di.dart';
import '../../../core/services/local_cache/local_cache_service.dart';
import '../../../utils/helpers/string_helper.dart';

part 'receiver_datails_store.g.dart';

enum ReceiverContacrType { email, phone }

class ReceiverDatailsStore = ReceiverDatailsStoreBase with _$ReceiverDatailsStore;

abstract class ReceiverDatailsStoreBase with Store {
  @computed
  bool get isformValid {
    return (selectedContactType == ReceiverContacrType.email ? isEmailValid(email) : phoneValid) && checkIsSelected;
  }

  @observable
  ReceiverContacrType selectedContactType = ReceiverContacrType.email;

  @observable
  String email = '';

  @observable
  String phoneBody = '';

  @observable
  String phoneCountryCode = '';

  @observable
  bool showEmailError = false;

  @observable
  bool phoneValid = false;

  @observable
  bool checkIsSelected = false;

  @action
  void onChangedEmail(String newEmail) {
    email = newEmail;
    showEmailError = false;
  }

  @action
  Future<void> onChangedPhone(
    String newPhoneBody,
    String newPhoneCountryCode,
  ) async {
    phoneBody = newPhoneBody;
    phoneCountryCode = newPhoneCountryCode;
    phoneValid = await isPhoneNumberValid(
      newPhoneCountryCode + newPhoneBody,
      null,
    );
  }

  @action
  Future<void> onChangedCheck() async {
    checkIsSelected = !checkIsSelected;
    showEmailError = !isEmailValid(email);
    await getIt<LocalCacheService>().saveGiftPolicyAgreed(checkIsSelected);
  }

  @action
  Future<void> onButtonTaped() async {
    showEmailError = !isEmailValid(email);
  }

  @action
  Future<void> getInitialCheck() async {
    try {
      checkIsSelected = await getIt<LocalCacheService>().getGiftPolicyAgreed() ?? false;
    } catch (e) {
      checkIsSelected = false;
    }
  }
}
