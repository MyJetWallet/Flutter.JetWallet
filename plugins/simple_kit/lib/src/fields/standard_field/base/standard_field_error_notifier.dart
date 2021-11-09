import 'package:flutter/foundation.dart';

class StandardFieldErrorNotifier extends ValueNotifier<bool> {
  StandardFieldErrorNotifier() : super(false);

  void enableError() {
    value = true;
  }

  void disableError() {
    value = false;
  }
}
