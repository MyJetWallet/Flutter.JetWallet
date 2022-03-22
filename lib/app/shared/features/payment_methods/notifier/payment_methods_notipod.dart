import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'payment_methods_notifier.dart';
import 'payment_methods_state.dart';

final paymentMethodsNotipod = StateNotifierProvider.autoDispose<
    PaymentMethodsNotifier, PaymentMethodsState>(
  (ref) {
    return PaymentMethodsNotifier(ref.read);
  },
  name: 'paymentMethodsNotipod',
);
