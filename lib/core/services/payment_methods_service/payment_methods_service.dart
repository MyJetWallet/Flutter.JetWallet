import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:mobx/mobx.dart';

part 'payment_methods_service.g.dart';

final sPaymentMethod = getIt.get<PaymentMethodService>();

class PaymentMethodService = _PaymentMethodServiceBase
    with _$PaymentMethodService;

abstract class _PaymentMethodServiceBase with Store {
  @action
  void init() {
    sSignalRModules.assetPaymentMethods.listen((value) {
      paymentMethods.clear();for (final asset in value.assets) {
        for (final method in asset.buyMethods) {
          paymentMethods.add(method.type.toString());
        }
      }
    });
  }

  @observable
  List<String> paymentMethods = [];
}
