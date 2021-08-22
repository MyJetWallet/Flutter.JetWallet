import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'model/key_value_request_model.dart';
import 'services/remove_key_value_service.dart';
import 'services/set_key_value_service.dart';

class KeyValueService {
  KeyValueService(this.dio);

  final Dio dio;

  static final logger = Logger('KeyValueService');

  Future<void> keyValueRemove(List<String> keys) {
    return removeKeyValueService(dio, keys);
  }

  Future<void> keyValueSet(KeyValueRequestModel model) {
    return setKeyValueService(dio, model);
  }
}
