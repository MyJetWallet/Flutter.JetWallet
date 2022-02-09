import 'package:flutter/material.dart';

import './simple_chart.dart';

bool showAnimation = false;

// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.grey,
//       ),
//       home: FutureBuilder(
//         future: _mockCandles(context),
//         builder:
//             (BuildContext context, AsyncSnapshot<List<CandleModel>> snapshot)
//             {
//           if (snapshot.hasData) {
//             return Chart(
//               onResolutionChanged: (resolution) {},
//               onChartTypeChanged: (chartType) {},
//               onCandleSelected: (candleEntity) {},
//               candles: snapshot.data!,
//               candleResolution: Period.day,
//               chartHeight: 0,
//               chartWidgetHeight: 0,
//               isAssetChart: true,
//               animationController: AnimationController(),
//             );
//           } else {
//             return Container();
//           }
//         },
//       ),
//     );
//   }
//
//   Future<List<CandleModel>> _mockCandles(BuildContext context) async {
//     final data = await DefaultAssetBundle.of(context)
//         .loadString('assets/candles_mock.json');
//     final newCandles = (json.decode(data) as List)
//         .map((e) => CandleModel.fromJson(e as Map<String, dynamic>))
//         .toList();
//     return newCandles;
//   }
// }

class Chart extends StatefulWidget {
  const Chart({
    Key? key,
    required this.onResolutionChanged,
    required this.onChartTypeChanged,
    required this.onCandleSelected,
    required this.candles,
    required this.candleResolution,
    required this.chartHeight,
    required this.chartWidgetHeight,
    required this.isAssetChart,
    required this.loader,
    this.chartType = ChartType.line,
    this.walletCreationDate,
    this.selectedCandlePadding,
  }) : super(key: key);

  final void Function(String) onResolutionChanged;
  final void Function(ChartType) onChartTypeChanged;
  final void Function(ChartInfoModel?) onCandleSelected;
  final List<CandleModel>? candles;
  final ChartType chartType;
  final String candleResolution;
  final String? walletCreationDate;
  final double? selectedCandlePadding;
  final double chartHeight;
  final double chartWidgetHeight;
  final bool isAssetChart;
  final Widget loader;

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> with SingleTickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(5.0, 0.0),
  ).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    ),
  );
  ChartInfoModel? _chartInfo;

  @override
  void initState() {
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final chartWidth = screenWidth - 24;
    var candleWidth = 0.0;
    if (widget.candles != null) {
      candleWidth = chartWidth / widget.candles!.length;
    }

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
      showWeek = dateDifference > const Duration(days: 7).inHours;
      showMonth = dateDifference > const Duration(days: 30).inHours;
      showYear = dateDifference > const Duration(days: 365).inHours;
    }

    if (showAnimation) {
      animationController.reset();
      animationController.forward();
      showAnimation = false;
    }

    if (widget.candles == null || widget.candles!.isEmpty) {
      return LoadingChartView(
        height: widget.chartWidgetHeight,
        showLoader: widget.candles != null,
        resolution: widget.candleResolution,
        loader: widget.loader,
        onResolutionChanged: widget.onResolutionChanged,
        showWeek: showWeek,
        showMonth: showMonth,
        showYear: showYear,
        isBalanceChart: !widget.isAssetChart,
      );
    } else {
      return SizedBox(
        height: widget.chartWidgetHeight,
        width: screenWidth,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              SizedBox(
                height: widget.chartHeight,
                width: screenWidth,
                child: Stack(
                  children: [
                    KChartWidget(
                      widget.candles ?? [],
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
                      selectedCandlePadding: widget.selectedCandlePadding,
                      isAssetChart: widget.isAssetChart,
                    ),
                    SlideTransition(
                      position: _offsetAnimation,
                      child: Container(
                        color: Colors.white,
                        height: widget.isAssetChart ? 230 : 190,
                        width: screenWidth,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 37,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _resolutionButton(
                      text: Period.day,
                      showUnderline: widget.candleResolution == Period.day,
                      onTap: widget.candleResolution == Period.day
                          ? null
                          : () {
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
                                widget.onResolutionChanged(Period.year);
                              },
                      ),
                    _resolutionButton(
                      text: Period.all,
                      showUnderline: widget.candleResolution == Period.all,
                      onTap: widget.candleResolution == Period.all
                          ? null
                          : () {
                              widget.onResolutionChanged(Period.all);
                            },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class LoadingChartView extends StatelessWidget {
  const LoadingChartView({
    Key? key,
    this.showWeek = true,
    this.showMonth = true,
    this.showYear = true,
    required this.height,
    required this.showLoader,
    required this.resolution,
    required this.loader,
    required this.onResolutionChanged,
    required this.isBalanceChart,
  }) : super(key: key);

  final double height;
  final bool showLoader;
  final Widget loader;
  final String resolution;
  final void Function(String) onResolutionChanged;
  final bool showWeek;
  final bool showMonth;
  final bool showYear;
  final bool isBalanceChart;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: const Color(0xFFF1F4F8),
      child: Stack(
        children: [
          if (showLoader)
            Positioned(
              left: 0,
              right: 0,
              top: 80,
              child: loader,
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: isBalanceChart ? 40 : 0,
            child: SizedBox(
              height: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _resolutionButton(
                    text: Period.day,
                    showUnderline: resolution == Period.day,
                    onTap: resolution == Period.day
                        ? null
                        : () {
                            onResolutionChanged(Period.day);
                          },
                  ),
                  if (showWeek)
                    _resolutionButton(
                      text: Period.week,
                      showUnderline: resolution == Period.week,
                      onTap: resolution == Period.week
                          ? null
                          : () {
                              onResolutionChanged(Period.week);
                            },
                    ),
                  if (showMonth)
                    _resolutionButton(
                      text: Period.month,
                      showUnderline: resolution == Period.month,
                      onTap: resolution == Period.month
                          ? null
                          : () {
                              onResolutionChanged(Period.month);
                            },
                    ),
                  if (showYear)
                    _resolutionButton(
                      text: Period.year,
                      showUnderline: resolution == Period.year,
                      onTap: resolution == Period.year
                          ? null
                          : () {
                              onResolutionChanged(Period.year);
                            },
                    ),
                  _resolutionButton(
                    text: Period.all,
                    showUnderline: resolution == Period.all,
                    onTap: resolution == Period.all
                        ? null
                        : () {
                            onResolutionChanged(Period.all);
                          },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _resolutionButton({
  void Function()? onTap,
  required String text,
  required bool showUnderline,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(
        height: 12.5,
      ),
      Container(
        width: 36,
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
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
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 1.5,
      ),
      if (showUnderline)
        Container(
          width: 36,
          height: 3,
          margin: const EdgeInsets.only(
            top: 5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Colors.black,
          ),
        )
      else
        const SizedBox(
          height: 8,
        )
    ],
  );
}
