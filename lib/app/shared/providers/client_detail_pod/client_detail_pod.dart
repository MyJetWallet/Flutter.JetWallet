import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/client_detail_model.dart';

import 'client_detail_spod.dart';

final clientDetailPod = Provider.autoDispose<ClientDetailModel>((ref) {
  final clientDetail = ref.watch(clientDetailSpod);

  var value = ClientDetailModel(
    baseAssetSymbol: 'USD',
    walletCreationDate: '',
    recivedAt: DateTime.now(),
  );

  clientDetail.whenData((data) => value = data);

  return value;
});
