import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/chart/model/chart_input.dart';

ChartInput balanceChartInput() {
  final clientDetail = sSignalRModules.clientDetail;

  return ChartInput(creationDate: clientDetail.walletCreationDate);
}
