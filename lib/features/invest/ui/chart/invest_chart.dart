import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:jetwallet/features/invest/ui/chart/tvchart/tvchart.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';

class InvestChart extends StatefulObserverWidget {
  const InvestChart({
    super.key,
    required this.instrument,
    required this.chartType,
    required this.chartInterval,
    required this.width,
    required this.height,
  });

  final InvestInstrumentModel instrument;
  final String chartType;
  final String chartInterval;
  final String width;
  final String height;

  @override
  State<InvestChart> createState() => _InvestChartState();
}

class _InvestChartState extends State<InvestChart> {
  late WebViewController? controllerWeb;
  late String html;

  @override
  void initState() {
    super.initState();

    html = '';
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: MediaQuery.of(context).size.height - 575,
      child: TVChart(
        instrument: widget.instrument.name ?? '',
        instrumentId: widget.instrument.symbol ?? '',
      ),
    );
  }
}
