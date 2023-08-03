import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/signal_r/models/global_send_methods_model.dart';

part 'send_card_payment_method_store.g.dart';

class SendCardPaymentMethodStore extends _SendCardPaymentMethodStoreBase
    with _$SendCardPaymentMethodStore {
  SendCardPaymentMethodStore() : super();

  static SendCardPaymentMethodStore of(BuildContext context) =>
      Provider.of<SendCardPaymentMethodStore>(context, listen: false);
}

abstract class _SendCardPaymentMethodStoreBase with Store {
  @observable
  TextEditingController searchController = TextEditingController();

  @computed
  bool get showSearch => globalSendMethods.length >= 7;

  @observable
  ObservableList<GlobalSendMethodsModelMethods> globalSendMethods =
      ObservableList.of([]);

  @observable
  ObservableList<GlobalSendMethodsModelMethods> filtedGlobalSendMethods =
      ObservableList.of([]);

  @action
  void init(String countryCode) {
    globalSendMethods = ObservableList.of(getCountryMethodsList(countryCode));

    globalSendMethods.sort((a, b) => b.weight!.compareTo(a.weight!));

    filtedGlobalSendMethods = ObservableList.of(globalSendMethods.toList());
  }

  @action
  void search(String val) {
    if (val.isEmpty) {
      filtedGlobalSendMethods = ObservableList.of(globalSendMethods.toList());
    } else {
      filtedGlobalSendMethods = ObservableList.of(globalSendMethods.toList());

      filtedGlobalSendMethods.removeWhere((element) {
        return !element.name!.toLowerCase().startsWith(val);
      });
    }
  }
}

List<GlobalSendMethodsModelMethods> getCountryMethodsList(String countryCode) {
  final globalSendMethods = <GlobalSendMethodsModelMethods>[];

  for (var i = 0; i < sSignalRModules.globalSendMethods!.methods!.length; i++) {
    if (sSignalRModules.globalSendMethods!.methods![i].countryCodes != null &&
        sSignalRModules
            .globalSendMethods!.methods![i].countryCodes!.isNotEmpty) {
      for (var q = 0;
          q <
              sSignalRModules
                  .globalSendMethods!.methods![i].countryCodes!.length;
          q++) {
        if (sSignalRModules
                .globalSendMethods!.methods![i].countryCodes![q].isNotEmpty &&
            sSignalRModules.globalSendMethods!.methods![i].countryCodes![q] ==
                countryCode) {
          globalSendMethods.add(
            sSignalRModules.globalSendMethods!.methods![i],
          );
        }
      }
    }
  }

  return globalSendMethods;
}
