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
    this.chartType = ChartType.line,
    this.walletCreationDate,
    this.selectedCandlePadding,
  }) : super(key: key);

  final void Function(String) onResolutionChanged;
  final void Function(ChartType) onChartTypeChanged;
  final void Function(ChartInfoModel?) onCandleSelected;
  final List<CandleModel> candles;
  final ChartType chartType;
  final String candleResolution;
  final String? walletCreationDate;
  final double? selectedCandlePadding;
  final double chartHeight;
  final double chartWidgetHeight;
  final bool isAssetChart;

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
    final candleWidth = chartWidth / widget.candles.length;

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
                    selectedCandlePadding: widget.selectedCandlePadding,
                    isAssetChart: widget.isAssetChart,
                  ),
                  SlideTransition(
                    position: _offsetAnimation,
                    child: Container(
                      color: Colors.white,
                      height: 190,
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
              height: 36,
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
            const SizedBox(
              height: 40,
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
}
