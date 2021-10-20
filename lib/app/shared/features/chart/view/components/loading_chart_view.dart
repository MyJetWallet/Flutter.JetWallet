import 'package:charts/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/components/loaders/loader.dart';

class LoadingChartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 0.6.sh,
          width: double.infinity,
          child: Chart(
            onResolutionChanged: (_) {},
            onChartTypeChanged: (_) {},
            onCandleSelected: (_) {},
            candles: const [],
          ),
        ),
        const Loader(),
      ],
    );
  }
}
