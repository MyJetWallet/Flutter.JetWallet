import 'package:jetwallet/features/send_gift/store/receiver_datails_store.dart';
import 'package:mobx/mobx.dart';

import '../../../utils/models/currency_model.dart';

part 'send_gift_store.g.dart';

class SendGiftStore = SendGiftStoreBase with _$SendGiftStore;

abstract class SendGiftStoreBase with Store {
  @observable
  late CurrencyModel currency = CurrencyModel.empty();

  @observable
  double amount = 0;

  ReceiverContacrType _selectedContactType = ReceiverContacrType.email;
  String _email = '';
  String _phone = '';
  @observable
  String receiverContact = '';

  @action
  void setReceiverInformation({
    required ReceiverContacrType selectedContactType,
    String? email,
    String? phone,
  }) {
    _selectedContactType = selectedContactType;
    _email = email!;
    _phone = phone!;
    switch (selectedContactType) {
      case ReceiverContacrType.email:
        receiverContact = email;
        break;
      case ReceiverContacrType.phone:
        receiverContact = phone;
        break;
    }
  }

  @action
  void setCurrency(CurrencyModel newCurrency) {
    currency = newCurrency;
  }

  @action
  void updateAmount(String value) {
    amount = double.parse(value);
  }
}
