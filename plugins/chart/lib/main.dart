import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import './flutter_k_chart.dart';
import './k_chart_widget.dart';
import 'entity/candle_type_enum.dart';
import 'entity/chart_info.dart';
import 'entity/resolution_string_enum.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: FutureBuilder(
        future: mockCandles(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Chart(
              onResolutionChanged: (resolution) {},
              onChartTypeChanged: (chartType) {},
              onCandleSelected: (candleEntity) {},
              candles: snapshot.data,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Future<List<CandleModel>> mockCandles(BuildContext context) async {
    final data = await DefaultAssetBundle.of(context)
        .loadString('assets/candles_mock.json');
    final newCandles = (json.decode(data) as List)
        .map((e) => CandleModel.fromJson(e))
        .toList();
    return newCandles;
  }
}

class Chart extends StatefulWidget {
  const Chart({
    Key? key,
    required this.onResolutionChanged,
    required this.onChartTypeChanged,
    required this.onCandleSelected,
    required this.candles,
    this.chartType = ChartType.line,
    this.candleResolution = Period.day,
    this.walletCreationDate,
  }) : super(key: key);

  final void Function(String) onResolutionChanged;
  final void Function(ChartType) onChartTypeChanged;
  final void Function(ChartInfo?) onCandleSelected;
  final List<CandleModel> candles;
  final ChartType chartType;
  final String candleResolution;
  final String? walletCreationDate;

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  ChartInfo? _chartInfo;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 32.w;
    final candleWidth = screenWidth / widget.candles.length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Stack(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                child: KChartWidget(
                  widget.candles,
                  candleType: widget.chartType,
                  candleWidth: candleWidth,
                  getData: (_, __, ___) {},
                  candleResolution: widget.candleResolution,
                  onCandleSelected: (ChartInfo? chartInfo) {
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      _chartInfo = chartInfo;
                      widget.onCandleSelected(_chartInfo);
                      setState(() {});

                      setState(() {
                        _chartInfo = chartInfo;
                        widget.onCandleSelected(_chartInfo);
                      });
                    });
                  },
                ),
              ),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: <Widget>[
              button(
                Period.day,
                color: widget.candleResolution == Period.day
                    ? Colors.blue.shade200
                    : null,
                onPressed: widget.candleResolution == Period.day
                    ? null
                    : () => widget.onResolutionChanged(Period.day),
              ),
              button(
                Period.week,
                color: widget.candleResolution == Period.week
                    ? Colors.blue.shade200
                    : null,
                onPressed: widget.candleResolution == Period.week
                    ? null
                    : () => widget.onResolutionChanged(Period.week),
              ),
              button(
                Period.month,
                color: widget.candleResolution == Period.month
                    ? Colors.blue.shade200
                    : null,
                onPressed: widget.candleResolution == Period.month
                    ? null
                    : () => widget.onResolutionChanged(Period.month),
              ),
              button(
                Period.year,
                color: widget.candleResolution == Period.year
                    ? Colors.blue.shade200
                    : null,
                onPressed: widget.candleResolution == Period.year
                    ? null
                    : () => widget.onResolutionChanged(Period.year),
              ),
              button(
                Period.all,
                color: widget.candleResolution == Period.all
                    ? Colors.blue.shade200
                    : null,
                onPressed: widget.candleResolution == Period.all
                    ? null
                    : () => widget.onResolutionChanged(Period.all),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget button(
    String text, {
    VoidCallback? onPressed,
    Color? color,
  }) {
    return SizedBox(
      width: 0.15.sw,
      child: MaterialButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed();
            setState(() {});
          }
        },
        color: color ?? Colors.blue,
        child: Text(text),
      ),
    );
  }
}
