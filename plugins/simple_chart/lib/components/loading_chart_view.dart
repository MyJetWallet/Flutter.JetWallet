import 'package:flutter/material.dart';

import '../model/resolution_string_enum.dart';
import 'resolution_button.dart';

class LoadingChartView extends StatelessWidget {
  const LoadingChartView({
    super.key,
    this.showWeek = true,
    this.showMonth = true,
    this.showYear = true,
    required this.height,
    required this.showLoader,
    required this.resolution,
    required this.loader,
    required this.onResolutionChanged,
    required this.isBalanceChart,
    required this.localizedChartResolutionButton,
  });

  final double height;
  final bool showLoader;
  final Widget loader;
  final String resolution;
  final void Function(String) onResolutionChanged;
  final bool showWeek;
  final bool showMonth;
  final bool showYear;
  final bool isBalanceChart;
  final List<String> localizedChartResolutionButton;

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
              top: 30,
              child: loader,
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: isBalanceChart ? 40 : 0,
            child: SizedBox(
              height: 38,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResolutionButton(
                    text: '1${localizedChartResolutionButton[0]}',
                    showUnderline: resolution == Period.day,
                    onTap: resolution == Period.day
                        ? null
                        : () {
                            onResolutionChanged(Period.day);
                          },
                  ),
                  if (showWeek)
                    ResolutionButton(
                      text: '1${localizedChartResolutionButton[1]}',
                      showUnderline: resolution == Period.week,
                      onTap: resolution == Period.week
                          ? null
                          : () {
                              onResolutionChanged(Period.week);
                            },
                    ),
                  if (showMonth)
                    ResolutionButton(
                      text: '1${localizedChartResolutionButton[2]}',
                      showUnderline: resolution == Period.month,
                      onTap: resolution == Period.month
                          ? null
                          : () {
                              onResolutionChanged(Period.month);
                            },
                    ),
                  if (showYear)
                    ResolutionButton(
                      text: '1${localizedChartResolutionButton[3]}',
                      showUnderline: resolution == Period.year,
                      onTap: resolution == Period.year
                          ? null
                          : () {
                              onResolutionChanged(Period.year);
                            },
                    ),
                  ResolutionButton(
                    text: localizedChartResolutionButton[4],
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
