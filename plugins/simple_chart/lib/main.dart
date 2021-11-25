import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import './k_chart_widget.dart';
import './simple_chart.dart';
import 'model/candle_model.dart';
import 'model/candle_type_enum.dart';
import 'model/chart_info_model.dart';
import 'model/resolution_string_enum.dart';

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
        future: _mockCandles(context),
        builder:
            (BuildContext context, AsyncSnapshot<List<CandleModel>> snapshot) {
          if (snapshot.hasData) {
            return Chart(
              onResolutionChanged: (resolution) {},
              onChartTypeChanged: (chartType) {},
              onCandleSelected: (candleEntity) {},
              candles: snapshot.data!,
              candleResolution: Period.day,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Future<List<CandleModel>> _mockCandles(BuildContext context) async {
    final data = await DefaultAssetBundle.of(context)
        .loadString('assets/candles_mock.json');
    final newCandles = (json.decode(data) as List)
        .map((e) => CandleModel.fromJson(e as Map<String, dynamic>))
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
    required this.candleResolution,
    this.chartType = ChartType.line,
    this.walletCreationDate,
  }) : super(key: key);

  final void Function(String) onResolutionChanged;
  final void Function(ChartType) onChartTypeChanged;
  final void Function(ChartInfoModel?) onCandleSelected;
  final List<CandleModel> candles;
  final ChartType chartType;
  final String candleResolution;
  final String? walletCreationDate;

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  ChartInfoModel? _chartInfo;

  @override
  Widget build(BuildContext context) {
    // TODO(Vova): change to -24.w (left padding only)
    final screenWidth = 1.sw - 48.w;
    final candleWidth = screenWidth / widget.candles.length;

    final currentDate = DateTime.now().toLocal();
    final localCreationDate = widget.walletCreationDate == null
        ? currentDate
        : DateTime.parse('${widget.walletCreationDate}').toLocal();
    bool showWeek;
    bool showMonth;
    bool showYear;
    if (localCreationDate == currentDate) {
      showWeek = true;
      showMonth = true;
      showYear = true;
    } else {
      final dateDifference = currentDate.difference(localCreationDate).inHours;
      showWeek = dateDifference > const Duration(days: 1).inHours;
      showMonth = dateDifference > const Duration(days: 7).inHours;
      showYear = dateDifference > const Duration(days: 90).inHours;
    }

    return SizedBox(
      height: 336.h,
      width: 1.sw,
      child: Scaffold(
        body: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: 240.h,
              width: 1.sw,
              child: KChartWidget(
                widget.candles,
                candleType: widget.chartType,
                candleWidth: candleWidth,
                candleResolution: widget.candleResolution,
                onCandleSelected: (ChartInfoModel? chartInfo) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    _chartInfo = chartInfo;
                    widget.onCandleSelected(_chartInfo);

                    setState(() {
                      _chartInfo = chartInfo;
                      widget.onCandleSelected(_chartInfo);
                    });
                  });
                },
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              height: 36.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _resolutionButton(
                    text: Period.day,
                    showUnderline: widget.candleResolution == Period.day,
                    onTap: widget.candleResolution == Period.day
                        ? null
                        : () {
                            // setState(() {});
                            widget.onResolutionChanged(Period.day);
                          },
                  ),
                  if (showWeek)
                    _resolutionButton(
                      text: Period.week,
                      showUnderline: widget.candleResolution == Period.week,
                      onTap: widget.candleResolution == Period.week
                          ? null
                          : () {
                              // setState(() {});
                              widget.onResolutionChanged(Period.week);
                            },
                    ),
                  if (showMonth)
                    _resolutionButton(
                      text: Period.month,
                      showUnderline: widget.candleResolution == Period.month,
                      onTap: widget.candleResolution == Period.month
                          ? null
                          : () {
                              // setState(() {});
                              widget.onResolutionChanged(Period.month);
                            },
                    ),
                  if (showYear)
                    _resolutionButton(
                      text: Period.year,
                      showUnderline: widget.candleResolution == Period.year,
                      onTap: widget.candleResolution == Period.year
                          ? null
                          : () {
                              // setState(() {});
                              widget.onResolutionChanged(Period.year);
                            },
                    ),
                  _resolutionButton(
                    text: Period.all,
                    showUnderline: widget.candleResolution == Period.all,
                    onTap: widget.candleResolution == Period.all
                        ? null
                        : () {
                            // setState(() {});
                            widget.onResolutionChanged(Period.all);
                          },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _resolutionButton({
    void Function()? onTap,
    required String text,
    required bool showUnderline,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 36.w,
          margin: EdgeInsets.symmetric(
            horizontal: 5.w,
          ),
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              if (onTap != null) {
                onTap();
              }
            },
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        if (showUnderline)
          Container(
            width: 36.w,
            height: 3.h,
            margin: EdgeInsets.only(
              top: 5.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.r),
              color: Colors.black,
            ),
          )
        else
          SizedBox(
            height: 8.h,
          )
      ],
    );
  }
}
