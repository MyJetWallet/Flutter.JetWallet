import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/client_detail_pod/client_detail_pod.dart';
import '../model/chart_input.dart';

final balanceChartInputStpod = StateProvider.autoDispose<ChartInput>((ref) {
  final clientDetail = ref.read(clientDetailPod);

  return ChartInput(creationDate: clientDetail.walletCreationDate);
});
