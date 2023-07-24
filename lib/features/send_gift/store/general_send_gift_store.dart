import 'package:decimal/decimal.dart';
import 'package:jetwallet/features/send_gift/store/receiver_datails_store.dart';
import 'package:mobx/mobx.dart';

import '../../../utils/models/currency_model.dart';

part 'general_send_gift_store.g.dart';

class GeneralSendGiftStore = GeneralSendGiftStoreBase
    with _$GeneralSendGiftStore;

abstract class GeneralSendGiftStoreBase with Store {
  @observable
  late CurrencyModel currency = CurrencyModel.empty();

  @observable
  Decimal amount = Decimal.zero;

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
    amount = Decimal.parse(value);
  }
}
