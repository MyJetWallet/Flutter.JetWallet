import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/key_value/model/key_value_request_model.dart';
import '../../../../../service/services/signal_r/model/key_value_model.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';

class KeyValueNotifier extends StateNotifier<KeyValueModel> {
  KeyValueNotifier({
    required this.read,
    required this.keyValue,
  }) : super(const KeyValueModel(
          now: 0,
          keys: [],
        )) {
    keyValue.whenData(
      (data) {
        print('serialized=======$data');
        state = data;
      },
    );
  }

  final Reader read;
  final AsyncValue<KeyValueModel> keyValue;

  static final _logger = Logger('KeyValueNotifier');

  Future<void> addToKeyValue(KeyValueRequestModel model) async {
    _logger.log(notifier, 'addToKeyValue');

    try {
      await read(keyValueServicePod).keyValueSet(model);
    } catch (e) {
      _logger.log(notifier, 'addToKeyValue', e);
    }
  }

  Future<void> removeFromKeyValue(List<String> keys) async {
    _logger.log(notifier, 'removeFromKeyValue');

    try {
      await read(keyValueServicePod).keyValueRemove(keys);
    } catch (e) {
      _logger.log(notifier, 'removeFromKeyValue', e);
    }
  }
}
