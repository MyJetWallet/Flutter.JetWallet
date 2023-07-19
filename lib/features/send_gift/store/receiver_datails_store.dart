import 'package:mobx/mobx.dart';

import '../../../core/di/di.dart';
import '../../../core/services/local_cache/local_cache_service.dart';
import '../../../utils/helpers/string_helper.dart';

part 'receiver_datails_store.g.dart';

enum ReceiverContacrType { email, phone }

class ReceiverDatailsStore = ReceiverDatailsStoreBase
    with _$ReceiverDatailsStore;

abstract class ReceiverDatailsStoreBase with Store {
  @computed
  bool get isformValid {
    return (selectedContactType == ReceiverContacrType.email
            ? emailValid
            : phoneValid) &&
        checkIsSelected;
  }

  @observable
  ReceiverContacrType selectedContactType = ReceiverContacrType.email;

  @observable
  String email = '';

  @observable
  String phone = '';

  @observable
  bool emailValid = false;

  @observable
  bool phoneValid = false;

  @observable
  bool checkIsSelected = false;

  @action
  void onChangedEmail(String newEmail) {
    email = newEmail;
    emailValid = isEmailValid(newEmail);
  }

  @action
  Future<void> onChangedPhone(String newPhone) async {
    phone = newPhone;
    phoneValid = await isPhoneNumberValid(newPhone, null);
  }

  @action
  Future<void> onChangedCheck() async {
    checkIsSelected = !checkIsSelected;

    await getIt<LocalCacheService>().saveGiftPolicyAgreed(checkIsSelected);
  }

  @action
  Future<void> getInitialCheck() async {
    checkIsSelected =
        await getIt<LocalCacheService>().getGiftPolicyAgreed() ?? false;
  }
}
