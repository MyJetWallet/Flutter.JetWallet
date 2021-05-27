import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/service/services/charts/model/get_candles/candles_request_model.dart';
import 'package:jetwallet/service/services/charts/model/get_candles/candles_response_model.dart';

import '../../../../../service/services/blockchain/model/deposit_address/deposit_address_request_model.dart';
import '../../../../../service/services/blockchain/model/deposit_address/deposit_address_response_model.dart';
import '../../../../../service_providers.dart';

final chartsFpod = FutureProvider.family<CandlesResponseModel, String>(
  (ref, instrumentId) {
    final chartsService = ref.watch(chartsServicePod);

    final model = CandlesRequestModel(
      instrumentId: instrumentId,
      bidOrAsk: 0,
      fromDate: 1622032561000,
      toDate: 1622039761000,
      candleType: 0,
    );

    return chartsService.getCandles(model);
  },
);
