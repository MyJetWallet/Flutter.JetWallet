import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_request_model.dart';

@lazySingleton
class KeyValuesService {
  static final _logger = Logger('KeyValueStore');

  Future<void> addToKeyValue(KeyValueRequestModel model) async {
    _logger.log(notifier, 'addToKeyValue');

    try {
      final _ = sNetwork.getWalletModule().postSetKeyValue(model);
    } catch (e) {
      _logger.log(stateFlow, 'addToKeyValue', e);
    }
  }

  Future<void> removeFromKeyValue(List<String> keys) async {
    _logger.log(notifier, 'removeFromKeyValue');

    try {
      final _ = sNetwork.getWalletModule().postRemoveKeyValue(keys);
    } catch (e) {
      _logger.log(stateFlow, 'removeFromKeyValue', e);
    }
  }
}
